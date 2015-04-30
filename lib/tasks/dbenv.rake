namespace :dbenv do
  desc "TODO"
  task :reset, [:instance] => :environment do |task, args|
    Rails.env = args.instance
    puts "dropping #{args.instance}..."
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:schema:load"].invoke
    Rake::Task["db:fixtures:load"].invoke
  end
  
  task :show_me, [:mesg] => :environment do |task, args|
    puts task
    puts args
   end
end
