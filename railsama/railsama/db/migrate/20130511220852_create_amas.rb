class CreateAmas < ActiveRecord::Migration
  def change
    create_table :amas do |t|
      t.string :url
      t.string :author

      t.timestamps
    end
  end
end
