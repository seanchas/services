Passport.configure do |passport|

  passport.failure  :welcome_controller
  passport.resource :user
  
  passport.certificate_auth do
    domains "http://beta.micex.ru", "http://beta.micex.com", "http://beta.moex.ru", "http://beta.moex.com"
    prefix  "passport-manager"
  end
  
  passport.strategies = :certificate
  
  passport.logger = Rails.logger
  
  passport.registration_url = "http://passport.beta.moex.com/registration"
  passport.login_url        = "http://passport.beta.moex.com/login"
  passport.logout_url       = "http://passport.beta.moex.com/logout"
  passport.profile_url      = "http://passport.beta.moex.com/user"
  
end
