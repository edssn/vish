class AddKnowledgeAreaToWrittings < ActiveRecord::Migration
  def change
    add_column :writings, :knowledge_area_id, :integer, null: false, :default => 1
  end
end
