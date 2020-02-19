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
            - if <player.has_flag[AFKNPC]>:
                - define target:<player.flag[AFKNPC]>
                - remove <[target]>
        on player quits:
            - if <player.has_flag[AFKNPC]> && <player.has_flag[Discord_User]>:
                - define skin:<player.skin_blob>
                - define locale:<player.location>
                - create player <player.name.display> <[locale]> save:temp
                - adjust <entry[temp].created_npc> lookclose:TRUE
                - adjust <entry[temp].created_npc> skin_blob:<[skin]>
                - adjust <entry[temp].created_npc> name_visible:false
                - adjust <entry[temp].created_npc> set_assignment:AFKNPCAssignment
                - flag <entry[temp].created_npc> DiscordName:<player.flag[Discord_User]>
                - flag player AFKNPC:<entry[temp].created_npc>
        # on discord message deleted:
        #     - narrate <context.message> targets:<server.match_player[Mystic_Fennec]>
        #     - narrate <context.channel> targets:<server.match_player[Mystic_Fennec]>
        
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
