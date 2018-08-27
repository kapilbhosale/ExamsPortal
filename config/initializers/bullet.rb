Rails.application.configure do
  config.after_initialize do
    Bullet.enable = true
    Bullet.alert = true
	Bullet.rails_logger = true
	Bullet.bullet_logger = true
	Bullet.console = true
	Bullet.add_footer = true
  end
end