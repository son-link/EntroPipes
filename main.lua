--[[
	EntroPipes r1
	© 2015 Alfonso Saavedra "Son Link"
	Under the GNU/GPL 3 license
	http://github.com/son-link/EntroPipes
	http://son-link.github.io
]]

-- Weight and heigth of the puzzle
W = 8
H = 6

-- Inicial posotion of the pipe 
initX = 32
initY = 8

gameState = 0 -- 0: Main screen, 1: playing, 2: the puzzle is resolve, 3: Game Over, 4 show Top score
ifWin = true -- For check if the player complete the puzzle


puzzles = {} -- table whit the puzzles
newPipe = {} -- This tavle contain the actual puzzle
numPuzzle = 1 -- count for change actual puzzle for the next is the actual is resolve
puzzle = ''

math.randomseed(os.time())
timeLimit = 120 -- Time limit (2 minutes)
timerText = '0:00' -- Text for the timer
score = 0 -- Score
totalScore = 0
scoreText = 'Score:' -- Show the score
scores = {}

 -- the background image
local bg
function love.load()
	-- Window config (only on Love2D)
	love.window.setMode(320, 240, {resizable=false, centered=true})
	if love.window.setTitle then
		-- Not implementd on LövePotion
		love.window.setTitle("EntroPipes")
		love.window.setIcon(love.image.newImageData('icon_small.png'))
	end
	-- ser font
	font = love.graphics.newFont("PixelOperator8.ttf", 12)
	love.graphics.setFont(font)
	
	-- open the file whith the puzzles list
	appendFileLines('puzzles.txt', puzzles)
	shuffle(puzzles)

	--preload images for the pipes
	pipes = {
		['pipe_0'] = love.graphics.newImage("img/0.png"),
		['pipe_1'] = love.graphics.newImage("img/1.png"),
		['pipe_2'] = love.graphics.newImage("img/2.png"),
		['pipe_3'] = love.graphics.newImage("img/3.png"),
		['pipe_4'] = love.graphics.newImage("img/4.png"),
		['pipe_5'] = love.graphics.newImage("img/5.png"),
		['pipe_6'] = love.graphics.newImage("img/6.png"),
		['pipe_7'] = love.graphics.newImage("img/7.png"),
		['pipe_8'] = love.graphics.newImage("img/8.png"),
		['pipe_9'] = love.graphics.newImage("img/9.png"),
		['pipe_A'] = love.graphics.newImage("img/A.png"),
		['pipe_B'] = love.graphics.newImage("img/B.png"),
		['pipe_C'] = love.graphics.newImage("img/C.png"),
		['pipe_D'] = love.graphics.newImage("img/D.png"),
		['pipe_E'] = love.graphics.newImage("img/E.png"),
		['pipe_F'] = love.graphics.newImage("img/F.png")
	}
	
	-- background images and dialogs
	mainBG = love.graphics.newImage("img/main_screen.png")
	gameBG = love.graphics.newImage("img/bg.png")
	win_dialog = love.graphics.newImage("img/win_dialog.png")
	top_score_bg = love.graphics.newImage("img/top_score_bg.png")
	-- set default background
	bg = mainBG
end

function love.update(dt)
	if gameState == 1 then
		bg = gameBG
		TimerCount(dt)
	end
end

