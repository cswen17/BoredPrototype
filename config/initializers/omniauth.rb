Rails.application.config.middleware.use OmniAuth::Builder do
#  if Rails.env == "production"
#    provider :CMU, :host => 'teudu.andrew.cmu.edu', :appid => 'teudu.andrew.cmu.edu', :keyfile => '/usr/local/pubcookie/keys/teudu.andrew.cmu.edu', :granting_cert => '/usr/local/pubcookie/keys/pubcookie_granting.cert'
#  end
end
