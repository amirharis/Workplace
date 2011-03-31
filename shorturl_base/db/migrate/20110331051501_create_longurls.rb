class CreateLongurls < ActiveRecord::Migration
  def self.up
    create_table :longurls do |t|
      t.string     :url
      t.string     :sha1
      t.integer    :count
      t.timestamps
    end

    add_index :longurls, :url, :unique => true
    add_index :longurls, :sha1, :unique => true
  end

  def self.down
    drop_table :longurls
  end
end
