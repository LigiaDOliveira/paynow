class CreatePixes < ActiveRecord::Migration[6.1]
  def change
    create_table :pixes do |t|
      t.string :pix_key

      t.timestamps
    end
  end
end
