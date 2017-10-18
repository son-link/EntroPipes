--[[
	EntroPipes
	© 2015 - 2017 Alfonso Saavedra "Son Link"
	Under the GNU/GPL 3 license
	http://github.com/son-link/EntroPipes
	http://son-link.github.io
]]

-- title:  EntroPipes
-- author: Alfonso Saavedra "Son Link"
-- desc:   EntroPipes is a puzzle type game. Simply connect all pipes
-- saveid: EntroPipes
-- script: lua

-- Weight and heigth of the puzzle
W = 4
H = 4

-- Initial posotion of the pipe
initX = 8*6
initY = 8*4

local prevState -- for save last gameState
dialogSize = 16*8
selOption = 0 -- The seledted option on the main menu

puzzlesList = {
	[0] = {
		'446C7F9553C51291','2AAC6AA93AAC2AA9','6C6C139546C53939',
		'2C2C6BA93AEC2A91','442C57A953EC3A91','46AC3FC541153AA9',
		'46AC554553953AA9','6AAC52E952BC3AA9','2C442BF942BC3AA9',
		'6AA87AAC52A93AA8','442C3FE96BFC3811','6AAC56853B852AA9',
		'46AC3FAD6BA93AA8','6AEC7A9556AD3BA9','6AEC56FD53953AA9',
		'2EEC29556E9513A9','6AC416BD6BA93AA8','6AEC3C3D6FC53B91',
		'6EAC51693C542939','46AC55457BB93AA8',
	},
	[1] = {
		'686AAC3AFA856C16C513A939','42AAAC7C446D53BF953A8129',
		'4686AC3FC169693AFC3AA811','46AAAC552C6953A93C3AAAA9',
		'446EAC3F916943C2FC3A9011','686C6C56D555555795393929',
		'2EC6AC6955453C5155293AB9','2C68446956953ABFC52AA939',
		'6AAC6C78439552FA853ABAA9','6AAAAC7AAAAD56C6C5393939',
		'46AAAC7FAAC553AA953AAAA9','6C6AAC557AC553FA953ABAA9',
		'6AEAAC52BAAD7AAE853AABA9','6AAC003AC3AC6A96A93AA900',
		'2AEAAC6EBA8553AAAD3AAAA9','06C440697BBC3C7AA9039000',
		'686C2C1693C169283C3AAAA9','686AAC56FC693B93FC2AAA91',
		'682EAC7AAFC17AAF94382BA9','6A86EC3AA9516AAC543A83B9',
	},
	[2] = {
		'2EA86C452C153FAFAD6945415453F83B92B8','2C6AAC693C693C693C693C693AA93C2AAAA9',
		'6C6AE85392FC3AC6914693AC3F86C52BA939','2EAAA86B86AC3C696969503C3A92E92AAAB8',
		'6C2AAC53AEA95683AC53C2A956BAAC392AA9','6A86AC5469693F943C43AF8156C3AC393AA9',
		'6AAAAC56AAA953E86C52B81556C6C5393939','6AAAC456AC5555455555395553AA953AAAA9',
		'6AAC2C3AC3E96AFC3C3C53C5693EF93AA910','6AAA84546AAD553C453FEBD5693C553AA939',
		'6EAC6C55695553FE9556B969116C3C2A93A9','2EC6C46939393C2AAC696AA93C3AAC2BAAA9',
		'40000456AAC57D6C7D7D397D53AA95100001','00000006AAC069003C3EAAE905005003AA90',
		'6AAC6C3AC3956A96A956AFAC556969393A90','42AC6C3AC39546FC6939557C6A93FD3AAA91',
		'6EEEEC3955396AD7AC3AD7A96C556C3BBBB9','6C6C6C5153953AFC05443BC553AAF93AAAB8',
		'46A86C53AAD53EEA956956C53C39792BA838','2C6EAC6B97C5546D555395153E8529292BA8',
	},
	[3] = {
		'6EAAAAEC17A86C556D6E95155515454557853BFD1383A811','6E82AAEC13AEA8552EAFC4556FC13F95157C412D2913B829',
		'46AAAC447F8683FD154542D56FBBFC15516AD1453812B839','2AAAAAAC686AAA857ABAAA857AAAAE8556C6C3A939393AA8',
		'2C2AC6AC6FAC556953853D3C3AC3C1696A943AFC3AA92A91','46AAAAAC556AAC695552C53C553A956953AAA93C3AAAAAA9',
		'2AAAC46C686C3D153C552FC56917ED3956C5556C39391391','6AEC6AAC3C13F82D6F8456AD17A9112D696E842D3A9383A9',
		'2C6C6C6C6F95539553C396A95696C3C453A93AFD3AAAAA91','682AAC6C3EAAC395416C3AE93A93AAFC46C6C69539393929',
		'6AAEAAEC5683EC151786D5454545397D7B9382953AAAAAA9','6AAC2EEC382FA91146C3AC2C553AEBE93D6C3C782B93A938',
		'6806AAC03C6BAC3C0556C7C143D395503C3AE93C03AA9029','6EAC6EA8516B97AC3852AD45443EC79157A93FC4392AA939',
		'6AAC6AAC56A956C553C05395569056A953AC55003AA93900','2C6C6EAC6D53952953BAC7AC16AC51696943FAFC383AB811',
		'46846C6857AF979479696D69529695543C6BC3D52912BAB9','46EC2AAC3917AC2D46AFC145794116957AB82FC53A82A939',
		'06AAAAAC056AAAC5693C005556C56A95539556A93AA93900','6C2EAAC413A946D52AC4513D4453F82D7D543C6913BB8138',
	}
}

