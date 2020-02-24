# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#v2'

  scope :v2 do
    get '/', to: 'home#v2'
    get '*all', to: 'home#v2'
  end

  devise_for :users,
             class_name: 'User',
             path: '/api/v2/tokens',
             controllers: { sessions: 'api/v2/tokens' }, only: :sessions,
             path_names: { sign_in: '', sign_out: '' },
             sign_out_via: :delete,
             defaults: { format: :json }, constraints: { format: :json }

  resources :login, only: [:index]

  namespace :api do
    namespace :v2, defaults: { format: :json },
                   constraints: { format: :json },
                   only: %i[index create show update destroy] do

      resources :children, as: :cases, path: :cases do
        resources :flags, only: %i[index create update]
        resources :alerts, only: [:index]
        resources :assigns, only: %i[index create]
        resources :referrals, only: %i[index create destroy]
        resources :transfers, only: %i[index create update]
        resources :transfer_requests, only: %i[index create update]
        resources :transitions, only: [:index]
        resources :attachments, only: %i[create destroy]
        collection do
          post :flags, to: 'flags#create_bulk'
          post :assigns, to: 'assigns#create_bulk'
          post :referrals, to: 'referrals#create_bulk'
          post :transfers, to: 'transfers#create_bulk'
        end
        resources :approvals, only: [:update]
      end

      resources :incidents do
        resources :flags, only: %i[index create update]
        resources :alerts, only: [:index]
        resources :approvals, only: [:update]
        resources :attachments, only: %i[create destroy]
        post :flags, to: 'flags#create_bulk', on: :collection
      end

      resources :tracing_requests do
        resources :flags, only: %i[index create update]
        resources :alerts, only: [:index]
        resources :approvals, only: [:update]
        resources :attachments, only: %i[create destroy]
        post :flags, to: 'flags#create_bulk', on: :collection
      end

      resources :form_sections, as: :forms, path: :forms
      resources :users do
        collection do
          get :'assign-to', to: 'users_transitions#assign_to'
          get :'transfer-to', to: 'users_transitions#transfer_to'
          get :'refer-to', to: 'users_transitions#refer_to'
        end
      end
      resources :identity_providers, only: [:index]
      resources :dashboards, only: [:index]
      resources :contact_information, only: [:index]
      resources :system_settings, only: [:index]
      resources :tasks, only: [:index]
      resources :saved_searches, only: %i[index create destroy]
      resources :reports, only: %i[index show]
      resources :lookups
      resources :locations
      resources :bulk_exports, as: :exports, path: :exports, only: %i[index show create destroy]
      get 'alerts', to: 'alerts#bulk_index'
      resources :agencies
      resources :roles
      resources :permissions, only: [:index]
      resources :user_groups
      resources :primero_modules, only: %i[index show update]

      resources :key_performance_indicators do
        collection do
          get :number_of_cases
          get :number_of_incidents
          get :reporting_delay
          get :service_access_delay
          get :assessment_status
          get :completed_case_safety_plans
        end
      end
    end
  end
end
