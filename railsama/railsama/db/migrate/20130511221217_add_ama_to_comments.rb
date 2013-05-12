class AddAmaToComments < ActiveRecord::Migration
  def change
    add_column :comments, :ama_id, :reference
  end
end
