class RemoveKnowledgeAreaFieldFromTables < ActiveRecord::Migration
  def up
    remove_column :documents, :knowledge_area_id
    remove_column :links, :knowledge_area_id
    remove_column :embeds, :knowledge_area_id
    remove_column :writings, :knowledge_area_id
    remove_column :workshops, :knowledge_area_id
    remove_column :events, :knowledge_area_id
    remove_column :excursions, :knowledge_area_id
    remove_column :ediphy_documents, :knowledge_area_id
    remove_column :scormfiles, :knowledge_area_id
  end

  def down
    add_column :documents, :knowledge_area_id, :integer, null: false, :default => 1
    add_column :links, :knowledge_area_id, :integer, null: false, :default => 1
    add_column :embeds, :knowledge_area_id, :integer, null: false, :default => 1
    add_column :writings, :knowledge_area_id, :integer, null: false, :default => 1
    add_column :workshops, :knowledge_area_id, :integer, null: false, :default => 1
    add_column :events, :knowledge_area_id, :integer, null: false, :default => 1
    add_column :excursions, :knowledge_area_id, :integer, null: false, :default => 1
    add_column :ediphy_documents, :knowledge_area_id, :integer, null: false, :default => 1
    add_column :scormfiles, :knowledge_area_id, :integer, null: false, :default => 1
  end
end
