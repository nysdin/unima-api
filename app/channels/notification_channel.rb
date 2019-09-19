class NotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def notice(data)
    recipient = User.find_by(id: data['recipient_id'])
    product = User.find_by(id: data['product_id'])
    if recipient && product
      notification = recipient.notifications.build(action: data['action_type'], sender_id: current_user.id, product_id: product.id)
      if notification.save
        NotificationChannel.broadcast_to(recipient, notification.as_json(include: {
          sender: { only: [:id, :name] },
          product: { only: [:id, :name, :images] }
        }))
      end
    end
  end
end
