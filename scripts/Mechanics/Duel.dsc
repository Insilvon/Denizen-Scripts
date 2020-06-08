#Flags
# <server.flag[Duel_YourRandomUUIDHere]> - stores a list of players currently fighting to loop through
# <server.flag[Duel_YourRandomUUIDHere_Turn]> - stores the current index of the player

# <player.flag[Duel]> - store the UUID to link to the Duel_YourRandomUUIDHere flag
# <player.flag[Duel_Target]>
# <player.flag[Duel_Health]>
DuelPVPHandler:
    type: world
    debug: off
    events:
        on player damages player:
            - if <context.entity.has_flag[Duel]>:
                - define uuid:<context.entity.flag[Duel]>
                - narrate "<&e>Somebody has started to PVP!" format:DuelFormat target:<server.flag[Duel_<[uuid]>]>
                - run DuelEnd def:<[uuid]>
DuelFormat:
    type: format
    format: "<&8>[Duel]<&co><&8> <text>"

DuelActionFormat:
    type: format
    format: "<&8><&gt><&gt><&co><&8> <text>"

DuelSidebar:
    type: task
    debug: off
    speed: instant
    definitions: uuid
    script:
        - while <server.has_flag[Duel_<[uuid]>]>:
            # - narrate <server.flag[Duel_<[uuid]>]>
            # - narrate <[target].flag[Duel]>
            - define thePlayers:<server.flag[Duel_<[uuid]>]>
            - foreach <[thePlayers]> as:data:
                - define players:->:<[data]>
                - if <[data].is_npc>:
                    - define list:->:<[data].name>
                - else:
                    - define list:->:<[data].name.display>
                - define HP:->:<[data].flag[Duel_Health]>
                - define Power:->:<[data].flag[Duel_Power]||0>
                - define Protection:->:<[data].flag[Duel_Protection]||0>
            - sidebar set "title:<&c>Duel - HP" "values:<[list]>" "scores:<[HP]>" players:<[thePlayers]>
            - wait 3s
            - sidebar set "title:<&e>Duel - Power" "values:<[list]>" "scores:<[power]>" players:<[thePlayers]>
            - wait 3s
            - sidebar set "title:<&d>Duel - Defense" "values:<[list]>" "scores:<[protection]>" players:<[thePlayers]>
            - wait 3s
            - define thePlayers:!
            - define players:!
            - define list:!
            - define HP:!
            - define Power:!
            - define Protection:!
        - sidebar remove
