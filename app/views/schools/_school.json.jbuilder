json.extract! school, :id, :name, :phone, :fax, :email, :website, :parish_id, :address, :city, :state, :zip, :created_at, :updated_at
json.url school_url(school, format: :json)