# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'factory_bot_rails'

user = FactoryBot.create(:user, username: 'Dave19', password: 'pa$$word')
FactoryBot.create(:category, heading: 'Traveling', body: FFaker::Lorem.paragraph, user:)
FactoryBot.create(:category, heading: 'Clothing', body: FFaker::Lorem.paragraph, user:)
FactoryBot.create(:category, heading: 'Taxi', body: FFaker::Lorem.paragraph, user:)
FactoryBot.create(:category, heading: 'Cafes', body: FFaker::Lorem.paragraph, user:)
FactoryBot.create(:category, heading: 'Shops', body: FFaker::Lorem.paragraph, user:)
FactoryBot.create(:category, heading: 'Other', body: FFaker::Lorem.paragraph, user:)

def create_spendings(user)
  15.times do
    category = random_entity(user.categories)
    FactoryBot.create(:spending, user:, category:)
  end
end

def random_entity(scope)
  scope.order('RANDOM()').first
end

create_spendings(user)
