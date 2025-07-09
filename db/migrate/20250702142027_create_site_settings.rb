class CreateSiteSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :site_settings do |t|
      t.string :name
      t.text :value

      t.timestamps
    end
  end
end