Duel:
    type: command
    name: duel
    desc: sh
    usage: sh
    permission: aetheria.duel
    aliases:
    - d
    script:
        - define command:<context.args.get[1]||null>
        - define uuid:<player.flag[Duel]||null>
        - choose <[command]>:
            - wait 1s
            - case attack:
                - run DuelMove def:attack|<player>
            - case defend:
                - run DuelMove def:defend|<player>
            - case prepare:
                - run DuelMove def:prepare|<player>
            - case accept:
                - if <player.has_flag[Duel_Invite]>:
                    - define host:<player.flag[Duel_Invite]>
                    - if <[host].has_flag[Duel]>:
                        #multi man duel
                        - run DuelAdd def:<player>|<[host]>
                    - else:
                        # two person duel
                        - run DuelStart def:<[host]>|<player>
            - case decline:
                - if <player.has_flag[Duel_Invite]>:
                    - define host:<player.flag[Duel_Invite]>
                    - narrate "<player.name.display> has rejected your challenge." format:DuelFormat target:<[host]>
                    - narrate "You have rejected the challenge." format:DuelFormat
                    - flag <[host]> Duel_Invite:!
                    - flag player Duel_Invite:!
            - case reset:
                - inject DuelReset
            - case target:
                - flag player Duel_Target:<context.args.get[2]||null>
            - case forfeit:
                - if <player.has_flag[Duel]>:
                    - flag server Duel_<player.flag[Duel]>_Over:true
                    # - narrate "You have forfeit"
                    - narrate "<player.name.display><&8> has forfeit the fight." target:<[user]> format:DuelFormat
                    - run DuelEnd def:<player.flag[Duel]>
                    # - define uuid:<player.flag[Duel]>
                    # - foreach <server.flag[Duel_<[uuid]>]> as:user:
                    #     - narrate "<player.name.display><&8> has forfeit the fight." target:<[user]> format:DuelFormat
                    #     - flag <[user]> Duel_Invite:!
                    #     - sidebar remove players:<server.flag[Duel_<[uuid]>]>
                    #     - flag <[user]> Duel:!
                    #     - flag <[user]> Duel_Health:!
                    #     - flag <[user]> Duel_Protection:!
                    #     - flag <[user]> Duel_Power:!
                    #     - flag <[user]> Duel_KO:!
                    #     - flag server Duel_<[uuid]>_Waiting:!
            - default:
                - if <[command]> == help:
                    - narrate "Invite another player to fight with /duel" format:DuelFormat
                    - stop
                - else:
                    - define target:<player.target||null>
                    - if <[target]> == null || <[target].entity_type> != PLAYER:
                        - narrate "You must be looking at a player!" format:DuelFormat
                        - stop
                    - if <[target].has_flag[Duel]>:
                        - narrate "The target cannot already be in combat!" format:DuelFormat
                        - stop
                    - narrate "<&e>You have been challenged to a duel by <&b><player.name.display><&e>. If you reject, PVP combat is legal." target:<[target]> format:DuelFormat
                    - narrate "<&hover[Click Me!]><&click[/d accept]><&a>Accept<&f><&end_click><&end_hover> | <&hover[Click Me!]><&click[/d decline]><&e>Decline<&f><&end_click><&end_hover>" target:<[target]> format:DuelActionFormat
                    - narrate "<&e>You have challenged <&b><[target].name><&e>. If they reject, PVP is legal." target:<player> format:DuelFormat
                    - flag <[target]> Duel_Invite:<player> d:5m
DuelReset:
    type: task
    debug: off
    speed: instant
    script:
        - flag player Duel_Invite:!
        - flag player Duel:!
        - flag player Duel_Target:!
        - flag player Duel_Health:!
        - flag player Duel_KO:!
        - flag player Duel_Power:!
        - flag player Duel_Protection:!

DuelMove:
    type: task
    debug: off
    speed: instant
    definitions: choice|user
    script:
        - if <proc[DuelPlayerCheck].context[<[user]>]> && !<player.has_flag[DuelMoved]>:
            - flag <[user]> DuelMoved
            - define uuid:<[user].flag[Duel]>
            #colin luvs emily
            - choose <[choice]>:
                - case attack:
                    - inject DuelAttack
                - case defend:
                    - inject DuelDefend
                - case prepare:
                    - inject DuelPrepare
        - else:
            - narrate "It's not your turn!" format:DuelFormat


DuelPlayerCheck:
    type: procedure
    debug: off
    definitions: user
    script:
        - define uuid:<[user].flag[Duel]||null>
        - if <[uuid]> != null:
            - if <proc[GetCurrentPlayer].context[<[uuid]>]> == <[user]>:
                - determine true
        - determine false

DuelStart:
    type: task
    debug: off
    speed: instant
    definitions: user1|user2
    script:
        # Clean up player 1
        - if <[user1].has_flag[Duel]>:
            - define uuid:<[user1].flag[Duel]>
            - flag server Duel_<[uuid]>:!
            - flag server Duel_<[uuid]>_Turn:!
            - flag server Duel_<[uuid]>_Waiting:!
        - if <[user1].has_flag[Duel_Power]>:
            - flag <[user1]> Duel_Power:!
        - if <[user1].has_flag[Duel_Power]>:
            - flag <[user1]> Duel_Protection:!
        - flag <[user1]> Duel_Invite:!
        # Clean up player 2
        - if <[user2].has_flag[Duel]>:
            - define uuid:<[user2].flag[Duel]>
            - flag server Duel_<[uuid]>:!
            - flag server Duel_<[uuid]>_Turn:!
            - flag server Duel_<[uuid]>_Waiting:!
        - if <[user2].has_flag[Duel_Power]>:
            - flag player Duel_Power:!
        - if <[user2].has_flag[Duel_Power]>:
            - flag player Duel_Protection:!
        - flag <[user2]> Duel_Invite:!
        # Start a new duel and add them both to it
        - define uuid:<util.random.uuid>
        - run AddCharacterToDuel def:<[user1]>|<[uuid]> instantly
        - run AddCharacterToDuel def:<[user2]>|<[uuid]> instantly
        - run DuelSidebar def:<[uuid]>
        - define x:<[user1].location.add[-13,-13,-13]>
        - define y:<[user1].location.add[13,13,13]>
        - note cu@<[user1].location.world>,<[x].xyz>,<[y].xyz> as:Duel_<[uuid]>
        - run DuelHeartbeat def:<[uuid]>

