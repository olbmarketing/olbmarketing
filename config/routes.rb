Rails.application.routes.draw do
  resources :exit_surveys
  # need to be placed before resources :star_tests 
  get 'star_tests/download_report_docx'
  get 'star_tests/all_star_literarcy_download'
  get 'star_tests/star_test_csv_by_student'
  get 'star_reading_tests/download_report_docx'
  get 'star_math_tests/download_report_docx'
  get 'star_tests/report' => 'star_tests#report'
  get '/star_tests/students' => 'star_tests#students'
  get 'terra_nova_tests/download_report_docx'
  resources :star_reading_tests
  resources :star_math_tests
  resources :star_tests
  resources :terra_nova_test_benchmarks
  resources :terra_nova_tests
  resources :schools
  resources :parishes
  resources :employees
  
  get 'static_pages/dashboard'
  get 'static_pages/charts'
  get 'static_pages/download_students'
  post 'static_pages/charts'

  resources :students do
    collection {post :import}
  end
	root to: 'static_pages#dashboard'

	# these routes are for showing users a login form, logging them in, and logging them out.
  	get '/login' => 'sessions#new'
  	post '/login' => 'sessions#create'
  	get '/logout' => 'sessions#destroy'

	# These routes will be for signup. The first renders a form in the browse, the second will
    # receive the form and create a user in our database using the data given to us by the user.
    get '/signup' => 'users#new'
    post '/users' => 'users#create'

    get '/map' => 'map#show'
end
