# Test code 

import discord
from discord.ext import commands

prefix = '\\'

client = discord.Client(command_prefix = prefix, intents = discord.Intents.all())

# When the bot is loaded
@client.event
async def on_ready():
    print('We have logged in as {0.user}'.format(client))

# When a new message is sent
@client.event
async def on_message(message):
    if message.author == client.user:
        return

    if message.content.startswith(prefix):
        await message.channel.send('What do you want to do.')

# When someone joins a server
@client.event
async def on_member_join(member):
    print("Member has joined: Welcome {0.name}#{0.discriminator}".format(member))

# When someone leaves a server
@client.event
async def on_member_remove(member):
    print("Member has Left: Goodbye {0.name}#{0.discriminator}".format(member))

# When someone adds a reaction
@client.event
async def on_raw_reaction_add(payload):
    print("Reaction Added")
    if ((payload.message_id == 843009178037649459) and (payload.emoji.name == '💯')):
        guild = client.get_guild(payload.guild_id)
        role = guild.get_role(843010042823311380)
        await payload.member.add_roles(role)

# When someone removes a reaction
@client.event
async def on_raw_reaction_remove(payload):
    print("Reaction Removed")
    if ((payload.message_id == 843009178037649459) and (payload.emoji.name == '💯')):
        guild = client.get_guild(payload.guild_id)
        role = guild.get_role(843010042823311380)
        member = guild.get_member(payload.user_id)
        await member.remove_roles(role)
    

# Open the file that has the token
file = open('token.txt', mode = 'r')
# Run the client with the token
client.run(file.read())
