class AddAmaToComments < ActiveRecord::Migration
  def change
    add_column :comments, :ama, :reference
  end
end