DuelAdd:
    type: task
    debug: off
    speed: instant
    definitions: user|host
    script:
        - define uuid:<[host].flag[Duel]>
        - if <[user].has_flag[Duel]>:
            - flag server Duel_<[uuid]>:!
            - flag server Duel_<[uuid]>_Turn:!
            - flag server Duel_<[uuid]>_Waiting:!
        - flag <[user]> Duel_Power:!
        - flag <[user]> Duel_Protection:!
        - flag <[user]> Duel_Invite:!
        - define session:<[host].flag[duel]>
        - run AddCharacterToDuel def:<[user]>|<[uuid]> instantly
        - if <[user].is_npc>:
            - narrate "<[user].name> has joined the fight!" format:DuelFormat target:<server.flag[Duel_<[uuid]>]>
            - flag server Duel_<[uuid]>_NPCs:->:<[user]>
        - else:
            - narrate "<[user].name.display> has joined the fight!" format:DuelFormat target:<server.flag[Duel_<[uuid]>]>

AddCharacterToDuel:
    type: task
    debug: off
    definitions: user|uuid
    script:
        - flag server Duel_<[uuid]>:->:<[user]>
        - flag <[user]> Duel:<[uuid]>
        - flag <[user]> Duel_Health:20
        - wait 1s

GetNextPlayer:
    type: procedure
    debug: off
    definitions: uuid
    script:
        - flag server Duel_<[uuid]>_Turn:++
        - if <server.flag[Duel_<[uuid]>_Turn]> > <server.flag[Duel_<[uuid]>].size>:
            - flag server Duel_<[uuid]>_Turn:1
        - define index:<server.flag[Duel_<[uuid]>_Turn]>
        - define name:<server.flag[Duel_<[uuid]>].get[<[index]>]>
        - determine <[name]>

GetCurrentPlayer:
    type: procedure
    debug: off
    definitions: uuid
    script:
        - define index:<server.flag[Duel_<[uuid]>_Turn]>
        - define name:<server.flag[Duel_<[uuid]>].get[<[index]>]>
        - determine <[name]>

