require 'faker'

desc "filling database with sample data"

task :populate do
  Rake::Task['db:reset'].invoke
  admin = User.create!(:name => "ExampleUser",
               :email => "user@example.com",
               :password => "password",
               :password_confirmation => "password")
  admin.toggle!(:admin)

  99.times do |n|
     name = Faker::Name.name
     email = "example#{n+1}@email.com"
     password = "password"
     User.create!(:name => name, 
                  :email => email,
                  :password => password,
                  :password_confirmation => password)
  end
end
