module ApplicationHelper
  def site_setting(key, fallback = "")
    setting = SiteSetting.find_by(name: key)
    return fallback if setting.blank?

    key == "site_logo_url" && setting.file.attached? ? url_for(setting.file) : setting.value.presence || fallback
  end
end
