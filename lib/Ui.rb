module Ui
  def board_friendly
      if self.pile.empty?
        return "---"
      else
        unicode = {:spades => "♠", :clubs => "♣", :hearts => "♥", :diamonds => "♦" }
        suit = self.pile[-1].suit
        value = self.pile[-1].value
        return "#{value}" + "#{unicode[suit.to_sym]}" + (value == "10" ? "" : "-") 
      end
  end
  
  def display_board(player1, player2)
    board = []
    board << "    xxxxxxxxxxxxxxxxxxxxxxxxx"
    board << "    x-----------------------x"
    board << "    x-----------------------x"
    board << "    x-----------------------x"
    board << "    x-----------------------x"
    board << "    x-----------------------x"
    board << "    x----#{player1.board_friendly}---------#{player2.board_friendly}----x"
    board << "    x-----------------------x"
    board << "    x-----------------------x"
    board << "    x-----------------------x"
    board << "    x-----------------------x"
    board << "    xxxxxxxxxxxxxxxxxxxxxxxxx"
    board << " "
    board.each {|r| puts r} 
  end
  
  def refresh
    system('cls')
  end
end
