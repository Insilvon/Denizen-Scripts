AFKFormat:
    type: format
    format: "<&e>[AFK Characters]<&co><&f> <text>"

AFKNPC:
    type: command
    debug: true
    name: afknpc
    description: (DEV) Leaves a ghost of yourself behind
    usage: /afknpc
    aliases:
    - afk
    script:
        - define character:<proc[GetCharacterName].context[<player>]||null>
        - if <[character]> == null:
            - narrate "You must have a character set up to use this command!"
            - stop
        - if !<player.has_flag[Discord_User]>:
            - narrate "You must verify your discord account before you can use this feature."
            - stop
        - if <player.has_flag[AFKNPC]>:
            - flag player AFKNPC:!
            - narrate "You will no longer leave an NPC behind when you log off." format:AFKFormat
        - else:
            - flag player AFKNPC
            - narrate "You will now leave an NPC of yourself behind when you log off." format:AFKFormat

AFKNPCController:
    type: world
    events:
        on player joins:
            - wait 2s
            - if <player.has_flag[AFKNPC]> || <player.has_flag[Discord_User]>:
                - define target:<player.flag[AFKNPC]||null>
                - if <[target]> != null && <[target].is_npc>:
                    - remove <[target]>
                    - flag player AFKNPC
        on player quits:
            - if <player.has_flag[AFKNPC]> && <player.has_flag[Discord_User]>:
                - define skin:<player.skin_blob>
                - define locale:<player.location>
                - create player <player.display_name> <[locale]> save:temp
                - flag player AFKNPC:<entry[temp].created_npc>
                - flag <entry[temp].created_npc> DiscordName:<player.flag[Discord_User]>
                - wait 1s
                - adjust <entry[temp].created_npc> lookclose:TRUE
                - adjust <entry[temp].created_npc> skin_blob:<[skin]>
                - adjust <entry[temp].created_npc> name_visible:false
                - adjust <entry[temp].created_npc> set_assignment:AFKNPCAssignment

DiscordVerification:
    type: command
    name: verify
    description: no
    usage: /verify YourNameXXXX
    script:
        - if <context.args.size> == 1 && <context.args.get[1]> == test:
            - define value:<proc[ReadBaseYAML].context[<player>|Info.Discord.account]>
            - narrate "<&d>Discord<&co> A message has been sent to the account on file."
            - ~discord id:mybot message user:<[value]> "Your account is linked and is working!"
            - stop
        - if <context.args.size> >= 1 && <context.args.get[1]> != confirm:
            - if <context.args.size> == 1:
                - define user:<context.args.get[1]>
            - else:
                - define user:<context.args.get[1]>
                - foreach <context.args.get[2].to[<context.args.size>]> as:theArg:
                    - if <[theArg].starts_with[#]>:
                        - define user:<[user]><[theArg]>
                    - else:
                        - define "user:<[user]> <[theArg]>"
            
            - define temp:<discord[mybot].group[Aetheria].member[<[user]>]>
            - if <[temp]> != null:
                - define key:<util.random.uuid>
                - flag player discord_verify:<[key]>
                - flag player discord_name:<[temp]>
                - narrate "<&d>Discord<&co> A message has been sent to the discord user <[temp].name>"
                # - narrate "<[user]>"
                - ~discord id:mybot message user:<[temp]> "Hello. A minecraft user `<player.name>` has attempted to verify this account as theirs. If this is you, please run `/verify confirm <[key]>` in game. If this is not you, please inform a Server Admin."
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

AFKNPCAssignment:
    type: assignment
    interact scripts:
    - 1 AFKNPCInteract

AFKNPCInteract:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:.*/
                    script:
                        - define message:<context.message>
                        - define name:<proc[GetCharacterName].context[<player>]>
                        - discord id:mybot message user:<npc.flag[DiscordName]> "**<[name]><&co>** <[message]>"