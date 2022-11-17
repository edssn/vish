class AddKnowledgeAreaToEvents < ActiveRecord::Migration
  def change
    add_column :events, :knowledge_area_id, :integer, null: false, :default => 1
  end
end
