#!/usr/bin/env ruby

require_relative '../lib/initializer'

new_pets = (ARGV.shift || 100).to_i
load_pets(new_pets)

puts "new pet count: #{DB[:pets].count}"