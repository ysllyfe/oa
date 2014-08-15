# coding: utf-8
# 在数据库中的配置信息
# 这里有存放首页,Wiki 等页面 HTML
# 使用方法
# UserConfig.foo
# UserConfig.foo = "asdkglaksdg"
class UserConfig
  #include AuthBase
  def self.method_missing(method, *args)
    method_name = method.to_s
    super(method, *args)
  rescue NoMethodError
    if method_name =~ /=$/
      var_name = method_name.gsub('=', '')
      user = args.first.to_s
      value = args.second.to_s
      # save
      if item = Setting.find_by(user_id:user,name:var_name)
        item.update_attribute(:value, value)
      else
        Setting.create(name: var_name, value: value, user_id: user)
      end
    else
      Rails.cache.fetch("user_config:#{method}_#{user}") do
        if item = find_by_key(method,user)
          item.value
        else
          nil
        end
      end
    end
  end
end
