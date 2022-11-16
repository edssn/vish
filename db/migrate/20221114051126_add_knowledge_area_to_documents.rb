class AddKnowledgeAreaToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :knowledge_area_id, :integer, null: false, :default => 1
  end
end
