class User
  include Dynamoid::Document

  field :name,     :string
  field :password, :string

  if ::Rails.version.to_i < 4 || defined?(::ProtectedAttributes)
    attr_accessible :name, :password
  end

  def self.authenticate!(name, password)
    User.where(name: name, password: password).first
  end
end
