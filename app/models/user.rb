# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  mount_uploader :avatar, AvatarUploader

  has_many :sell_products, class_name: 'Product', foreign_key: 'seller_id', dependent: :destroy
  has_many :buy_products, class_name: 'Product', foreign_key: 'buyer_id'
  has_many :likes, dependent: :destroy
  has_many :like_products, through: :likes, source: :product
  has_many :comments, dependent: :destroy

  def like(product)
    likes.create(product_id: product.id)
  end

  def liking?(product)
    like_products.include?(product)
  end
  
  def unlike(product)
    likes.find_by(product_id: product.id).destroy
  end
end
