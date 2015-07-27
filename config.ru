# This file is used by Rack-based servers to start the application.

ENV['GEM_HOME']="gem"
ENV['GEM_PATH']="#{ENV['GEM_HOME']}:#{ENV['GEM_PATH']}"
require ::File.expand_path('../config/environment',  __FILE__)
run Teudu::Application
