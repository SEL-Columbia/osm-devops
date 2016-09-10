# assumes running within rails environment

if not User.find_by_display_name("admin")
    u = User.new(:display_name => "admin", 
                 :email => "admin@admin.org", 
                 :status => "active", 
                 :terms_seen => true, 
                 :data_public => true)

    u.pass_crypt, u.pass_salt = PasswordHash.create("admin")
    u.save!

    u.roles.create(:role => "administrator", :granter_id => u.id)
end
