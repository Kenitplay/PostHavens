class ApplicationController < ActionController::Base
  before_action :set_time_zone

  private

  def set_time_zone
    Time.zone = 'Asia/Manila'
  end
end
