class Game
  require './lib/graph.rb'

  def initialize
    @played = {'O': [], 'X': []}
    @play_log = []
    @turns = []
    @positions = []
    @rows = ['a','b','c','d','e','f','g']
    for row in 'a'..'g'
      for col in 1..6
        @positions.push("#{col}_#{row}")
      end
    end
    @edges_ver = make_edges(@positions, 'vertical')
    @edges_hor = make_edges(@positions, 'horizontal')
    @edges_dia = make_edges(@positions, 'diagonal')
    @game_over = false
  end

  def check_vertical(node, player, parent = nil, count = 1)
    links = @edges_ver[@positions.index(node)]
    links.delete(parent) if links.include?(parent)
    return false if links.none? { |link| @played[player].include?(link) }

    links = links.filter { |link| @played[player].include?(link) }
    return @game_over = true if count == 3

    links.each do |child|
      check_vertical(child, player, node, count + 1)
    end
  end

  def check_horizontal(node, player, parent = nil, count = 1)
    links = @edges_hor[@positions.index(node)]
    links.delete(parent) if links.include?(parent)
    return false if links.none? { |link| @played[player].include?(link) }

    links = links.filter { |link| @played[player].include?(link) }
    return @game_over = true if count == 3

    links.each do |child|
      check_horizontal(child, player, node, count + 1)
    end
  end

  def check_diagonal(node, player, parent = nil, count = 1, direction = nil)
    links = @edges_dia[@positions.index(node)]
    links.delete(parent) if links.include?(parent)
    return false if links.none? { |link| @played[player].include?(link) }

    node_split = node.split('_')
    node_col = node_split[0].to_i
    node_row = @rows.index(node_split[1])
    links = links.filter { |link| @played[player].include?(link) }
    if direction != nil
      if direction == 'right'
        links = links.filter { |link| link.split('_')[0].to_i > node_col && @rows.index(link.split('_')[1]) < node_row}
      else
        links = links.filter { |link| link.split('_')[0].to_i < node_col && @rows.index(link.split('_')[1]) < node_row}
      end
    end
    return @game_over = true if count == 3 && !links.empty?

    links.each do |child|
      child_split = child.split('_')
      child_col = child_split[0].to_i
      child_col > node_col ? direction = 'right' : direction = 'left'
      check_diagonal(child, player, node, count + 1, direction)
    end
  end
  
  def game_over(player)
    plays = @played[player]
    plays.each do |play|
      check_vertical(play, player)
      check_horizontal(play, player)
      check_diagonal(play, player)
    end
  end

  def dice
    dice = rand(100)
    dice < 50 ? @turns.push('X') : @turns.push('O')
  end

  def check_input(input)
    return true if (1..7).include?(input)
    
    false
  end

  def player_input
    turn = @turns[-1].to_sym
    input = gets.chomp.to_i
    return puts "Wrong input" unless check_input(input)
    play = "#{input}_g"
    row = 5
    while @play_log.include?(play)
      play = "#{input}_#{@rows[row]}"
      row -= 1
      break if row < -1
    end
    return puts "You can't play there" if @play_log.include?(play)
    @played[turn].push(play) unless row < -1
    @play_log.push(play)
    game_over(turn)
    turn == :X ? @turns.push('O') : @turns.push('X')
    puts "You can't play there" if row < -1

  end

  def draw_plays(board)
    holes_with_plays = []
    board.each do |hole|
      if @played[:O].include?(hole)
        holes_with_plays.push('O')
      elsif @played[:X].include?(hole)
        holes_with_plays.push('X')
      else
        holes_with_plays.push(hole)
      end
    end
    holes_with_plays = holes_with_plays.map do |hole|
      if @positions.include?(hole)
        '*'
      else
        hole
      end
    end
    holes_with_plays
  end

  def draw_board
    holes = @positions
    holes_with_plays = draw_plays(holes)
    holes = holes_with_plays.each_slice(6).to_a
    holes.each { |hole| puts hole.join(' - ').ljust(20,' ') }
    puts "It's #{@turns[-1]}'s turn, choose a number between 1 and 6" unless @game_over
    holes
  end

  def play
    dice
    loop do
      draw_board
      player_input
      return puts "It's a draw!" if @turns.length > 41

      if @game_over == true
        draw_board
        return puts "Game over! #{@turns[-2]} won"
      end
    end
  end
    
end
  
#game = Game.new
#game.play