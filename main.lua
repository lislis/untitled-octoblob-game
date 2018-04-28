function love.load()
   tile1 = love.graphics.newImage("tile3.png")
   block_width = tile1:getWidth()
   block_height = tile1:getHeight()
   block_depth = block_height

   grid_size = 16
   grid = {}
   for x = 1,grid_size do
      grid[x] = {}
      for y = 1,grid_size do
         grid[x][y] = 1
      end
   end

   grid_x = 400
   grid_y = 300

   player_img = love.graphics.newImage("player.png")
   player = {}
   player.x = 1
   player.y = 1
end


function love.update()
end

function love.draw()
   love.graphics.print("Hello World", 400, 300)

   for x = 1,grid_size do
      for y = 1,grid_size do

         current_x = grid_x + ((x-y) * (block_width / 2))
         current_y = grid_y + ((y+x) * (block_depth / 2)) - (block_depth * (grid_size / 2))

         love.graphics.draw(tile1,
                            current_x,
                            current_y)
         if player.x == x and player.y == y then
            love.graphics.draw(player_img, current_x + 8, current_y - 8)
         end
      end
   end


end

function love.keypressed(key)

   southEast = "down"
   southWest = "left"
   northWest = "up"
   northEast = "right"

   if key == northEast then -- right
      if player.x % 2 == 0 then
         player.x = player.x - 1
      end
      player.y = player.y - 1

   elseif key == southEast then --down
      if player.y % 2 == 0 then
         player.y = player.y + 1
      end
      player.x = player.x + 1

   elseif key == northWest then -- up
      if player.y % 2 == 0 then
         player.y = player.y - 1
      end
      player.x = player.x - 1

   elseif key == southWest then --left
      if player.x % 2 == 0 then
         player.x = player.x + 1
      end
      player.y = player.y + 1
   end
end
