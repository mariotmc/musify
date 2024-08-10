namespace :db do
  task :rebuild => :environment do
    raise "Not allowed to run on production" unless Rails.env.development?

    puts "===== creating database ====="
    system "rails db:drop db:create db:schema:load db:fixtures:load"
    puts "===== created database ====="
  end
end
