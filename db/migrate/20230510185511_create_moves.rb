class CreateMoves < ActiveRecord::Migration[6.0]
  def change
    create_table :moves do |t|
      t.references :piece, null: false, foreign_key: true
      t.string :last_position
      t.string :current_position
      t.integer :color

      t.timestamps
    end
  end
end
