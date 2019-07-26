# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :sell_products, class_name: 'Product', foreign_key: 'seller_id', dependent: :destroy
  has_many :buy_products, class_name: 'Product', foreign_key: 'buyer_id'
end
