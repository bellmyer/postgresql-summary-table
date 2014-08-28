#!/usr/bin/env ruby

require_relative '../lib/initializer'

def load table_name
  File.open(File.dirname(__FILE__) + "/../data/#{table_name}.txt") do |f|
    fields = f.gets.chomp.split('|')
    
    while line = f.gets
      values = line.chomp.split('|')
      return unless values.size > 1
      data = {}
      
      values.each_with_index{ |value, i| data[fields[i]] = value }
      DB[table_name].insert(data)
    end
  end
end

DB.run("DROP TABLE IF EXISTS species")
DB.create_table :species do
  primary_key :id
  String :name
  Integer :leg_count
end

DB.run("DROP TABLE IF EXISTS pets")
DB.create_table :pets do
  primary_key :id
  String :name
  Integer :species_id
end

DB.run("DROP TABLE IF EXISTS leg_counts")
DB.create_table :leg_counts do
  primary_key :id
  Integer :leg_count
  Integer :pet_count
end

DB.run <<-SQL
  CREATE OR REPLACE FUNCTION update_leg_counts() RETURNS TRIGGER as $$
  DECLARE
   pet_leg_count INTEGER;
   pet_count INTEGER;
  BEGIN
    SELECT INTO pet_leg_count species.leg_count
      FROM species
      WHERE species.id = NEW.species_id;
    
    SELECT INTO pet_count count(*)
      FROM pets
      JOIN species ON species.id = pets.species_id
      WHERE species.leg_count = pet_leg_count;
    
    DELETE FROM leg_counts where leg_counts.leg_count = pet_leg_count;
    INSERT INTO leg_counts (leg_count, pet_count) values (pet_leg_count, pet_count);
  
    RETURN NULL;
  END;
  $$ LANGUAGE plpgsql;

  CREATE TRIGGER update_leg_counts
  AFTER INSERT ON pets
  FOR EACH ROW EXECUTE PROCEDURE update_leg_counts();
SQL

load :species
