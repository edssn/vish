class CreateKnowledgeAreas < ActiveRecord::Migration
  def up
    create_table :knowledge_areas do |t|
      t.integer :id
      t.string :key

      t.timestamps
    end
  end

  def down
    drop_table :knowledge_areas
  end
end
