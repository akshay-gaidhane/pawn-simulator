class ChessBoardsController < ApplicationController
  before_action :set_chess_board, only: %i[ move ]

  def move
    next_moves = move_piece_params.split("\r\n")
    # For now considered as only pawn on the board
    piece = Piece.find_by_name("pawn")
    @move_piece = Simulator.new(@chess_board, next_moves, piece).call
  end

  private

    def move_piece_params
      params.require(:move_piece)
    end

    def set_chess_board
      @chess_board = ChessBoard.find(params[:id])
    end

    def chess_board_params
      params.require(:chess_board).permit(:width, :height)
    end
end