DuelHeartbeat:
    type: task
    debug: off
    speed: instant
    definitions: uuid
    script:
        - narrate "--------------------" targets:<server.flag[Duel_<[uuid]>]> format:DuelFormat
        - narrate "<&4>----DUEL START-----" targets:<server.flag[Duel_<[uuid]>]> format:DuelFormat
        - narrate "--------------------" targets:<server.flag[Duel_<[uuid]>]> format:DuelFormat
        - flag server Duel_<[uuid]>_Over:false
        - flag server Duel_<[uuid]>_Turn:1

        # Ensure a player moves first
        - while <[user].is_npc>:
            - define user:<proc[GetNextPlayer].context[<[uuid]>]>
        - define user:<proc[GetCurrentPlayer].context[<[uuid]>]>

        # Start the game heartbeat
        - while !<server.flag[Duel_<[uuid]>_Over]>:

            # Handle the NPC Actions
            - while <[user].is_npc>:
                - narrate "It's <&b><[user].name><&8>'s turn! (HP:<[user].flag[Duel_Health]>)" targets:<server.flag[Duel_<[uuid]>]> format:DuelFormat
                - random:
                    - run DuelMove def:attack|<[user]>
                    - run DuelMove def:defend|<[user]>
                    - run DuelMove def:prepare|<[user]>
                - define user:<proc[GetNextPlayer].context[<[uuid]>]>
        
            - narrate "It's <&b><[user].name.display><&8>'s turn! (HP:<[user].flag[Duel_Health]>)" targets:<server.flag[Duel_<[uuid]>]> format:DuelFormat
            - title "title:<red>It's your turn!" "subtitle:<green>Health:<[user].flag[Duel_Health]>" targets:<[user]>
            - narrate "Remember to Emote before you choose your move!" format:DuelActionFormat targets:<[user]>
            - narrate "<&hover[Click to attack the opponent!]><&click[/d attack]><&a>Attack<&f><&end_click><&end_hover> | <&hover[Click to gain protection on your next turn!]><&click[/d defend]><&e>Defend<&f><&end_click><&end_hover> | <&hover[Click to store power for your next attack!]><&click[/d prepare]><&d>Prepare<&f><&end_click><&end_hover> | <&hover[Click to lose and end the fight.]><&click[/d forfeit]><&c>Forfeit<&f><&end_click><&end_hover>" target:<[user]> format:DuelActionFormat

            - flag server Duel_<[uuid]>_Waiting d:5m

            # Wait 5m for the person to make their move/emote
            - while <server.has_flag[Duel_<[uuid]>_Waiting]>:
                - wait 1s

            # Get the next player
            - flag <[user]> DuelMoved:!
            - define user:<proc[GetNextPlayer].context[<[uuid]>]>

            # Skip anyone who lost a turn or is passed out
            - while <[user].has_flag[Duel_Skip]> || <[user].has_flag[Duel_KO]>:
                - flag <[user]> Duel_Skip:!
                - define user:<proc[GetNextPlayer].context[<[uuid]>]>
        - run DuelEnd def:<[uuid]>

DuelEnd:
    type: task
    debug: off
    speed: instant
    definitions: uuid
    script:
        - note remove as:Duel_<[uuid]>
        - sidebar remove players:<server.flag[Duel_<[uuid]>].exclude[<[npcs]>]>
        - flag server Duel_<[uuid]>_Over:true
        - wait 1s
        - narrate "--------------------" targets:<server.flag[Duel_<[uuid]>]> format:DuelFormat
        - narrate "<&4>----DUEL OVER-----" targets:<server.flag[Duel_<[uuid]>]> format:DuelFormat
        - narrate "--------------------" targets:<server.flag[Duel_<[uuid]>]> format:DuelFormat
        - foreach <server.flag[Duel_<[uuid]>]> as:user:
            - foreach li@Duel_Invite|Duel|Duel_Target|Duel_Health|Duel_KO|DuelMoved|Duel_Protection as:theFlag:
                - if <[user].has_flag[<[theFlag]>]>:
                    - flag <[user]> <[theFlag]>:!
        - define npcs:<server.flag[Duel_<[uuid]>_Npcs]||li@>
        - flag server Duel_<[uuid]>:!
        - flag server Duel_<[uuid]>_Turn:!
        - flag server Duel_<[uuid]>_Waiting:!
        - flag server Duel_<[uuid]>_NPCs:!

