class User < ActiveRecord::Base
	has_many :organization_users
	has_many :organizations, :through => :organization_users
	
	has_many :events
    has_many :category_preferences
	
	validates_presence_of :first_name, :last_name, :andrew_id 
	validates_uniqueness_of :andrew_id, :case_sensitive => false
	
	def can_moderate?
		self.is_admin or self.is_org_leader
	end
	
	def name
		"#{first_name} #{last_name}"
	end
	
	def organizations_string
		orgs = ""
		
		if !self.organizations.nil?
			orgs = self.organizations.map{|org| org.name}.join(',')
		end
	end
end
