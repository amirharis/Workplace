class CreateShorturlHistories < ActiveRecord::Migration
  def self.up
    create_table :shorturl_histories do |t|
      t.string     :shorturl_id
      t.string     :remote_addr
      t.string     :user_agent
      t.string     :remote_host
      t.string     :browser
      t.string     :os
      t.string     :referer
      t.string     :country
      t.string     :state
      t.timestamps
    end
    
    add_index :shorturl_histories, :browser
    add_index :shorturl_histories, :os
    add_index :shorturl_histories, :country
    add_index :shorturl_histories, :created_at

  end

  def self.down
    drop_table :shorturl_histories
  end
end
