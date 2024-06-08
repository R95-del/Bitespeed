class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts do |t|
      t.string :phoneNumber
      t.string :email
      t.integer :linkedId
      t.string :linkPrecedence
      t.datetime :deletedAt

      t.timestamps
    end
  end
end
