class Post < ActiveRecord::Base
  PER_PAGE = 10
  
  include Voteable
  include Sluggable
  
  belongs_to :user
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories
  
  validates :title, presence: true
  validates :url, presence: true
  validates :description, presence: true
  
  sluggable_column :title
end