puzzle = {
	['size'] = 0,
	['puzzle'] = '',
	['newPipe'] = {},
	['num'] = 1
}

player = {
	['posx'] = 1,
	['posy'] = 1,
	['sprite'] = 4
}

game = {
	['state'] = 0,
	['time'] = 1,
	['totalTime'] = 120,
	['score'] = 0,
	['totalPuzzles'] = 0
}

ticks = 1 -- For count every frame for discount game time

-- Position of pipes sprites in the spritesheet
pipes = {
	[0] = 302,
	[1] = 256,
	[2] = 258,
	[3] = 260,
	[4] = 262,
	[5] = 264,
	[6] = 266,
	[7] = 268,
	[8] = 270,
	[9] = 288,
	['A'] = 290,
	['B'] = 292,
	['C'] = 294,
	['D'] = 296,
	['E'] = 298,
	['F'] = 300
}

function TIC()
	cls()
	moveCursor()
	if game['state'] ==  0 then
		map(30, 17)
		printc('EntroPipes', 0, 240, 15, 15, false, 3)
		printc('Up/Down: Select option.', 0, 240, 49)
		printc('Left/Right: Select puzzle size', 0, 240, 57)
		print('Play', 94, 73)
		if puzzle['size'] == 0 then
			print('4x4', 126, 73)
		elseif puzzle['size'] == 1 then
			print('6x4', 126, 73)
		elseif puzzle['size'] == 2 then
			print('6x6', 126, 73)
		elseif puzzle['size'] == 3 then
			print('8x6', 126, 73)
		end

		print('Top score', 94, 81)
		print('How to play', 94, 89)
		print('Exit', 94, 97)
		print('>', 86, 73+(selOption*8))
		printc('(C) 2015-2017 Alfonso Saavedra "Son Link"', 0, 240, 110)
	elseif game['state'] == 1 then
		map(30*puzzle['size'], 0)
		print_pipes()
		spr(player.sprite, (player.posx*16)+initX-16,(player.posy*16)+initY-16,0,1,0,0,2,2)
		print('TIME: '..game['time'],160, 25)
		print('SCORE:\n'..game['score'], 160, 58)

		if game['time'] > 0 then
			if ticks < 60 then
				ticks = ticks + 1
			else
				ticks = 1
				game['time'] = game['time'] - 1
			end
		else
			game['state'] = 3
		end

	elseif game['state'] == 2 then
		-- Puzzle complete
		map(0,17)
		print('TIME: '..game['time']-30,160, 25)
		print('SCORE:\n'..game['score'], 160, 58)
		printc("COMPLETE!", 16, dialogSize, 32, 15, false, 2)
		printc("Time: "..game['time'], 16, dialogSize, 56)
		printc("Score: "..game['score'], 16, dialogSize, 64)
		printc("Press A button", 16, dialogSize, 80)
		printc("to continue.", 16, dialogSize, 88)
	elseif game['state'] == 3 or game['state'] == 4 then
		-- Time over
		map(0, 17)
		--print_pipes()
		print('TIME: 0',160, 25)
		print('SCORE:\n'..game['score'], 160, 58)
		if game['state'] == 3 then
			printc("GAME OVER!", 16, dialogSize, 32, 15, false, 2)
		else
			printc("WIN!", 16, dialogSize, 32, 15, false, 2)
		end
		printc("Score: "..game['score'], 16, dialogSize, 48)
		printc("Resolved: "..game['totalPuzzles'], 16, dialogSize, 56)
		if game['score'] > pmem(puzzle['size']) then
			printc("NEW RECORD!", 16, dialogSize, 64, 6)
			pmem(puzzle['size'], game['score'])
		end
		printc("Press A button for", 16, dialogSize, 80)
		printc("return to main menu.", 16, dialogSize, 88)
	elseif game['state'] == 5 then
		map(0, 17)
		print('TIME:'..game['time'],160, 25)
		print('SCORE:\n'..game['score'], 160, 58)
		printc("PAUSE", 16, dialogSize, 56, 15, false, 2)
	elseif game['state'] == 6 then
		map(30, 17)
		printc('EntroPipes', 0, 240, 15, 15, false, 3)
		printc("TOP SCORE", 0, 240, 49, 15, false, 2)
		printc("4x4: "..pmem(0), 0, 240, 64)
		printc("6x4: "..pmem(1), 0, 240, 72)
		printc("6x6: "..pmem(2), 0, 240, 80)
		printc("8x6: "..pmem(3), 0, 240, 88)
		printc("Press A button for", 0, 240, 104)
		printc("return to main menu.", 0, 240, 112)
	elseif game['state'] == 7 then
		map(30, 17)
		printc('EntroPipes', 0, 240, 15, 15, false, 3)
		printc("HOW TO PLAY", 0, 240, 49, 15, false, 2)
		printc("Arrow Keys/Pad: Move cursor", 0, 240, 64)
		printc("A button (Z): Rotate pipe", 0, 240, 72)
		printc("X button (A): Pause/Play game", 0, 240, 80)
		printc("Press A button for", 0, 240, 104)
		printc("return to main menu.", 0, 240, 112)
	end
