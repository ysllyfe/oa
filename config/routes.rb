Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  #公司制度
  resources :articles do
    post 'search',on: :collection
  end
  
  resources :notices

  #员工档案
  namespace :staffs do
    resources :bases
    #通用用户姓名直达
    post 'ajax/search' => 'ajax#search'

    get 'ajax/departments' => 'ajax#departments'
    post 'ajax/departments' => 'ajax#departments_create'
    delete 'ajax/departments' => 'ajax#departments_delete'
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



  get 'session/login'
  post 'session/login' => 'session#login!'
  
  get 'session/timeout'
  post 'session/timeout' => 'session#timeout!'

  get 'session/deny'
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
