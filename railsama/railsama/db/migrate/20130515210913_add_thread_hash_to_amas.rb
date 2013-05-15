class AddThreadHashToAmas < ActiveRecord::Migration
  def change
    add_column :amas, :threadhash, :string
  end
end
