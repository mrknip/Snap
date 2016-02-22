require "./lib/card.rb"
require "test/unit"

class TestCard < Test::Unit::TestCase

  def test_card
    test_card = Card.new("spades", "10")
    assert_equal(test_card.suit, "spades")
    assert_equal(test_card.value, "10") 
  end
  
end