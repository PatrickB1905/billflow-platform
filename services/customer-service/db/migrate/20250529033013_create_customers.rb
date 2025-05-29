class CreateCustomers < ActiveRecord::Migration[8.0]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :email
      t.text :billing_address

      t.timestamps
    end
  end
end
