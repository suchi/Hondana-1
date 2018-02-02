class Book < ApplicationRecord
  # has_and_belongs_to_many :shelves
  has_many :entries
  has_many :shelves, through: :entries
end
