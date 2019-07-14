class Product < ApplicationRecord
    validates :name, presence: true, length: { in: 1..255 }
    validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :state, presence: true, inclusion: { in: %w(new almost_new almost_old old) }
    validates :category, presence: true, inclusion: { in: %w(general humanity science) }

    belongs_to :user

end
