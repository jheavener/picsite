
SMTP_SETTINGS = YAML.load_file(Rails.root.join('config', 'smtp_settings.yml'))[Rails.env]
Picsite::Application.config.action_mailer.smtp_settings = SMTP_SETTINGS if SMTP_SETTINGS
