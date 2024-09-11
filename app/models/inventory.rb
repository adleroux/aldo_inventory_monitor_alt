class Inventory < ApplicationRecord
  belongs_to :store
  belongs_to :shoe_model
end
