class Product < ApplicationRecord
    mount_uploaders :images, ImageUploader
    validates :name, presence: true, length: { maximum: 40 }
    validates :description, presence: true, length: { maximum: 1000 }
    validates :price, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :state, presence: true, inclusion: { in: %w(新品、未使用 目立った傷や汚れなし やや傷れや汚れあり 全体的に状態が悪い) }
    validates :status, presence: true, inclusion: { in: %w(open trade close) }

    belongs_to :seller, class_name: 'User'
    belongs_to :buyer, class_name: 'User', optional: true
    belongs_to :category
    has_many :likes, dependent: :destroy
    has_many :liked_users, through: :likes, source: :user
    has_many :comments, dependent: :destroy
    has_many :trade_messages, dependent: :destroy

end