# Should now be NPC Compatible
DuelAttack:
    type: task
    debug: off
    script:
        # NPC Random Target Select
        - if <[user].is_npc>:
            - define name:<[user].name>
            - define size:<server.flag[<[user].flag[Duel]>].size.sub_int[1]>
            - define index:<util.random.int[1].to[<[size]>]>
            - define uuid:<[user].flag[Duel]>
            # Choose from everyone but themselves
            - define noNpc:<server.flag[Duel_<[uuid]>].exclude[<[user]>]>
            - define target:<[noNPC].get[<[index]>]>
        - else:
            # Player View
            - define name:<[user].name.display>
            # Show the list of targets
            - define "message:Choose your target<&co> | "
            - foreach <server.flag[Duel_<[uuid]>]> as:target:
                - if <[target].is_npc>:
                    - define character:<[target].name>
                - else:
                    - define character:<[target].name.display>
                - define "message:<[message]><&hover[<[target].name>]><&click[/d target <[target]>]><&a><[character]><&f><&end_click><&end_hover> | "
            - narrate "<[message]>" target:<[user]> format:DuelFormat
            - while !<[user].has_flag[Duel_Target]> && <server.has_flag[Duel_<[uuid]>]>:
                - wait 1s
            - define target:<[user].flag[Duel_Target]>
        # Get the name of the target
        - if <[target].is_npc>:
            - define character:<[target].name>
        - else:
            - define character:<[target].name.display>

        - flag <[user]> Duel_Target:!
        
        # Rolling info
        - define result:<util.random.int[1].to[20]>
        # Deal the damage
        - define message:temp
        - random:
            - define "message:<&b><[name]><&f><&8> attacks <&c><[character]><&8>! They rolled a <&e><[result]><&f>!" 
            - define "message:<&b><[name]><&f><&8> goes to strike <&c><[character]><&8>! They rolled a <&e><[result]><&f>!" 
            - define "message:<&b><[name]><&f><&8> lashes out at <&c><[character]><&8>! They rolled a <&e><[result]><&f>!"
            - define "message:<&b><[name]><&f><&8> focuses and darts at <&c><[character]><&8>! They rolled a <&e><[result]><&f>!" 
                # If we get over a ten, we succeed.
        - if <[result]> >= 8:
            - if <[result]> < 12:
                - define damage:<util.random.int[1].to[3]>
            - if <[result]> >= 12 && <[result]> < 15:
                - define damage:<util.random.int[3].to[5]>
            - if <[result]> >= 15 && <[result]> <= 19:
                - define damage:<util.random.int[5].to[7]>
            - if <[result]> == 20:
                - define damage:<util.random.int[7].to[9]>
                
            # Check for preparation bonus
            - if <[user].has_flag[duel_power]> && <[user].flag[duel_power]> != 0:
                - define damage:+:<[user].flag[duel_power]>
                - define "message:<[message]> <[name]> unleashed some power!"
                - flag <[user]> duel_power:0
            # Check enemy protection
            - if <[target].has_flag[duel_protection]> && <[target].flag[duel_protection]> != 0:
                - define damage:-:<[target].flag[duel_protection]>
                - flag <[target]> Duel_Protection:!
            # If you do no damage, make the cool emote
            - if <[damage]> <= 0:
                # - define character:<proc[GetCharacterName].context[<[target]>]>
                - narrate "<[message]>" format:DuelFormat targets:<server.flag[Duel_<[uuid]>]>
                - narrate "Thanks to <[character]>'s steadfast guard, no damage was taken!" target:<server.flag[Duel_<[uuid]>]> format:DuelActionFormat
            # Deal the damage
            - else:
                - define "message:<[message]><&8> They dealt <[damage]> damage!"
                - narrate "<[message]>" format:DuelActionFormat target:<server.flag[Duel_<[uuid]>]>
                - flag <[target]> Duel_Health:-:<[damage]>
                - if <[target].flag[Duel_Health]> <= 0:
                    # - define character:<proc[GetCharacterName].context[<[target]>]>
                    - if <[target].is_npc>:
                        - define name:<[target].name>
                    - else:
                        - define name:<[target].name.display>
                    - narrate "<[name]><&8> has fainted!" format:DuelFormat target:<server.flag[Duel_<[uuid]>]>
                    - flag <[target]> Duel_KO
                    - define alive:<server.flag[Duel_<[uuid]>].size>
                    - define alivePlayer:temp
                    - foreach <server.flag[Duel_<[uuid]>]> as:faintCheck:
                        - if <[faintcheck].has_flag[Duel_KO]>:
                            - define alive:--
                        - else:
                            - define alivePlayer:<[faintCheck]>
                    - if <[alive]> == 1:
                        - if <[aliveplayer].is_npc>:
                            - define name:<[aliveplayer].name>
                        - else:
                            - define name:<[aliveplayer].name.display>
                        - narrate "<&e><[name]> <&a>is the victor!" target:<server.flag[Duel_<[uuid]>]>
                        - flag server Duel_<[uuid]>_over:true
        - else:
            - if <[result]> == 1:
                - narrate "They tripped on their own feet and have lost their next turn!" format:DuelActionFormat target:<server.flag[Duel_<[uuid]>]>
                - flag <[user]> Duel_Skip
            - else:
                - narrate "They missed!" format:DuelActionFormat target:<server.flag[Duel_<[uuid]>]>
        - flag server Duel_<[uuid]>_waiting:!

