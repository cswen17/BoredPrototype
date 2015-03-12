# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
include ActionView::Helpers::TextHelper
require 'faker'
I18n.reload!

x = 0
File.open("db/seed_data.txt").read.each_line do |image|
  x += 1
  name = Faker::Lorem.sentence(num = 2)
  summary = Faker::Lorem.sentence(num = 5)
  description = Faker::Lorem.sentence
  location = Faker::Address.city
  start_time = Time.now + ((5+rand(5)) * 60 * 60 * 24)
  end_time = start_time + ((5+rand(5)) * 60 * 60 * 24)
  flyer = image
  categories = [rand(3)+1, rand(6)+4].join(", ")
  Event.create!(
  :id => x,
	:name => truncate(name, :length => 15, :omission => '!'), 
	:summary => summary,
	:description => description, 
	:location => location, 
	:start_time => start_time, 
	:end_time => end_time, 
	:event_start => start_time,
	:event_end => end_time,
	:flyer => flyer, 
	:categories => categories,
	:organization_id => 1,
	:user_id => 1
	) 
end
