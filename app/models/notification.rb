class Notification < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'
  belongs_to :product

  validates :action, presence: true

  default_scope -> { order(created_at: :desc) }
end
