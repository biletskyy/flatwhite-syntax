# Ruby test

require "gem"

string = "base16"
symbol = :base16
fixnum = 0
float  = 0.00
array  = Array.new
array  = ['chris', 85]
hash   = {abc: "test"}
regexp = /[abc]/

# This is a comment
class Person

  attr_accessor :name

  def initialize(attributes = {})
    @name = attributes[:name]
  end

  def self.greet
    "hello"

    if true
      false
    end
  end
end

person1 = Person.new(:name => nil)
print Person::greet, " ", person1.name, "\n"
puts "another #{Person::greet} #{person1.name}"

catch do |obj_A|
  catch do |obj_B|
    throw(obj_B, 123)
    puts "This puts is not reached"
  end

  puts "This puts is displayed"
  456
end
