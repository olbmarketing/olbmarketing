# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# seed an admin user

# Returns the hash digest of the given string.
def User.digest(string)
  cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                BCrypt::Engine.cost
  BCrypt::Password.create(string, cost: cost)
end

# Create admin dummy user
User.delete_all
User.create!(name: 'admin',
  email: 'admin@admin.com',
  password_digest: User.digest('admin') )

# Clear database
Parish.delete_all
TerraNovaTestBenchmark.delete_all
TerraNovaTest.delete_all
Parish.delete_all
StarTest.delete_all
Student.delete_all

# Seed parishes

# link external seed file
Dir[File.join(Rails.root, 'db', 'seeds', 'parish_seeds.rb')].each { |seed| load seed }
