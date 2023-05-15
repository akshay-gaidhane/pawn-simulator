# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
chess_board = ChessBoard.new(width: 8, height: 8)
chess_board.save!

["king", "queen", "bishop", "rook", "knight", "pawn"].each{ |piece| Piece.create!(name: piece)}