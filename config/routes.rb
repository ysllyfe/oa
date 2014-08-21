Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  #公司制度
  resources :articles do
    post 'search',on: :collection
    put 'check',on: :member
  end
  #短信平台
  resources :sms do
    get 'msgsend',on: :member
    get 'msgsending',on: :member
  end
  #公司通知
  resources :notices do 
    put 'check',on: :member
  end

  #员工档案
  namespace :staffs do
    resources :bases do 
      get 'outjob',on: :collection
      get 'needcheck',on: :collection
      get 'allchecked',on: :member
    end
    #通用用户姓名直达
    post 'ajax/search' => 'ajax#search'
    #基础信息，个人信息，部门信息，教育，家庭成员，紧急联系人
    ['base','info','departments','edu','member','contact'].each do |t|
      get "ajax/#{t}" => "ajax##{t}"
      post "ajax/#{t}" => "ajax##{t}_create"
      delete "ajax/#{t}" => "ajax##{t}_delete"
      put "ajax/#{t}" => "ajax##{t}_audit"
    end    
  end
  resources :staffs

  #基础信息
  namespace :base do
    resources :items,:factories,:fees,:steeltypes
  end

  #工程管理
  namespace :project do
    #income_costs icosts
    resources :incomes do
      get 'original',on: :member
      post 'original'=>'incomes#original!',on: :member
    end
    resources :audit do 
      put 'check',on: :collection
    end
    resources :finance do
      get 'search',on: :collection
      put 'ended',on: :collection
      put 'check',on: :member
    end
    resources :search do 
      get 'search',on: :collection
    end
    resources :infos do 
      post 'nav_search',on: :collection
    end
    resources :trucks,:costs,:fees,:icosts,:infos
  end

  #超级管理(用户，角色，角色组)
  resources :accounts do
    post 'search',on: :collection
    #get 'rolegroups',on: :member
    delete 'delete',on: :member
    #用户角色管理
    get 'roles',on: :member
    get 'role_ajax_change',on: :member
  end
  resources :roles
  resources :rolegroups do
    get 'role_ajax_change',on: :member
    get 'user_ajax_change',on: :member
    get 'users',on: :member
  end

  get 'deny' => 'home#role_deny'

  get 'session/login'
  post 'session/login' => 'session#login!'
  
  get 'session/timeout'
  post 'session/timeout' => 'session#timeout!'

  get 'session/logout'
  get 'session/forgetpasswd'
  post 'session/resetpasswd'

  get 'ueditor/image' => 'ueditor#showimage'
  post 'ueditor/imageUp' => 'ueditor#imageUp'
  post 'ueditor/imageManager' => 'ueditor#imageManager'
  post 'ueditor/getRemoteImage' => 'ueditor#getRemoteImage'
  post 'ueditor/fileUp' => 'ueditor#fileUp'
  post 'ueditor/getMovie' => 'ueditor#getMovie'



  resources :payslips do 
    get 'my',:on=>:collection
    post 'submit',:on=>:collection
    put 'check',:on=>:member
  end
  get 'notifications' => 'notifications#index'
  put 'notifications' => 'notifications#show'
  #个人相关
  resources :settings do
    collection do
      post 'passwd' => 'settings#passwd!'
      put 'userconfig'
    end
  end
end
