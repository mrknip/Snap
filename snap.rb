require "./lib/game.rb"


game = Game.new
game.start
while true
  game.turn(game.current_player)
  game.turn_switch
end

