# assumes running within rails environment

if not ClientApplication.find_by_name("iD")
    admin = User.find_by_display_name("admin")
    id_client = admin.client_applications.build(:name => "iD", :url => "https://github.com/opentsreetmap/iD", :allow_write_api => true)
    id_client.save!
end

