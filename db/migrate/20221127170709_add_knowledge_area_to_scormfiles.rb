class AddKnowledgeAreaToScormfiles < ActiveRecord::Migration
  def change
    add_column :scormfiles, :knowledge_area_id, :integer, null: false, :default => 1
  end
end
