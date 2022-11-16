class AddKnowledgeAreaToEmbeds < ActiveRecord::Migration
  def change
    add_column :embeds, :knowledge_area_id, :integer, null: false, :default => 1
  end
end
