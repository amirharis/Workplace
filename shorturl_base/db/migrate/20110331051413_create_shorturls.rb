class CreateShorturls < ActiveRecord::Migration
  def self.up
    create_table :shorturls do |t|
      t.integer    :user_id
      t.integer    :longurl_id
      t.string     :host_data
      t.string     :shortcode
      t.integer    :hits
      t.string     :status
      t.string     :short_url
      t.timestamps
    end
    add_index :shorturls, :short_url, :unique => true
  end

  def self.down
    drop_table :shorturls
  end
end
