class Inventory < ApplicationRecord
  belongs_to :store
  belongs_to :shoe_model

  validates :quantity, presence: true, numericality: { only_integer: true }
  validates :store, presence: true
  validates :shoe_model, presence: true
end
