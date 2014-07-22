#!/usr/bin/env ruby
ROW_SIZE = 80

puts "Now Update LongJie OA..."
puts "="*ROW_SIZE
puts ""

puts_line "Install gems..." do
  `bundle install`
end

puts_line "Update database..." do 
	`rake db:migrate`
end

puts_line "Update data..." do
  `bundle exec rake db:seed`
end

puts ""
puts "LongJie OA Successfully Installed."