Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  #公司制度
  resources :articles do
    post 'search',on: :collection
  end
  
  resources :notices do 
    put 'check',on: :member
  end

  #员工档案
  namespace :staffs do
    resources :bases
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

    resources :trucks,:costs,:fees,:icosts,:search,:audit,:finance,:infos
  end

  #超级管理(用户，角色，角色组)
  resources :accounts do
    post 'search',on: :collection
    get 'rolegroups',on: :member
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
end
