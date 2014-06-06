Passport.configure do |passport|

  passport.failure  :welcome_controller
  passport.resource :user
  
  passport.certificate_auth do
    domains "http://www.beta.micex.ru", "http://www.beta.micex.com", "http://www.beta.moex.ru", "http://www.beta.moex.com"
    prefix  "passport-manager"
  end
  
  passport.strategies = :certificate
  
  passport.logger = Rails.logger
  
  passport.registration_url = "http://passport.beta.moex.com/registration"
  passport.login_url        = "http://passport.beta.moex.com/login"
  passport.logout_url       = "http://passport.beta.moex.com/logout"
  passport.profile_url      = "http://passport.beta.moex.com/user"
  
end
