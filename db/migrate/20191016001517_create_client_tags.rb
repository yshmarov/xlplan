class CreateClientTags < ActiveRecord::Migration[5.2]
  def change
    create_table :client_tags do |t|
      t.belongs_to :tenant, index: true, foreign_key: true
      t.references :client, foreign_key: true, index: true
      t.references :tag, foreign_key: true, index: true
    end
  end
end
