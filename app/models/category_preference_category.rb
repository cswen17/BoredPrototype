class CategoryPreferenceCategory < ActiveRecord::Base
  belongs_to :category_preference
  belongs_to :category
end
