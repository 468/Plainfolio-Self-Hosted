#Plainfolio (Self-Hosted)

###Plainfolio is a relatively simple Portfolio on Rails for managing and displaying your projects. 

Includes tags, reordorable columns, password protection, WYSIWYG entry creation plus a range of output options (pdf, json, csv and rss).

~~~

- WYSIWYG via cleditor 
- PDF export is handled by Prawn. Depending on what your Portfolio looks like (eg text based, image based, video based) the default export can look pretty feeble so you might want to edit generate_pdf.rb in the Services folder to change thumbnail sizes, etc.
- Json export is handled by Jbuilder and can be found in the json.json.jbuilder portfolios view file
- Pagination via will_paginate
- Entry URLs slugged via Friendly_id
- jQuery form color selection via 'jquery-minicolors-rails'
- Impressionist to keep a very basic unique views count

~~~

Once successfully deployed you should see a 'create admin account' page. From there you can log in and create your portfolio.
Login at yourdomain.com/login
Logout at yourdomain.com/logout
Small admin page (with hit stats, password change) at yourdomain.com/admins (or click the 'admin' button when logged in)

~~~

To try it out on digitalocean in 10 minutes:
(accurate 6/12/2014 -- assumes intermediate knowledge of Rails & command line)

- Create a 1GB droplet running 'Ruby on Rails on 14.04 (Nginx + Unicorn)'. A $5/month droplet works but you might need to [add swap](https://www.digitalocean.com/community/tutorials/how-to-add-swap-on-ubuntu-12-04) to run Bundler.
- Follow the [Initial Server Setup with Ubuntu 14.04 guide](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-14-04), at least to a point you have a new user with root priveleges set up.
- Open up the terminal & log in as your new user
- Navigate to /home/rails and temporarily give yourself ownership ('sudo chown -R YOUR-ACCOUNT-NAME:YOUR-ACCOUNT-NAME .' - note the '.')
- Connect via ftp, delete everything in home/rails/app and replace it with what's in the plainfolio-self-hosted app folder
- Replace config/routes.rb
- Delete everything in /db/ and replace with the Plainfolio db files.
- Replace the gemfile in root rails folder.
- Back in the terminal, bundle update then bundle install the new gemfile
- Type 'rake db:setup'
- Type 'RAILS_ENV=production rake db:create db:schema:load'
- Type 'rake assets:precompile'
- Type 'sudo service unicorn restart'
- Now change the Rails directory owner back to the default Rails one DigitalOcean provided ('sudo chown -R rails:rails .')
- Go to droplet IP and you should now see the admin account creation page. 