class CreateUrlhashes < ActiveRecord::Migration
  def self.up
    create_table :urlhashes do |t|
      t.string     :shorturl_id
      t.string     :sha1
      t.timestamps
    end
    add_index :urlhashes, :sha1, :unique => true
  end

  def self.down
    drop_table :urlhashes
  end
end
