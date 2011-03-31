class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string     :email
      t.string     :uid
      t.string     :first_name
      t.string     :last_name
      t.string     :nickname
      t.string     :link
      t.string     :gender
      t.string     :timezone
      t.string     :locale
      t.boolean    :verified
      t.string     :updated_time
      t.string     :token
      t.timestamps
    end

    add_index :users, :email, :unique => true
  end

  def self.down
    drop_table :users
  end
end
