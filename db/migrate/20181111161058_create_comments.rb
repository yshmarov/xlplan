class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.references :tenant, foreign_key: true
      t.belongs_to :employee, foreign_key: true
      t.text :content
      t.integer :commentable_id
      t.string :commentable_type

      t.timestamps
    end
    add_index :comments, [:commentable_id, :commentable_type]
  end
end
