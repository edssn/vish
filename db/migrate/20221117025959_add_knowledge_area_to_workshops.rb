class AddKnowledgeAreaToWorkshops < ActiveRecord::Migration
  def change
    add_column :workshops, :knowledge_area_id, :integer, null: false, :default => 1
  end
end