function love.draw()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(bg, 0, 0)
	if gameState == 1 then
		bg = gameBG
		-- print the pipes
		for y = 0, H -1 do
			for x = 0, W -1 do
				piece = newPipe[y*W+x]
				img = pipes['pipe_'..piece.value]
				love.graphics.draw(img, piece.x, piece.y)
			end
		end
		
		love.graphics.setColor(139, 172, 15, 255)
		love.graphics.print("Time: "..math.ceil(timeLimit), 32, 216)
		love.graphics.print("Score: "..totalScore, 136, 216)
	elseif gameState == 2 then
		love.graphics.draw(win_dialog, 80, 40)
		love.graphics.setColor(139, 172, 15, 255)
		love.graphics.printf("Complete!", 0, 56, 320, 'center')
		love.graphics.printf("Time: "..math.ceil(timeLimit), 0, 80, 320, 'center')
		love.graphics.printf("Score: "..score, 0, 96, 320, 'center')
		love.graphics.printf("Press screen\nto continue.", 0, 128, 320, 'center')
	elseif gameState == 3 then
		love.graphics.draw(win_dialog, 80, 40)
		love.graphics.setColor(139, 172, 15, 255)
		love.graphics.printf("GAME OVER!", 0, 56, 320, 'center')
		love.graphics.printf("Score: "..totalScore, 0, 96, 320, 'center')
		love.graphics.printf("Press screen\nto continue.", 0, 128, 320, 'center')
	elseif gameState == 4 then
		love.graphics.draw(top_score_bg, 80, 32)
		love.graphics.setColor(139, 172, 15, 255)
		love.graphics.printf("Top score", 0, 48, 320, 'center')
		posY = 64
		-- Show the top 5 scores
		for i = 1, 5 do
			if scores[i] then
				if scores[i] == totalScore then
					love.graphics.setColor(48, 98, 48, 255)
					love.graphics.print(i..". "..scores[i], 120, posY)
				else
					love.graphics.setColor(139, 172, 15, 255)
					love.graphics.print(i..". "..scores[i], 120, posY)
				end
			end
			posY = posY + 12
		end
		love.graphics.printf("Press screen\nto continue.", 0, 136, 320, 'center')
	else
		bg = mainBG
	end
end

function genPuzzle()
	-- this function generate the puzzle
	puzzle = puzzles[numPuzzle]
	posX = initX
	posY = initY
	for i = 1, (W*H) do
		value = string.sub(puzzle,i,i)
		newPipe[i-1] = {value = value, img = pipes['pipe_'..value],x = posX, y = posY}
		if posX == 256 then
			posX = 32
			posY = posY + 32
		else
			posX = posX + 32
		end
	end
	randPipes()
end

function love.mousepressed(posx, posy, button)
	print (gameState)
	if gameState == 0 or gameState == 2 then
		genPuzzle()
	elseif gameState == 3 then
		saveScore()
	elseif gameState == 4 then
		gameState = 0
	elseif gameState == 1 then
		-- walk the pipes array and com wath pipe is presed
		for y = 0, H-1 do
			for x = 0, W-1 do
				piece = newPipe[y*W+x]
				if posx >= piece.x and posx <= piece.x + 32 and posy >= piece.y and posy <= piece.y + 32 then
					if piece.value ~= 'F' and piece.value ~= 0 then
						if piece.value == 1 then
							newPipe[y*W+x].value = 2
							break
						elseif piece.value == 2 then
							newPipe[y*W+x].value = 4
							break
						elseif piece.value == 3 then
							newPipe[y*W+x].value = 6
							break
						elseif piece.value == 4 then
							newPipe[y*W+x].value = 8
							break
						elseif piece.value == 5 then
							newPipe[y*W+x].value = 'A'
							break
						elseif piece.value == 6 then
							newPipe[y*W+x].value = 'C'
							break
						elseif piece.value == 7 then
							newPipe[y*W+x].value = 'E'
							break
						elseif piece.value == 8 then
							newPipe[y*W+x].value = 1
							break
						elseif piece.value == 9 then
							newPipe[y*W+x].value = 3
							break
						elseif piece.value == 'A' then
							newPipe[y*W+x].value = 5
							break
						elseif piece.value == 'B' then
							newPipe[y*W+x].value = 7
							break
						elseif piece.value == 'C' then
							newPipe[y*W+x].value  = 9
							break
						elseif piece.value == 'D' then
							newPipe[y*W+x].value = 'B'
							break
						elseif piece.value == 'E' then
							newPipe[y*W+x].value = 'D'
							break
						end
					end
				end
			end
		end
		calculateEntropy()
	end
end

function shuffle(t)
	-- Shuflle the table indicated on the parameter
    local rand = math.random 
    assert(t, "table.shuffle() expected a table, got nil")
    local iterations = #t
    local j
    
    for i = iterations, 2, -1 do
        j = rand(i)
        t[i], t[j] = t[j], t[i]
    end