end

function genPuzzle()
	-- this function generate the puzzle
	puzzle['puzzle'] = puzzles[puzzle['num']]
	for i = 1, (W*H) do
		value = string.sub(puzzle['puzzle'],i,i)
		puzzle['newPipe'][i-1] = value
	end
	randPipes()
end

function moveCursor()
	-- Move Up
	if btnp(0,60,6) then
		if game['state'] == 0 then
			if selOption > 0 then
				selOption = selOption - 1
			else
				selOption = 3
			end

		elseif game['state'] == 1 then
			if player.posy > 1 then
				player.posy = player.posy - 1
			else
				player.posy = H
			end
		end
	end

	-- Move Down
	if btnp(1,60,6) then
		if game['state'] == 0 then
			if selOption < 3 then
				selOption = selOption + 1
			else
				selOption = 0
			end

		elseif game['state'] == 1 then
			if player.posy < H then
				player.posy = player.posy + 1
			else
				player.posy = 1
			end
		end
	end

	-- Move Left
	if btnp(2,60,6) then
		if game['state'] == 0 then
			if puzzle['size'] > 0 then
				puzzle['size'] = puzzle['size'] - 1
			else
				puzzle['size'] = 3
			end
		elseif game['state'] == 1 then
			if player.posx > 1 then
				player.posx = player.posx - 1
			else
				player.posx = W
			end
		end
	end

	-- Move Right
	if btnp(3,60,6) then
		if game['state'] == 0 then
			if puzzle['size'] < 3 then
				puzzle['size'] = puzzle['size'] + 1
			else
				puzzle['size'] = 0
			end
		elseif game['state'] == 1 then
			if player.posx < W then
				player.posx = player.posx + 1
			else
				player.posx = 1
			end
		end
	end

	-- Press A button
	if btnp(4,60,6) then
		if game['state'] == 0 then
			if selOption == 0 then
				game['state'] = 1
				restartGame()
			elseif selOption == 1 then
				game['state'] = 6
			elseif selOption == 2 then
				game['state'] = 7
			elseif selOption == 3 then
				exit()
			end
		elseif game['state'] == 1 then
			rotatePipe()
		elseif game['state'] == 2 then
			genPuzzle()
			game['state'] = 1
		elseif game['state'] == 3 or game['state'] == 4 or game['state'] == 6 or game['state'] == 7 then
			game['state'] = 0
		end
	end
	-- Press X button
	if btnp(6,60,6) then
		if game['state'] == 1 then
			game['state'] = 5
		elseif game['state'] == 5 then
			game['state'] = 1
		end
	end
end

