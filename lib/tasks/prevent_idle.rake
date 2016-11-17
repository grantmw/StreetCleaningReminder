desc "pings app to prevent sleep/ idle"
task :ping_page => :environment do
   uri = URI.parse('https://streetcleaning.herokuapp.com/#/')
   Net::HTTP.get(uri)
end