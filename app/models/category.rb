class Category < ActiveRecord::Base
    has_and_belongs_to_many :events
    has_many :category_preference_categories
    has_many :category_preferences, through: :category_preferences_categories
end
