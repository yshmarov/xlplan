class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.belongs_to :tenant, index: true, foreign_key: true
      t.string :name, :limit => 40
      t.integer :client_tags_count, default: 0, null: false
    end
    add_index :tags, :name
  end
end
