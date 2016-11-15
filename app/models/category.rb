class Category < ApplicationRecord
  has_many :posts, dependent: :nullify

  validates :title, presence: true

end
