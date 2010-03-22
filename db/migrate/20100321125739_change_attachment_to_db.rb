class ChangeAttachmentToDb < ActiveRecord::Migration
  def self.up
    add_column :volunteers, :db_file_id, :integer

    create_table :db_files do |t|
      t.binary :data
    end
  end

  def self.down
    drop_table :db_files
    remove_column :volunteers, :db_file_id
  end
end