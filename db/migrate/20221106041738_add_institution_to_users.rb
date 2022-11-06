class AddInstitutionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :institution, :integer, null: false, :default => 0
  end
end
