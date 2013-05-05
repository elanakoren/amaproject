class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
	t.string :body
	t.string :unique_id
	t.string :parent_id
	t.string :author

	t.timestamps
    end
  end
end
