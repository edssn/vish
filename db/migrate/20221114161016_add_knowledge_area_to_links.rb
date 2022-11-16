class AddKnowledgeAreaToLinks < ActiveRecord::Migration
  def change
    add_column :links, :knowledge_area_id, :integer, null: false, :default => 1
  end
end
