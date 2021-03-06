# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


#step: 1
#update item profit_rate and rebuild item profit
include IncomeBase
@items = Item.all
@items.each do |item|
	item_profit_rebuild(item)
end


#step: 2
#update photos change staff_id to user_id
@photos = Photo.all
@photos.each do |photo|
	if photo.staff_id
		staff = Staff.find(photo.staff_id)
		user = staff.user
		photo.update_attribute(:user_id,user.id)
	else
		photo.destroy
	end
end