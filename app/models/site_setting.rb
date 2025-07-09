# app/models/site_setting.rb
class SiteSetting < ApplicationRecord
  has_one_attached :file
  validates :name, presence: true, uniqueness: true


  def self.get(name)
    find_by(name: name)&.value
  end

  def self.set(name, value)
    setting = find_or_initialize_by(name: name)
    setting.value = value
    setting.save
  end

  def self.logo
    find_by(name: "site_logo")
  end
end
