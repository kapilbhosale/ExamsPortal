class CreateBanners < ActiveRecord::Migration[5.2]
  def change
    create_table :banners do |t|
      t.string      :image
      t.string      :on_click_url
      t.references  :org
      t.timestamps
    end
  end
end
