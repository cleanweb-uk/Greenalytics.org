desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
 Sites.daily_update
end
