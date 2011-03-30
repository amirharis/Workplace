require "rubygems"
require "active_model"

class Host
  include ActiveModel::Validations

  validates_presence_of :hostname

  attr_accessor :ip_address, :hostname, :os
  def initialize(hostname, ip_address, os)
    @hostname, @ip_address, @os = hostname, ip_address, os
  end
end

