class CreateChessBoards < ActiveRecord::Migration[6.0]
  def change
    create_table :chess_boards do |t|
      t.integer :width
      t.integer :height

      t.timestamps
    end
  end
end
