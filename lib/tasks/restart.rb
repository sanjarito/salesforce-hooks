require 'platform-api/api'

namespace :heroku do
  task :restart do
     Heroku::API.
       new(username: ENV['santiago@nowhereprod.com'], password: ENV['Detech2804!!']).
       post_ps_restart(ENV['obscure-beach-12891'])
     end
  end
