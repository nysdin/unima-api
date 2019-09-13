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
  has_many :trade_messages, dependent: :destroy
  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  validates :name, presence: true, length: { maximum: 15 }

  def like(product)
    likes.create(product_id: product.id)
  end

  def liking?(product)
    like_products.include?(product)
  end
  
  def unlike(product)
    likes.find_by(product_id: product.id).destroy
  end

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end
end
