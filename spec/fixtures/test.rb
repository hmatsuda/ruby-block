
[1,2,3].each do |n|
  puts n
end

version :default do
  # do
end
[1,2].each do |n|; puts n; end #aa

for n in 1..3 do
  puts n
end


if true
  if true
    puts 'true'
  end
elsif true
  # do
else
  #do 
end

unless true
  # do
end

# one line if/unless statement
if true
  return if true
  return unless true
  var = if 1 == 1 ? "Yes" : "No" 
  var = unless 1 == 1 ? "Yes" : "No" 
end

until true
  puts 'true'
end

if true
  while true do
    # do
  end
end

class Animal
  # define some method
end

module Taggable
  # define some method
end

case num
when 1 then
  # do
when 2 then
  # do
else
  # do
end

var = case num
when 1 then
  # do
when 2 then
  # do
else
  # do
end

def func
  # do
end

begin
  #do_something
rescue
  #recover
ensure
  #must_to_do
end
