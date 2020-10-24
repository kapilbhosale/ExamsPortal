class CreateOrgs < ActiveRecord::Migration[5.2]
  def change
    create_table :orgs do |t|
      t.string :subdomain
      t.string :about_us_link
      t.string :fcm_server_key
      t.string :vimeo_access_token
      t.jsonb  :data, default: {}
      t.timestamps
    end
  end
end
