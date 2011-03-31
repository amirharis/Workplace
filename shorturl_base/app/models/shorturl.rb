class Shorturl < ActiveRecord::Base
  belongs_to :longurl
  belongs_to :user
  has_many   :shorturl_histories
  has_one    :urlhash
end
