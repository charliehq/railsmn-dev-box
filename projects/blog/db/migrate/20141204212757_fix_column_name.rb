class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :comments, :commeter, :commenter
  end
end
