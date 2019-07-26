class Product < ApplicationRecord
    validates :name, presence: true, length: { in: 1..255 }
    validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :state, presence: true, inclusion: { in: %w(new almost_new almost_old old) }
    validates :status, presence: true, inclusion: { in: %w(open trade close) }

    belongs_to :seller, class_name: 'User'
    belongs_to :buyer, class_name: 'User'
    belongs_to :category

end
