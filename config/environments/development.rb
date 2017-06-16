Rails.application.configure do

  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true

  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => 'public, max-age=172800'
    }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  config.action_mailer.raise_delivery_errors = true # Set to true originally false
  config.action_mailer.perform_caching = false
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.assets.debug = true
  config.assets.quiet = true
  # config.action_view.raise_on_missing_translations = true
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # RoR5

  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :test
  host = 'localhost:3000' # Don't use this literally; use your local dev host instead
  config.action_mailer.default_url_options = { host: host, protocol: 'https' }

  # /RoR5

  # GMAIL

  # config.action_mailer.delivery_method = :smtp
  # config.action_mailer.smtp_settings = {
  #   address:              'smtp.gmail.com',
  #   port:                 587,
  #   domain:               'example.com',
  #   authentication:       'plain',
  #   enable_starttls_auto: true,
  #   # user_name:            '<username>',
  #   # password:             '<password>',
  #   user_name:            ENV["GMAIL_USERNAME"],
  #   password:             ENV["GMAIL_PASSWORD"],
  # }
  # # maybe needed ?
  # config.action_mailer.default_url_options = { host: "localhost:3000" }

  # /GMAIL

  # Sendmail

  # config.action_mailer.delivery_method = :sendmail
  # # Defaults to:
  # # config.action_mailer.sendmail_settings = {
  # #   location: '/usr/sbin/sendmail',
  # #   arguments: '-i'
  # # }
  # config.action_mailer.perform_deliveries = true
  # config.action_mailer.raise_delivery_errors = true
  # config.action_mailer.default_options = {from: 'no-reply@example.com'}

  # /Sendmail
end
