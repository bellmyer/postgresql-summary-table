require 'rubygems'
require 'sequel'

require_relative './pets.rb'

DB = Sequel.connect(ENV['DATABASE_URL'] || 'postgres://postgres:postgres@localhost/rc-postgresql-summary-table')

def load_pets new_pets
  species_list = DB[:species].all

  new_pets.times do |i|
    species = species_list[rand(species_list.size)]
    DB[:pets].insert(:name => "#{species[:name]} #{i}", :species_id => species[:id])
  end
end
