class ChangeAttachmentToDb < ActiveRecord::Migration
  def self.up
    add_column :volunteers, :db_file_id, :integer
    add_column :volunteers, :size, :integer
    add_column :volunteers, :content_type, :string
    add_column :volunteers, :filename, :string

    create_table :db_files do |t|
      t.binary :data
    end
  end

  def self.down
  end
end
