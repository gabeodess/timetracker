User.find_or_create_by_login('admin').update_attributes!(:email => 'admin@test.com', :password => 'password', :password_confirmation => 'password')
puts "you may now log in with admin/password"