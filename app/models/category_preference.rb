class CategoryPreference < ActiveRecord::Base
  has_many :category_preference_categories
  belongs_to :user
  has_many :categories, through: :category_preference_categories

  def identifier
    name.downcase.sub(/\s/, '-')
  end
end
