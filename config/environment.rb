# Load the rails application
require File.expand_path('../application', __FILE__)

# randomly generated the secret token using `rake secret`. Feel free to replace
Teudu::Application.config.secret_token = '7ea0d65632babde7fc89b0729757fdb6808e7b6feaa3c00c6a0cdb64975ea13310e1398a8bc36504352483b300ef4793b55714de33d519bbea262d3af18ccea9'

# Initialize the rails application
Teudu::Application.initialize!

