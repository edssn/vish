class AddKnowledgeAreaToEdiphyDocuments < ActiveRecord::Migration
  def change
    add_column :ediphy_documents, :knowledge_area_id, :integer, null: false, :default => 1
  end
end
