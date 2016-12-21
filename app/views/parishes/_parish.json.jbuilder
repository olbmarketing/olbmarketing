json.extract! parish, :id, :name, :contact, :phone, :fax, :email, :website, :deanery, :address, :city, :state, :zip, :note, :created_at, :updated_at
json.url parish_url(parish, format: :json)