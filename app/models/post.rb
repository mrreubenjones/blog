class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :title, presence: true,
                  uniqueness: true


  def self.search(query)
    where(['title ILIKE ? OR body ILIKE ?', "%#{query}%", "%#{query}%"]).order("
    CASE
      WHEN title ILIKE \'%#{query}%\' THEN '1'
      WHEN body ILIKE \'%#{query}%\' THEN '2'
    END")
  end


end
