class ChangeBodyToText < ActiveRecord::Migration
  def change
    change_table :comments do |t|
      t.change :body, :text
    end
  end
end
