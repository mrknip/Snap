require_relative "cards.rb"
require_relative "ui.rb"
require_relative "snaplistener.rb"
require_relative "player.rb"
require_relative "card.rb"

class Game

  include Cards
  include Ui
  
  def initialize
    @player1 = Player.new("Human")
    @player2 = Player.new("Snaptron 3000")
    @players = [@player1, @player2].cycle
    @current_player = players.next
  end
  
  attr_accessor :current_player, :player1, :player2, :players
  
  def deal
    full_deck = [] # is this still a local variable if I don't use '@'?
      Cards::SUITS.each do |suit| 
        Cards::VALUES.each do |value| 
          full_deck << Card.new(suit, value)
        end
      end
    
    full_deck.shuffle!
    
    while full_deck.length != 0
      players.next.cards << full_deck.shift
    end
  end

  def turn(current_player)
    
    puts "PLAYER1: #{player1.name} CARDS: #{player1.cards.length} PILE: " + "#{player1.pile.length}"
    puts "PLAYER2: #{player2.name} CARDS: #{player2.cards.length} PILE: " + "#{player2.pile.length}"
    
    puts "\nPLAYER IS #{current_player.name}\n"
    
    current_player.pick_up(current_player.pile) if out_of_cards?
    
    gets if current_player.name == "Human"
    current_player.play_card
    
    display_board(player1, player2)
    
    race_for_snap if snap?
    game_over if win?

    sleep(0.5)
  end
  
  def out_of_cards?
    return true if current_player.cards.empty?
  end
  
  def race_for_snap
    puts "SNAP"
    snap_listener = SnapListener.new
    snap_listener.win32_api
    snap_listener.listen_for_snap
    if snap_listener.playersnap == true
      puts "HUMAN SNAP"
      players.take(2).each { |player| player1.pick_up(player.pile) }
    else
      puts "COMPUTER SNAP"
      players.take(2).each { |player| player2.pick_up(player.pile) }
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
    @current_player = players.next  # Doesn't work without the class variable marker.  Don't know why as I have getter/setter sorted?
  end
  
  def start  
    deal    
    while !self.win?
      self.turn(self.current_player)
      self.turn_switch
    end
  end
  
end