function rotatePipe()
	local x = player.posx-1
	local y = player.posy-1
	piece = puzzle['newPipe'][y*W+x]
	if piece == 1 then
		puzzle['newPipe'][y*W+x] = 2
	elseif piece == 2 then
		puzzle['newPipe'][y*W+x] = 4
	elseif piece == 3 then
		puzzle['newPipe'][y*W+x] = 6
	elseif piece == 4 then
		puzzle['newPipe'][y*W+x] = 8
	elseif piece == 5 then
		puzzle['newPipe'][y*W+x] = 'A'
	elseif piece == 6 then
		puzzle['newPipe'][y*W+x] = 'C'
	elseif piece == 7 then
		puzzle['newPipe'][y*W+x] = 'E'
	elseif piece == 8 then
		puzzle['newPipe'][y*W+x] = 1
	elseif piece == 9 then
		puzzle['newPipe'][y*W+x] = 3
	elseif piece == 'A' then
		puzzle['newPipe'][y*W+x] = 5
	elseif piece == 'B' then
		puzzle['newPipe'][y*W+x] = 7
	elseif piece == 'C' then
		puzzle['newPipe'][y*W+x] = 9
	elseif piece == 'D' then
		puzzle['newPipe'][y*W+x] = 'B'
	elseif piece == 'E' then
		puzzle['newPipe'][y*W+x] = 'D'
	end
	calculateEntropy()
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
			if string.match(puzzle['newPipe'][y*W+x],'[369C]') then
				puzzle['newPipe'][y*W+x] = randArray({3,6,9,'C'})
			elseif string.match(puzzle['newPipe'][y*W+x], '[1248]') then
				puzzle['newPipe'][y*W+x] = randArray({1,2,4,8})
			elseif string.match(puzzle['newPipe'][y*W+x], '[7BDE]') then
				puzzle['newPipe'][y*W+x] = randArray({7,'B','D','E'})
			elseif string.match(puzzle['newPipe'][y*W+x],'[5A]') then
				puzzle['newPipe'][y*W+x] = randArray({5,'A'})
			end
		end
	end
	gameState = 1
end

function calculateEntropy()
	-- Calculate the entropy. If 0 the puzzle is resolve
	entropy = 0;
	entropyLocal = 0
	for y = 0, H-1 do
		for x = 0, W-1 do
			entropyLocal = 0
			if  ( ( checkUp(puzzle['newPipe'][y*W+x]) ) and ( ( y == 0 ) or ( not checkDown(puzzle['newPipe'][(y-1)*W+x]) ) ) ) then entropyLocal = entropyLocal + 1 end
			if  ( ( checkDown(puzzle['newPipe'][y*W+x]) ) and ( ( y == H-1 ) or ( not checkUp(puzzle['newPipe'][(y+1)*W+x]) ) ) ) then  entropyLocal = entropyLocal + 1 end
			if  ( ( checkRight(puzzle['newPipe'][y*W+x]) ) and ( ( x == W-1 ) or ( not checkLeft(puzzle['newPipe'][y*W+x+1]) ) ) ) then  entropyLocal = entropyLocal + 1 end
			if  ( ( checkLeft(puzzle['newPipe'][y*W+x]) ) and ( ( x == 0 ) or ( not checkRight(puzzle['newPipe'][y*W+x-1]) ) ) ) then  entropyLocal = entropyLocal + 1 end
			entropy = entropy + entropyLocal;
		end
	end
	if entropy == 0 then
		score = math.ceil(game['time']) * 10
		game['score'] = game['score'] + score
		game['totalTime'] = game['totalTime'] + game['time']
		game['time'] = game['time'] + 30
		game['totalPuzzles'] = game['totalPuzzles'] + 1
		if puzzle['num'] < #puzzles then
			puzzle['num'] = puzzle['num'] + 1
			game['state'] = 2
		else
			saveScore()
		end
	end
end

function checkUp(tile) return (string.match("13579BDF", tile) ) end
function checkDown(tile) return ( string.match("4567CDEF", tile) ) end
function checkRight(tile) return ( string.match("2367ABEF", tile) ) end
function checkLeft(tile) return (string.match("89ABCDEF", tile) ) end

function saveScore()
	if game['score'] > pmem(puzzles['size']) then
		pmem(puzzle['size'], game['score'])
	end
	game['state'] = 3

end

function print_pipes()
	for y = 0, H -1 do
		for x = 0, W -1 do
			piece = puzzle['newPipe'][y*W+x]
			spr(pipes[piece], (x*16)+initX, (y*16)+initY,0,1,0,0,2,2)
		end
	end
end

function restartGame()
	puzzle['puzzle'] = ''
	puzzle['newPipe'] = {}
	puzzle['num'] = 1

	player['posx'] = 1
	player['posy'] = 1

	game['time'] = 120
	game['totalTime'] = 0
	game['score'] = 0
	game['totalPuzzles'] = 0

	if puzzle['size'] == 0 then
		W = 4
		H = 4
		initX = 48
		initY = 32
	elseif puzzle['size'] == 1 then
		W = 6
		H = 4
		initX = 32
		initY = 32
	elseif puzzle['size'] == 2 then
		W = 6
		H = 6
		initX = 32
		initY = 16
	elseif puzzle['size'] == 3 then
		W = 8
		H = 6
		initX = 16
		initY = 16
	end

	ticks = 1
	puzzles = puzzlesList[puzzle['size']]
	shuffle(puzzles)
	genPuzzle()
end

function printc(txt, posx, size, posy, color, fixed, scale)
	color = color or 15
	fixed = fixed or false
	scale = scale or 1
	w = print(txt, posx, -32, color, fixed, scale)
	x = ((size - w)//2) + posx
	print(txt, x, posy, color, fixed, scale)
end
