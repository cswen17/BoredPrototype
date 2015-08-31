module Secrets
  @@secrets_yaml = YAML.load_file("#{Rails.root.to_s}/config/secrets.yaml")
  

  def self.get_dropbox
    @@secrets_yaml["dropbox"]
  end

  def self.get_facebook
    @@secrets_yaml["facebook"]
  end

  def self.get_google
    @@secrets_yaml["google"]
  end
end
