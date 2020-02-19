DiscordBot:
    debug: false
    type: world
    events:
        on discord message received channel:284524968841314304:
            - if <context.message.starts_with[~]>:
                - define command:<context.message.substring[<2>]>:
                - if <[command].starts_with[whitelist]>:
                    - ~discord id:mybot message channel:<discord[mybot].group[Aetheria].channel[⚙clockworks⚙]> "<[command].substring[<11>]> has been whitelisted."
                    - execute as_server "whitelist add <[command].substring[<11>]>"
        on discord message received:
            - define channel:<context.channel>
            - choose <[channel]>:
                - case discordchannel@mybot,529862213238915072:
                    - stop
                - case discordchannel@mybot,658679433795862537:
                    - if <context.author> == discorduser@mybot,418842777720193037:
                        - ~discord id:mybot message channel:<discord[mybot].group[Aetheria].channel[application-log]> "@everyone"
                - case discordchannel@mybot,657665761833254913:
                    - define message:<context.message>
                    #- narrate "Message: <context.message>" targets:<server.match_player[Insilvon]>
                    #- narrate "<context.author.nickname>" targets:<server.match_player[Insilvon]>
                    #- narrate "<context.author.id>" targets:<server.match_player[Insilvon]>
                    #- narrate "<context.author.name>" targets:<server.match_player[Insilvon]>
                    #- narrate "<[message]>" targets:<server.match_player[Insilvon]>
                    #- narrate "<[message].starts_with[~]>" targets:<server.match_player[Insilvon]>
                    - if <[message].starts_with[~]>:
                        - define command:<context.message.substring[<2>]>
                        - if <[command]> == reload:
                            - execute as_server "ex reload"
                            - ~discord id:mybot message channel:<context.channel> "*Denizen has been reloaded.*"
                            - stop
                        - if <[command]> == players:
                            - define playerlist:<server.list_online_players>
                            - if <[playerlist].size> == 0:
                                - ~discord id:mybot message channel:<context.channel> "Nobody is online. Start an event!"
                                - stop
                            - else:
                                - foreach <[playerlist]> as:player:
                                    - define newPlayerlist:->:<[player].name>
                                - define result:<[newPlayerList].comma_separated>
                            - ~discord id:mybot message channel:<context.channel> "<[result]>"
                            - stop
                        - if <[command]> == characters:
                            - define playerlist:<server.list_online_players>
                            - if <[playerlist].size> == 0:
                                - ~discord id:mybot message channel:<context.channel> "Nobody is online. Start an event!"
                                - stop
                            - else:
                                - foreach <[playerlist]> as:player:
                                    - define newPlayerlist:->:<proc[GetCharacterName].context[<[player]>]||<player.name>>
                                - ~discord id:mybot message channel:<context.channel> "<[newplayerlist].comma_separated>"
                                - stop

                        - if <[command].starts_with[say]>:
                            - define message:<[command].substring[<4>]>
                            - ~discord id:mybot message channel:<discord[mybot].group[Aetheria].channel[big-sister]> "<[message]>"
                            - stop
                        - if <[command]> == "debug on":
                            - execute as_server "denizen debug on"
                            - stop
                        - if <[command]> == "debug off"
                            - execute as_server "denizen debug off"
                            - stop
                - default:
                    - if <context.channel.type>  == DM:
                        - define author:<context.author>
                        # - narrate "<[author]>" targets:<server.match_player[Mystic_Fennec]>
                        - define message:<context.message>
                        - define username:<server.flag[DiscordInfo].map_find_key[<[author]>]>
                        # - narrate "Received a message from <context.author> <[message]> belonging to <[username]>" targets:<server.match_player[Mystic_Fennec]>
                        - define user:<server.match_offline_player[<[username]>]>
                        - if <[user].has_flag[AFKNPC]>:
                            - define NPC:<[user].flag[AFKNPC]>
                            - chat <[message]> no_target talkers:<[npc]>
                            - define channel:<discord[mybot].group[Aetheria].channel[big-sister]>
                            - define "message:**<proc[GetCharacterName].context[<[user]>]>** *<&lb><[user].flag[chat_channel]||OOC><&rb>* » <[message]>"
                            - ~discord id:mybot message channel:<[channel]> <[message]>

AetheriaDiscordBot:
    type: command
    name: dDiscord
    description: no
    usage: /dDiscord
    script:
        - if <context.args.size> == 1:
            - if <context.args.get[1]> == connect:
                - yaml "load:Utilities/DiscordBot.yml" id:DiscordBot
                - ~discord id:mybot connect code:<yaml[DiscordBot].read[info.code]>
                - narrate "Connected!"
            - if <context.args.get[1]> == disconnect:
                - ~discord id:mybot disconnect
                - narrate "Disconnected!"
        - if <context.args.size> == 2:
            - if <context.args.get[1]> == message || <context.args.get[1]> == m:
                - ~discord id:mybot message channel:<discord[mybot].group[Aetheria].channel[⚙clockworks⚙]> "<context.args.get[2]>"
                # - ~discord id:mybot message channel:<discord[mybot].group[Aetheria].channel[admin-chat]> "<context.args.get[2]>"
                - narrate "Message sent!"
        # - narrate "Unknown Command"
        
DiscordVerification:
    type: command
    name: verify
    description: no
    usage: /verify YourNameXXXX
    script:
        - if <context.args.size> == 1 && <context.args.get[1]> == test:
            - define value:<proc[ReadBaseYAML].context[<player>|Info.Discord.account]>
            - narrate "<&d>Discord<&co> A message has been sent to the account on file."
            - discord id:mybot message user:<[value]> "Your account is linked and is working!"

            - stop
        - if <context.args.size> == 1:
            - define user:<context.args.get[1]>
            - define temp:<discord[mybot].group[Aetheria].member[<[user]>]>
            - if <[temp]> != null:
                - define key:<util.random.uuid>
                - flag player discord_verify:<[key]>
                - flag player discord_name:<[temp]>
                - narrate "<&d>Discord<&co> A message has been sent to the discord user <[temp].name>"
                - discord id:mybot message user:<[temp]> "Hello. A minecraft user `<player.name>` has attempted to verify this account as theirs. If this is you, please run `/verify confirm <[key]>` in game. If this is not you, please inform a Server Admin."
            - else:
                - narrate "<&d>Discord<&co> No user was found with this name. Please use the format of Username#1234."
        - if <context.args.size> == 2 && <context.args.get[1]> == confirm:
            - define key:<context.args.get[2]>
            - if <player.flag[discord_verify]> == <[key]>:
                - narrate "<&d>Discord<&co> Your discord account is now confirmed and linked to this minecraft account."
                - define temp:<player.flag[discord_name]>
                # - narrate <[temp]>
                - run SetBaseYAML def:<player>|Info.Discord.name|<[temp].name>
                - run SetBaseYAML def:<player>|Info.Discord.account|<[temp]>
                - flag server DiscordInfo:->:<player.name>/<[temp]>
                - flag player discord_verify:!
                - flag player discord_name:!
                - flag player discord_user:<[temp]>
            - else:
                - narrate "<&d>Discord<&co> The key entered is incorrect. Please reconfirm."
                - flag player discord_verify:!
                - flag player discord_name:!