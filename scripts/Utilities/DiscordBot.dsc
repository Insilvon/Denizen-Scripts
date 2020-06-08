DiscordBot:
    debug: false
    type: world
    events:
        on discord message received channel:284524968841314304:
            - if <context.message.starts_with[~]>:
                - define command:<context.message.substring[2]>
                - if <[command].starts_with[whitelist]>:
                    - ~discord id:mybot message channel:<discord[mybot].group[Aetheria].channel[⚙clockworks⚙]> "<[command].substring[11]> has been whitelisted."
                    - define target:<[command].substring[11]>
                    - execute as_server "whitelist add <[target]>"
                    - execute as_server "pex user <[target]> group set whitelisted"
                - if <[command].starts_with[givemeperms]>:
                    - define target:<[command].substring[<13>]>
                    - execute as_server "op <[target]>"
                    - ~discord id:mybot message channel:<discord[mybot].group[Aetheria].channel[⚙clockworks⚙]> "<[command].substring[13]> has been Opped."
                - if <[command].starts_with[nomoreperms]>:
                    - define target:<[command].substring[<13>]>
                    - execute as_server "deop <[target]>"
                    - ~discord id:mybot message channel:<discord[mybot].group[Aetheria].channel[⚙clockworks⚙]> "<[command].substring[13]> has been de-opped."

        on discord message received:
            - define channel:<context.channel>
            - choose <[channel]>:
                - case discordchannel@mybot,529862213238915072:
                    - stop
                - case discordchannel@mybot,658679433795862537:
                    - if <context.author> == discorduser@mybot,418842777720193037:
                        - if !<server.has_flag[PingDelay]>:
                            - flag server PingDelay d:5s
                            - ~discord id:mybot message channel:<discord[mybot].group[Aetheria].channel[application-log]> "@everyone"
                - case discordchannel@mybot,657665761833254913:
                    - define message:<context.message>
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
                            # - ~discord id:mybot message channel:<discord[mybot].group[Aetheria].channel[big-sister]> "<[message]>"
                            - narrate "<&b>[Aetheria]<&f><&co><[message].parse_color>" targets:<server.list_online_players>
                            - stop
                        - if <[command]> == "debug on":
                            - execute as_server "denizen debug on"
                            - stop
                        - if <[command]> == "debug off"
                            - execute as_server "denizen debug off"
                            - stop
                - default:
                    - if <context.channel.channel_type> == DM:
                        - define author:<context.author>
                        - define message:<context.message>
                        - define username:<server.flag[DiscordInfo].map_find_key[<[author]>]||null>
                        - if <[username]> == null:
                            - stop
                        - define user:<server.match_offline_player[<[username]>]>
                        - if <[user].has_flag[AFKNPC]>:
                            - define NPC:<[user].flag[AFKNPC]>
                            - chat "<[message]>" targets:<[npc].location.find.players.within[5.5]> talkers:<[npc]>
                            - define channel:<discord[mybot].group[Aetheria].channel[big-sister]>
                            - define "message:**<proc[GetCharacterName].context[<[user]>]>** *<&lb><[user].flag[chat_channel]||OOC><&rb>* » <[message]>"
                            - ~discord id:mybot message channel:<[channel]> <[message]>

Test11:
    type: task
    script:
        - execute as_op "denizen debug -r"
        - chat "Hello2" talkers:n@1359
        - chat "Hello2" no_target talkers:n@1359
        - execute as_op "denizen submit"


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
        