# Should now be NPC Compatible
DuelDefend:
    type: task
    debug: off
    script:
        - if <[user].is_npc>:
            - define name:<[user].name>
        - else:
            - define name:<[user].name.display>
        
        - define "message:<[name]><&8> goes to brace themselves!"
    
        - define result:<util.random.int[1].to[20]>
        
        - if <[result]> >= 8:
            - if <[result]> < 15:
                - define protection:<util.random.int[1].to[4]>
                - narrate "<[message]> They rolled a <[result]> and gained <[protection]> points of protection!" target:<server.flag[Duel_<[uuid]>]> format:DuelActionFormat
                - if <[user].has_flag[Duel_Protection]>:
                    - flag <[user]> Duel_Protection:+:<[protection]>
                    - if <[user].flag[Duel_Protection]> > 20:
                        - flag <[user]> Duel_Protection:20
                - else:
                    - flag <[user]> Duel_Protection:<[protection]>
            - else:
                - define protection:<util.random.int[4].to[8]>
                - narrate "<[message]> They rolled a <[result]> and gained <[protection]> points of protection!" target:<server.flag[Duel_<[uuid]>]> format:DuelActionFormat
                - if <[user].has_flag[Duel_Protection]>:
                    - flag <[user]> Duel_Protection:+:<[protection]>
                    - if <[user].flag[Duel_Protection]> > 20:
                        - flag <[user]> Duel_Protection:20
                - else:
                    - flag <[user]> Duel_Protection:<[protection]>
            - if <[result]> == 20:
                - narrate "<[message]> They rolled a <[result]>! They have a full defense!" target:<server.flag[Duel_<[uuid]>]> format:DuelActionFormat
                - define protection:20
            - flag <[user]> Duel_Protection:<[protection]>
        - else:
            - narrate "<[message]> But they were too slow!" format:DuelActionFormat target:<server.flag[Duel_<[uuid]>]>
        - flag server Duel_<[uuid]>_waiting:!

# Should now be NPC Compatible
DuelPrepare:
    type: task
    debug: off
    script:
        - if <[user].is_npc>:
            - define name:<[user].name>
        - else:
            - define name:<[user].name.display>
        - define "message:<[name]><&8> stores energy!"
        - define result:<util.random.int[<1>].to[20]>
        - if <[result]> >= 3:
            - if <[result]> < 15:
                - define bonus:<util.random.int[1].to[3]>
                - narrate "<[message]> They rolled a <[result]> and gained some power!" target:<server.flag[Duel_<[uuid]>]> format:DuelActionFormat
            - else:
                - if <[result]> == 20:
                    - narrate "<[message]> They rolled a <[result]> and gained a lot of power!" target:<server.flag[Duel_<[uuid]>]> format:DuelActionFormat
                    - define bonus:5
                - else:
                    - define bonus:<util.random.int[2].to[4]>
                    - narrate "<[message]> They rolled a <[result]> and gained a good bit of power!" target:<server.flag[Duel_<[uuid]>]> format:DuelActionFormat
            - if <[user].has_flag[Duel_Power]>:
                - flag <[user]> Duel_Power:+:<[bonus]>
            - else:
                - flag <[user]> Duel_Power:<[bonus]>
        - else:
            - narrate "<[message]> But they failed!" format:DuelActionFormat target:<server.flag[Duel_<[uuid]>]>
        - flag server Duel_<[uuid]>_waiting:!
