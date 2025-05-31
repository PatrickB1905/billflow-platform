class CreateSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :subscriptions do |t|
      t.integer :customer_id
      t.references :plan, null: false, foreign_key: true
      t.string :status
      t.date :start_date
      t.date :last_billed_at

      t.timestamps
    end
  end
end