end

function randArray(values)
	-- return a random value from the array indicated
	return (values[math.random(1, #values)])
end

function randPipes()
	-- randomice the pipes
	for y = 0, H-1 do
		for x = 0, W-1 do
			if string.match(newPipe[y*W+x].value,'[369C]') then
				newPipe[y*W+x].value = randArray({3,6,9,'C'})
			elseif string.match(newPipe[y*W+x].value, '[1248]') then
				newPipe[y*W+x].value = randArray({1,2,4,8})
			elseif string.match(newPipe[y*W+x].value, '[7BDE]') then
				newPipe[y*W+x].value = randArray({7,'B','D','E'})
			elseif string.match(newPipe[y*W+x].value,'[5A]') then
				newPipe[y*W+x].value = randArray({5,'A'})
			end
		end
	end
	gameState = 1
	timeLimit = 120
end

function calculateEntropy()
	-- Calculate the entropy. If 0 the puzzle is resolve
	entropy = 0;
	entropyLocal = 0
	for y = 0, H-1 do
		for x = 0, W-1 do
			entropyLocal = 0
			if  ( ( checkUp(newPipe[y*W+x].value) ) and ( ( y == 0 ) or ( not checkDown(newPipe[(y-1)*W+x].value) ) ) ) then entropyLocal = entropyLocal + 1 end
			if  ( ( checkDown(newPipe[y*W+x].value) ) and ( ( y == H-1 ) or ( not checkUp(newPipe[(y+1)*W+x].value) ) ) ) then  entropyLocal = entropyLocal + 1 end
			if  ( ( checkRight(newPipe[y*W+x].value) ) and ( ( x == W-1 ) or ( not checkLeft(newPipe[y*W+x+1].value) ) ) ) then  entropyLocal = entropyLocal + 1 end
			if  ( ( checkLeft(newPipe[y*W+x].value) ) and ( ( x == 0 ) or ( not checkRight(newPipe[y*W+x-1].value) ) ) ) then  entropyLocal = entropyLocal + 1 end
			entropy = entropy + entropyLocal;
		end
	end
	if entropy == 0 then
		score = math.floor(timeLimit) * 10
		totalScore = totalScore + score
		if numPuzzle < #puzzles then
			numPuzzle = numPuzzle + 1
			gameState = 2
		else
			saveScore()
		end
	end
end

function checkUp(tile) return (string.match("13579BDF", tile) ) end
function checkDown(tile) return ( string.match("4567CDEF", tile) ) end
function checkRight(tile) return ( string.match("2367ABEF", tile) ) end
function checkLeft(tile) return (string.match("89ABCDEF", tile) ) end

function TimerCount(dt)
	timeLimit = timeLimit - dt
	if timeLimit <= 0 then
		gameState = 3
	end
end

function appendFileLines(file, t)
	-- append lines from the file on the indicated table
	if love.filesystem then
		-- Love
		for line in love.filesystem.lines(file) do
			table.insert(t, line)
		end
	else
		-- LovePotion
		for line in io.lines('game/'..file) do
			table.insert(t, line)
		end
	end
end

function saveScore()
	-- save to 5 score
	if love.filesystem then
		if love.filesystem.exists('scores.txt') then
			appendFileLines('scores.txt', scores)
		end
	else
		f=io.open(name,"r")
		if f~=nil then
			io.close(f)
			appendFileLines('scores.txt', scores)
		end
	end

	table.insert(scores, totalScore)
	table.sort(scores, function(a,b) return tonumber(a) > tonumber(b) end)
	gameState = 4
	if love.filesystem then
		f, errorstr = love.filesystem.newFile('scores.txt')
		if errorstr then
			print('Error on open file: '..errorstr)
		end
		f:open('w')
		for i = 1, 5 do
			if scores[i] then
				f:write(scores[i]..'\n')
			else
				break
			end
		end
		f:close()
	else
		f = io.open('game/scores.txt', 'w')
		for i = 1, 5 do
			if scores[i] then
				f:write(scores[i]..'\n')
			else
				break
			end
		end
		f:close()
	end
end
