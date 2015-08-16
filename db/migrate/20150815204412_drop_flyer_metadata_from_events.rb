class DropFlyerMetadataFromEvents < ActiveRecord::Migration
  def up
      change_table :events do |t|
          t.remove(
              :flyer,
              :flyer_file_name,
              :flyer_content_type,
              :flyer_file_size,
              :flyer_updated_at
          )
          t.string :flyer_url
      end
  end

  def down
      change_table :events do |t|
          t.remove :flyer_url
          t.string :flyer
          t.string :flyer_file_name
          t.string :flyer_content_type
          t.integer :flyer_file_size
          t.datetime :flyer_updated_at
      end
  end
end
