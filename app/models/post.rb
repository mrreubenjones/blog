class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :comments, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  validates :title, presence: true,
                    uniqueness: true
  validates :category, presence: true

  #
  attr_accessor :tweet_this

  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]

  # Image uploader code, using CarrierWave
  mount_uploader :image, ImageUploader

  def tweet_this=(value)
    @tweet_this ||= ActiveRecord::Type::Boolean.new.cast(value)
  end

  def self.search(query)
    where(['title ILIKE ? OR body ILIKE ?', "%#{query}%", "%#{query}%"]).order("
    CASE
      WHEN title ILIKE \'%#{query}%\' THEN '1'
      WHEN body ILIKE \'%#{query}%\' THEN '2'
    END")
  end

  def all_tags=(names)
    self.tags = names.split(",").map do |name|
        Tag.where(name: name.strip).first_or_create!
    end
  end

  def all_tags
    self.tags.map(&:name).join(", ")
  end


end
