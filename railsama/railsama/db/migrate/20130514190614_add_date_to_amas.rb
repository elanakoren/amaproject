class AddDateToAmas < ActiveRecord::Migration
  def change
    add_column :amas, :date, :time
  end
end
