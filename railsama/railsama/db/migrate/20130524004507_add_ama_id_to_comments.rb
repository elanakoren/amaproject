class AddAmaIdToComments < ActiveRecord::Migration
  def change
    change_table :comments do |t|
      t.references :ama
    end
  end
end
