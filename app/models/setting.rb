#encoding:utf-8
class Setting < ActiveRecord::Base
	after_save :update_cache
  def update_cache
    Rails.cache.write("site_config:#{self.name}_#{self.user_id}", self.value)
  end

  def self.find_by_key(key,user)
    where(name: key.to_s,user_id: user).first
  end
end