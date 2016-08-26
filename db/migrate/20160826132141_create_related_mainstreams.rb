class CreateRelatedMainstreams < ActiveRecord::Migration
  def change
    create_table :related_mainstreams do |t|
      t.references :edition, index: true, foreign_key: true
      t.string :content_id
      t.string :additional_content_id

      t.timestamps null: false
    end
  end
end
