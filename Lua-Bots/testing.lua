local discordia = require('discordia') --Requires Discordia
local coro = require('coro-http')
local json = require('json')
local options = require('options') --Requires the Options File
local files = require('files') --Requires the Files file
local client = discordia.Client() --Sets the client to discordia.Client

discordia.extensions() --Used for useful functions to be included, mainly math, string, and table related

local prefix = '~' --The Prefix for Commands

local lines = {} --Empty Table(Array)

local num = 0;

local allowbots = false;

--------------------------------------------------------------------------------------------------------------------------------

local commands = { --Command object table

	--Command Format
	[prefix .. "format"] = { --Command Name (Prefix + Name)
		name = "format", --Name Value of Command
		description = "Format for commands", --Description of Command
		exec = function(message)
			
			--Executed Task if command is run

		end
	},

	[prefix .. "ping"] = { --The Command, Ping
		name = "ping", --Name of Command
		description = "Answers with pong.", --Description of Command
		exec = function(message)
			--Executed Task of Command
			message.channel:send("Pong!") --Responds with "Pong!""

		end
	},

	[prefix .. "hello"] = { --The Command, Hello
		name = "hello", --Name of Command
		description = "Answers with world.", --Description of Command
		exec = function(message)
			--Executed Task of Command
			message.channel:send("world!") --Responds with "World!"

		end
	},

	[prefix .. "echo"] = { --The Command, Echo
		name = "echo", --Name of Command
		description = "Echoes the sent message", --Description of Command
		exec = function(message)
			--Executed Task of Command
			local args = message.content:split(" ") --Splits the content of the message based on spaces and puts it into a table
			table.remove(args, 1) --Removes the first "word" in the message which would be the command "!echo"
			message.channel:send(table.concat(args, " ")) --Replies with the message concatenated back into a string with each entry of the array being seperated by a space

		end
	},

	[prefix .. "lines"] = { --The Command, Lines
		name = "lines", --Name of Command
		description = "Clears and send a files contents", --Description of Command
		exec = function(message)
			--Executed Task of Command
			message.channel:send { --Sent a message
				file = {"messages.txt", table.concat(lines, "\n")} -- Concatenate and send the collected lines in a file
			}
			lines = {} --Reset the table lines into an empty table.

		end
	},

	[prefix .. "join"] = { --Command Name (Prefix + Name)
		name = "join", --Name Value of Command
		description = "Join a specified voice chat", --Description of Command
		exec = function(message)
			--Executed Task of Command
			if message.author then
				
			end

		end
	},

	[prefix .. "interaction"] = {
		name = "interaction",
		description = "interact with another bot",
		exec = function(message)

			message:reply("$rhyme")

		end
	},

	[prefix .. "count"] = {
		name = "count",
		description = "Count up by 1",
		exec = function(message)

			num = num + 1
			message.channel:send(num)
		end
	},

	[prefix .. "control"] = {
		name = "control",
		description = "Take Control of the Bot",
		exec = function(message)
			if message.channel.id == '704512295899889736' then

				local chat, err = client:getChannel("653698244144267328")

				if not chat then
					return
				end

				local args = message.content:split(" ")
				table.remove(args, 1)
				chat:send(table.concat(args, " "))
			end
		end
	},

	[prefix .. "allowbots"] = {
		name = "allowbots",
		description = "Allows bot messages to be handled",
		exec = function(message)
			if allowbots == false then
				allowbots = true
				message:reply("Now allowing bot messages to be handled")
			else
				allowbots = false
				message:reply("Now restricting the handling of bot messages")
			end
		end
	}
}

--------------------------------------------------------------------------------------------------------------------------------

client:on('ready', function() --When the Bot is on and ready

	print('Logged in as '.. client.user.username) --Prints saying that it's logged in

end)

--------------------------------------------------------------------------------------------------------------------------------

client:on('messageCreate', function(message) --When a message is created in a chat

	print(message.author.tag .. '\n' .. message.content) --Print the messages content

	--	
	--if message.content == "What do you want to Rhyme" then
	--	message:reply("$rhyme")
	--end
	--

	table.insert(lines, message.content) --Insert the message content into table "lines"

	if allowbots == false then
		if message.author.bot == true then
			return
		end
	end

	local args = message.content:split(" ") -- split all arguments into a table

	--Attempting to make a reddit search system
	if args[1]:sub(1, 2) == 'r/' then
		coroutine.wrap(function()
			local link = "https://www.reddit.com"
			local subreddit = args[1]:sub(3, args[1].length)
			if subreddit then
				subreddit = args[1]
				link = link .. '/' .. subreddit .. '/hot/'
			else 
				subreddit = 'r/memes'
				link = link .. '/' .. subreddit .. '/hot/'
			end

			local result, body = coro.request("GET", link)
			print(result)
			--print(body)
			--local content = json.parse(body)
			--print(body)

			--message:reply("<@!" .. message.author.id .. "> " .. content)

		end)()
	end


	local command = commands[args[1]] --Create Variable command thats equal to the entry of commands for the first word said in a message


	if command then -- If the command exists then
		print(command.name) --Print the Command
		command.exec(message) -- execute the command

	end



	if args[1] == prefix.."help" then -- display all the commands
		local output = {}
		for word, tbl in pairs(commands) do
			table.insert(output, "Command: " .. word .. "\nDescription: " .. tbl.description)

		end

		message.channel:send(table.concat(output, "\n\n"))

	end


end)

--------------------------------------------------------------------------------------------------------------------------------

client:run(options.token)
