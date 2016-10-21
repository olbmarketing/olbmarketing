json.extract! employee, :id, :first_name, :last_name, :address, :city, :state, :zip, :email_personal, :email_work, :created_at, :updated_at
json.url employee_url(employee, format: :json)