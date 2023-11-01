require './script.rb'

describe Game do
  subject(:game) {described_class.new}

  describe '#player_input' do
    context 'when given valid input' do
      it 'pushes the input to @play_log' do
        allow(game).to receive(:gets).and_return('1')
        game.dice
        game.player_input
        expect(game.instance_variable_get(:@play_log)).to eq(['1_g'])
      end
      it 'adds elements of the same column' do
        allow(game).to receive(:gets).and_return('1','1')
        game.dice
        game.player_input
        game.player_input
        expect(game.instance_variable_get(:@play_log)).to eq(['1_g','1_f'])
      end
    end
  end

  describe '#dice' do
    it 'updates @turns' do
        game.dice
        expect(game.instance_variable_get(:@turns).length).to eq(1)
    end
  end

  describe '#check_input' do
    it 'returns true when given a valid number' do
      expect(game.check_input(7)).to eq(true)
    end

    it 'returns false when given an invalid number' do
      expect(game.check_input(9)).to eq(false)
    end
  end

  describe '#draw_plays' do
    it 'returns an array with the played symbols' do
      game.instance_variable_get(:@played)[:X].push('1_g')
      game.instance_variable_get(:@played)[:O].push('2_g')
      positions = game.instance_variable_get(:@positions)
      expect(game.draw_plays(positions)).to include('X')
      expect(game.draw_plays(positions)).to include('O')
    end
  end

  describe '#play' do
    context 'when there are 42 turns' do
      it 'stops the loop' do
        game.instance_variable_set(:@turns, Array.new(41,'1_g'))
        allow(game).to receive(:gets).and_return('2')
        game.dice
        game.player_input
        expect { game.play }.to output(include("It's a draw!")).to_stdout
      end
    end
  end

  describe '#game_over' do
    context '#check_vertical' do
      it 'changes @game_over to true' do
        allow(game).to receive(:gets).and_return('2','1','2','1','2','1','2','1')
        game.dice
        10.times { game.player_input }
        game.game_over(:X)
        expect(game.instance_variable_get(:@game_over)).to eq(true)
      end
    end

    context '#check_horizontal' do
      it 'changes @game_over to true' do
        allow(game).to receive(:gets).and_return('1','6','2','6','3','6','4')
        game.dice
        10.times { game.player_input }
        game.game_over(:X)
        expect(game.instance_variable_get(:@game_over)).to eq(true)
      end
    end
    
    context '#check_diagonal' do
      it 'changes @game_over to true' do
        allow(game).to receive(:gets).and_return('1','2','2','3','4','3','3','4','5','4','4')
        game.dice
        11.times { game.player_input }
        game.game_over(:X)
        expect(game.instance_variable_get(:@game_over)).to eq(true)
      end
    end
  end

end