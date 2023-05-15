class Simulator

  def initialize(board, next_moves, piece)
    @board = board
    @pawn = piece.name == "pawn" ? 6 : false
    @next_moves = struct(next_moves)
    @position = {}
    @move = Move.new
  end

  def call
    return false unless @pawn
    res = ""
    @next_moves.each do |k,v|
      case k
      when :place
        # Set the properties
        properties, pos = v.split(",").partition{ |val| val.length > 1}
        x,y = pos[0].to_i, pos[1].to_i
        facing, color = properties[0], properties[1]

        # Keep track of current and next move
        @move.last_position = [x,y]
        @move.color = color.downcase == "white" ? 0 : 1
        @move.piece_id = @pawn

        # Place pawn on board
        place(x, y, facing, color)
      when :move, :move_after_turn
        moves = v.split(",")
        moves.each{ |m| move(m.to_i) }
      when :left
        rotate(:left)
      when :right
        rotate(:right)
      when :report
        res = report
      end
    end
    res
  end

# PLACE will put the pawn on the board in position X, Y, facing NORTH, SOUTH,
# EAST or WEST and Colour(White or Black)
  def place(x, y, facing, color)
    if valid_position(x, y)
      @position = {x: x, y: y, facing: facing, color: color}
    end
  end

# MOVE will move the pawn one unit forward in the direction it is currently facing
  def move(steps)
    return unless @position

    new_x, new_y = move_by_steps(steps)

    if valid_position(new_x, new_y)
      @position[:x], @position[:y] =  new_x, new_y
    end
  end

# LEFT and RIGHT will rotate the pawn 90 degrees in the specified direction without
# changing the position of the pawn.
  def rotate(direction)
    return unless @position

    case direction
    when :left
     rotate_left
    when :right
     rotate_right
    end
  end

  def report
    return "Invalid" unless @position
    @move.current_position =  [@position[:x], @position[:y]]
    @move.save!
    "#{@position[:x]},#{@position[:y]},#{@position[:facing]},#{@position[:color]}"
  end

  private
# 
  def valid_position(x, y)
    x >= 0 && x < @board.width && y >= 0 && y < @board.height
  end

# Restruct input to process each moves
  def struct(next_moves)
    structured = {}
    moved = false
    turned = false

    next_moves.each do |command|
      if command.start_with?("PLACE")
        structured[:place] = command.split(" ")[1]

      elsif command.start_with?("MOVE")

        # if number of move didn't mentioned and pawn is limited to move 1 step after initial step I set default MOVE as 1
        step = command.split(" ")[1] || "1"
        puts moved && turned
        # Check if pawn moved or turned before , if did then work accordingly for further steps/ multiple moves
        if moved && turned
          structured[:move_after_turn] = step
        elsif moved && !turned
          structured[:move] = structured[:move] + "," + step
        else
          structured[:move] = step 
        end

        moved = true

      elsif command.start_with?("LEFT")
        structured[:left] = ""
        turned = true

      elsif command.start_with?("RIGHT")
        structured[:right] = ""
        turned = true

      elsif command.start_with?("REPORT")
        structured[:report] = ""
      end
    end
    structured
  end

  def move_by_steps(steps)
    case @position[:facing]
    when "NORTH"
      [@position[:x], @position[:y] + steps]
    when "SOUTH"
      [@position[:x], @position[:y] - steps]
    when "EAST"
      [@position[:x] + steps, @position[:y]]
    when "WEST"
      [@position[:x] - steps, @position[:y]]
    end
  end

  def rotate_left
    @position[:facing] = 
    case @position[:facing]
    when "NORTH"
      "WEST"
    when "SOUTH"
      "EAST"
    when "EAST"
      "NORTH"
    when "WEST"
      "SOUTH"
    end
  end

  def rotate_right
    @position[:facing] = 
    case @position[:facing]
    when "NORTH"
      "EAST"
    when "SOUTH"
      "WEST"
    when "EAST"
      "SOUTH"
    when "WEST"
      "NORTH"
    end
  end
end
