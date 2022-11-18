class CreateMonetisations < ActiveRecord::Migration[5.0]
  def change
    create_table :monetisations do |t|
      t.references :game, foreign_key: true
      t.string :paypal_account
      t.boolean :approved, default: false
      t.string :description

      t.timestamps
    end
  end
end
