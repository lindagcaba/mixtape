
 Factory.define :user  do |user|
   user.name         "Linda"
   user.email        "lindagcaba@gmail.com"
   user.password     "password"
   user.password_confirmation "password"
 end
 
Factory.sequence :email do |n| 
  "user-#{n}@example.com"
end
