class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.belongs_to :tenant, index: true, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.text :content
      t.integer :commentable_id
      t.string :commentable_type

      t.timestamps
    end
    add_index :comments, [:commentable_id, :commentable_type]
  end
end
