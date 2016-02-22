require "./lib/cards.rb"
require "./lib/ui.rb"
require "./lib/snaplistener.rb"
require "./lib/player.rb"
require "./lib/card.rb"

class Game

  include Cards
  include Ui
  
  def initialize
    @player1 = Player.new
    @player1.name = "Human"
    @player2 = Player.new
    @player2.name = "Computer"
    @players = [@player1, @player2].cycle
    @current_player = players.next
  end
  
  attr_accessor :current_player, :player1, :player2, :players
  
  def deal(player1, player2)
    @fucksake = []
      Cards::SUITS.each do |suit| 
        Cards::VALUES.each do |value| 
          @fucksake << Card.new(suit, value)
        end
      end
    
    @fucksake.shuffle!
    
    while @fucksake.length != 0
      players.next.cards << @fucksake.shift
    end
  end

  def turn(current_player)
    current_player.pick_up(current_player.pile) if out_of_cards?
    current_player.play_card
    
    display_board(player1, player2)
    
    race_for_snap if snap?
    game_over if win?
    
    # TESTING
    puts "PLAYER1: #{player1.cards.length}" + " PILE: " + "#{player1.pile.length}"
    puts "PLAYER2: #{player2.cards.length}" + " PILE: " + "#{player2.pile.length}"
    sleep(0.5)
  end
  
  def out_of_cards?
    return true if current_player.cards.empty?
  end
  
  def race_for_snap
    puts "SNAP"
    snap_listener = SnapListener.new
    puts snap_listener.class
    snap_listener.win32_api
    snap_listener.listen_for_snap
    if snap_listener.playersnap == true
      puts "HUMAN SNAP"
      player1.pile.each{|c| player1.cards << c} 
      player2.pile.each{|c| player1.cards << c}
      player1.pile.clear
      player2.pile.clear
    else
      puts "COMPUTER SNAP"
      player2.cards << player1.pile[0..-1] + player2.pile[0..-1]
    end
    
    sleep(1)
  end
  
  def snap?
    if 
      player1.pile[-1].class == NilClass || player2.pile[-1].class == NilClass
      return false
    elsif
      player1.pile[-1].value == player2.pile[-1].value
      return true
    else
      return false
    end
  end
  
  def win?
    return true if player1.cards.length == 52 || player2.cards.length == 52
  end
  
  def game_over
    puts "WE HAVE A WINNER: #{current_player.name}" 
    exit
  end
  
  def turn_switch
    puts "PLAYER IS #{current_player.name}"
    self.current_player = players.next  
  end
  
  def start  
    deal(player1, player2)
  end
  
end
