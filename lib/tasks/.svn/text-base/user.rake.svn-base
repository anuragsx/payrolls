namespace :salaree do
    desc "Creates Users for all existing company"
    task :users => :environment do
      i = 1
      User.delete_all
      Company.all.each do |company|
        u = User.new(:login=>"admin#{i}",
                    :email=>"admin#{i}@salaree.com",
                    :password=>"admin123",
                    :password_confirmation=>"admin123",
                    :activate=>true,
                    :company=>company)
         if u.save
           puts "#{u.login} created"
         else
           puts u.errors.to_a.join(" \n")
         end
         i = i+1
      end
    end
end
