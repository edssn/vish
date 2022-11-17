class AddKnowledgeAreaToExcursions < ActiveRecord::Migration
  def change
    add_column :excursions, :knowledge_area_id, :integer, null: false, :default => 1
  end
end
