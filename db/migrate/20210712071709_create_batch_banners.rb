class CreateBatchBanners < ActiveRecord::Migration[5.2]
  def change
    create_table :batch_banners do |t|
      t.references :banner
      t.references :batch
      t.timestamps
    end
  end
end
