--[[
	Save Table to File
	Load Table from File
	v 1.0

	Lua 5.2 compatible

	Only Saves Tables, Numbers and Strings
	Insides Table References are saved
	Does not save Userdata, Metatables, Functions and indices of these
	----------------------------------------------------
	table.save( table , filename )

	on failure: returns an error msg

	----------------------------------------------------
	table.load( filename or stringtable )

	Loads a table that has been saved via the table.save function

	on success: returns a previously saved table
	on failure: returns as second argument an error msg
	----------------------------------------------------

	Licensed under the same terms as Lua itself.
]]--
do
	-- declare local variables
	--// exportstring( string )
	--// returns a "Lua" portable version of the string
	local function exportstring( s )
		return string.format("%q", s)
	end

	--// The Save Function
	function table.save(  tbl,filename )
		local charS,charE = "   ","\n"
		-- local file,err = io.open( filename, "wb" )
		local file = ""

		-- initiate variables for save procedure
		local tables,lookup = { tbl },{ [tbl] = 1 }
		file = file .. "return {"..charE

		for idx,t in ipairs( tables ) do
			file = file .. "-- Table: {"..idx.."}"..charE
			file = file .. "{"..charE
			local thandled = {}

			for i,v in ipairs( t ) do
				thandled[i] = true
				local stype = type( v )
				-- only handle value
				if stype == "table" then
					if not lookup[v] then
						table.insert( tables, v )
						lookup[v] = #tables
					end
					file = file .. charS.."{"..lookup[v].."},"..charE
				elseif stype == "string" then
					file = file ..  charS..exportstring( v )..","..charE
				elseif stype == "number" then
					file = file ..  charS..tostring( v )..","..charE
				end
			end

			for i,v in pairs( t ) do
				-- escape handled values
				if (not thandled[i]) then

					local str = ""
					local stype = type( i )
					-- handle index
					if stype == "table" then
						if not lookup[i] then
							table.insert( tables,i )
							lookup[i] = #tables
						end
						str = charS.."[{"..lookup[i].."}]="
					elseif stype == "string" then
						str = charS.."["..exportstring( i ).."]="
					elseif stype == "number" then
						str = charS.."["..tostring( i ).."]="
					end

					if str ~= "" then
						stype = type( v )
						-- handle value
						if stype == "table" then
							if not lookup[v] then
								table.insert( tables,v )
								lookup[v] = #tables
							end
							file = file .. str.."{"..lookup[v].."},"..charE
						elseif stype == "string" then
							file = file .. str..exportstring( v )..","..charE
						elseif stype == "number" then
							file = file .. str..tostring( v )..","..charE
						end
					end
				end
			end
			file = file .. "},"..charE
		end
		file = file .. "}"
		if love.filesystem then
			love.filesystem.write(filename, file)
		else
			f = io.open(filename, 'w')
			f:write(file)
			f:close()
		end
	end

	--// The Load Function
	function table.load( sfile )
		local ftables
		local err
		if love.filesystem then
			ftables,err = love.filesystem.load( sfile )
		else
			ftables, err = loadfile (sfile)
		end
		
		if err then return _,err end
		local tables = ftables()
		for idx = 1,#tables do
			local tolinki = {}
			for i,v in pairs( tables[idx] ) do
				if type( v ) == "table" then
					tables[idx][i] = tables[v[1]]
				end
				if type( i ) == "table" and tables[i[1]] then
					table.insert( tolinki,{ i,tables[i[1]] } )
				end
			end
			-- link indices
			for _,v in ipairs( tolinki ) do
				tables[idx][v[2]],tables[idx][v[1]] =  tables[idx][v[1]],nil
			end
		end
		return tables[1]
	end
-- close do
end

-- ChillCode