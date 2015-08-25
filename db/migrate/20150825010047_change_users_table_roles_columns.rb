class ChangeUsersTableRolesColumns < ActiveRecord::Migration
  def up
      change_table :users do |t|
        t.remove :moderator
        t.boolean :is_admin, :default => false
        t.boolean :is_org_leader, :default => false
        t.boolean :is_developer, :default => false
      end
  end

  def down
      change_table :users do |t|
        t.remove :is_admin
        t.remove :is_org_leader
        t.remove :is_developer
        t.boolean :moderator, :default => false
      end
  end
end
