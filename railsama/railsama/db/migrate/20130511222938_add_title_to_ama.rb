class AddTitleToAma < ActiveRecord::Migration
  def change
    add_column :amas, :title, :string
  end
end
