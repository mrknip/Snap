class Player 

  include Ui

  def initialize
    @cards = []
    @pile = []
    @name = ""
  end
    
  attr_accessor :cards, :pile, :name
    
  def play_card
    pile << cards.shift
  end
  
  def pick_up(*piles)
    piles.each {|pile| pile.each {|card| self.cards << card } }
    piles.each {|pile| pile.clear}
  end
  
end
