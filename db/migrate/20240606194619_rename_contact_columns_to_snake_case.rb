class RenameContactColumnsToSnakeCase < ActiveRecord::Migration[7.0]
  def change
    rename_column :contacts, :phoneNumber, :phone_number
    rename_column :contacts, :linkedId, :linked_id
    rename_column :contacts, :linkPrecedence, :link_precedence
    rename_column :contacts, :deletedAt, :deleted_at
  end
end
