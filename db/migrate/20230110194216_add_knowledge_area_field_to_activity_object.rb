class AddKnowledgeAreaFieldToActivityObject < ActiveRecord::Migration
  def change
    add_column :activity_objects, :knowledge_area_id, :integer, null: true, :default => 1
  end
end
