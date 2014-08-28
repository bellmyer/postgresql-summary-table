#!/usr/bin/env ruby

require './lib/initializer'

def timer &block
  start = Time.now
  result = block.call
  
  [(Time.now - start), result]
end

def leg_counts_with_summary_table
  timer{ DB[:leg_counts].all }
end

def leg_counts_from_scratch
  timer do
    query = <<-SQL
      SELECT species.leg_count as leg_count, count(*) as pet_count
      FROM pets
      JOIN species on pets.species_id = species.id
      GROUP BY species.leg_count
    SQL
    
    DB[query].all
  end
end

def display *args
  puts sprintf("%20s  |  %20s  |  %20s  |  %20s", *(args.map(&:to_s)))
end

setup

display('pet count', 'speed w/o summary', 'speed w/ summary', 'improvement')
display(*(['-' * 20] * 4))

10.times do 
  load_pets(1000)

  pet_count = DB[:pets].count
  summary_speed = leg_counts_with_summary_table[0]
  scratch_speed = leg_counts_from_scratch[0]
  summary_improvement = (1.0 - (summary_speed/scratch_speed)) * 100
  
  display(pet_count, scratch_speed, summary_speed, sprintf('%.4f%%', summary_improvement))
end
