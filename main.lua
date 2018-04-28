math.randomseed( os.time() )

function fish_gen()
   for i = 1, fish_count do
      fish[i] = {}
      fish[i].pos = {}
      x = math.random(2, grid_size -1)
      y = math.random(2, grid_size -1)
      fish_check = true
      for j = 1, i do
         if fish[j].pos.x == x and fish[j].pos.y == y then
            fish_check = false
         end
      end

      while(fish_check == false) do
         x = math.random(2, grid_size -1)
         y = math.random(2, grid_size -1)
         for j = 1, i do
            if fish[j].pos.x == x and fish[j].pos.y then
               fish_check = false
            else
               fish_check = true
            end
         end
      end

      fish [i].pos.x = x
      fish[i].pos.y = y
      fish[i].sprite = fish_sprite[math.random(2)]
   end
end

function love.load()
   round = 0
   prev_round = 0
   scared_fish = 0
   fish_eaten = 0

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

   grid_x = love.graphics.getWidth() / 2
   grid_y = love.graphics.getHeight() / 2

   player_img = love.graphics.newImage("player.png")
   player = {}
   player.x = grid_size / 2
   player.y = grid_size / 2

   ink_sprite  = love.graphics.newImage("ink.png")
   inks = {}

   fish1 = love.graphics.newImage("fish1.png")
   fish2 = love.graphics.newImage("fish2.png")
   fish_sprite = {fish1, fish2}

   fish_count = 20
   fish = {}

   fish_gen()
end

function love.update()
   if prev_round ~= round then
      -- update all fish
      for i,v in ipairs(fish) do
         rand_x = math.random(-1, 1)
         rand_y = math.random(-1, 1)

         new_x = fish[i].pos.x + rand_x
         new_y = fish[i].pos.y + rand_y

         if new_x < 1 then
            new_x = 1
         end

         if new_x > grid_size then
            new_x = grid_size
         end

         if new_y < 1 then
            new_y = 1
         end

         if new_y > grid_size then
            new_y = grid_size
         end

         fish[i].pos.x = new_x
         fish[i].pos.y = new_y

         -- COLLISION
         if fish[i].pos.x == player.x and fish[i].pos.y == player.y then
            scared_fish = scared_fish + 1
            table.remove(fish, i)
         end

         for j,b in ipairs(inks) do
            if fish[i].pos.x == inks[j].x and fish[i].pos.y == inks[j].y then
               fish_eaten = fish_eaten + 1
               table.remove(fish, i)
            end
         end
      end

      for i,v in ipairs(inks) do
         inks[i].ttl = inks[i].ttl - 1
         if inks[i].ttl < 0 then
            table.remove(inks, i)
         end
      end
   end
   prev_round = round
end

function love.draw()
   love.graphics.print("Round: "..round, 10, 10)
   love.graphics.print("Scared away: "..scared_fish, 10, 50)
   love.graphics.print("Fish eaten: "..fish_eaten, 10, 90)

   for x = 1,grid_size do
      for y = 1,grid_size do

         current_x = grid_x + ((x-y) * (block_width / 2))
         current_y = grid_y + ((y+x) * (block_depth / 2)) - (block_depth * (grid_size / 2))

         love.graphics.draw(tile1, current_x, current_y)

         for s = 1,#inks do
            if inks[s].x == x and inks[s].y == y then
               love.graphics.draw(ink_sprite, current_x, current_y)
            end
         end

         for i = 1,#fish do
            if fish[i].pos.x == x and fish[i].pos.y == y then
               love.graphics.draw(fish[i].sprite, current_x + 8, current_y - 4)
            end
         end

         if player.x == x and player.y == y then
            love.graphics.draw(player_img, current_x + 8, current_y - 8)
         end
      end
   end
end

function love.keypressed(key)
   southEast = "s"
   southWest = "a"
   northWest = "w"
   northEast = "d"

   inking = "r"

   count_up_round = true

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

   elseif key == inking then
      spot = {}
      spot.x = player.x
      spot.y = player.y
      spot.ttl = 10
      table.insert(inks, spot)
   else
      count_up_round = false
   end

   if player.y < 1 then
      player.y = 1
   end

   if player.y > grid_size then
      player.y = grid_size
   end

   if player.x < 1 then
      player.x = 1
   end

   if player.x > grid_size then
      player.x = grid_size
   end

   if count_up_round then
      round = round + 1
   end
end
