class CreateEntries < ActiveRecord::Migration
  def up
    create_table :entries do |t|
      t.text :link
      t.text :title
      t.integer :bk_count
      t.string :date, :limit => 64
    end
  end

  def down
    drop_tabpe :entries
  end
end
