class SiteSettingsController < ApplicationController
  before_action :authenticate_admin!

  def edit
    @title_setting = SiteSetting.find_or_initialize_by(name: "site_title")
    @logo_setting = SiteSetting.find_or_initialize_by(name: "site_logo")
  end

 def update
  @title_setting = SiteSetting.find_or_initialize_by(name: "site_title")
  @title_setting.value = params[:site_title]
  @title_setting.save

  @logo_setting = SiteSetting.find_or_initialize_by(name: "site_logo")
  @logo_setting.save if @logo_setting.new_record?

  if params[:site_logo].present?
    if @logo_setting.file.attached?
      old_key = @logo_setting.file.blob.key
      @logo_setting.file.purge

          remove_empty_storage_folders
    end

    @logo_setting.file.attach(params[:site_logo])
  end

  redirect_to edit_site_settings_path, notice: "Settings updated successfully."
end

private

def remove_empty_storage_folders
    base_path = Rails.root.join("storage")

    Dir.glob("#{base_path}/**/").sort.reverse.each do |folder|
      next if folder == base_path.to_s

      begin
        if Dir.exist?(folder) && (Dir.entries(folder) - %w[. ..]).empty?
          Dir.rmdir(folder)
        end
      rescue SystemCallError
        # Skip folders that can't be deleted
      end
    end
  end

end
