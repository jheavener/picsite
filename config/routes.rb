Picsite::Application.routes.draw do
  root to: 'homepage#index'
  
  resources :users, only: [:show]
  get    'join' => 'users#new'
  post   'join' => 'users#create'
  get    'settings' => 'users#edit'
  put    'settings' => 'users#update'
    
  get    'changepassword' => 'changepassword#edit',   path: '/settings/changepassword'
  put    'changepassword' => 'changepassword#update', path: '/settings/changepassword'
  
  get    'delete_user' => 'delete_user#edit',    path: '/settings/delete'
  delete 'delete_user' => 'delete_user#destroy', path: '/settings/delete'
  
  get    'user_sessions' => 'sessions#index',   path: '/settings/sessions'
  delete 'user_session'  => 'sessions#destroy', path: '/settings/sessions/:id'
  
  get    'signin'  => 'sessions#new'
  post   'signin'  => 'sessions#create'
  match  'signout' => 'sessions#update'
  
  get    'forgotpassword' => 'forgotpassword#edit'
  match  'forgotpassword' => 'forgotpassword#update', via: [:post, :put]
  
  get    'resetpassword' => 'resetpassword#edit',   path: '/resetpassword/:token'
  put    'resetpassword' => 'resetpassword#update', path: '/resetpassword/:token'
  
  namespace :admin do
    root to: 'homepage#index'
    resources :users, only: [:index, :edit, :update] do
      resources :sessions, only: [:index, :destroy]
    end
  end
end
