# Assemble (Party System) Proof of Concept
# Made and designed for AETHERIA
# @author Insilvon
# @version 1.5.1
# Allows players to form groups and participate in Quests together
# Functions: Party creation, invitation, listing members, leaving, disbanding, and handling disconnects. (2m wait before removing character from party.)
# Last Change: Implemented a sample proof of concept solo/party quest
AvengersAssemble:
    type: world
    events:
        # When the player leaves, start the countdown
        on player quits:
            - inject AssembleOnPlayerQuits
        on player logs in:
            - inject AssembleOnPlayerLogsIn
        # they didn't reconnect fast enough
        on flag expires:
            - inject AssembleOnFlagExpires
Assemble:
    type: command
    name: assemble
    description: Allows players to form groups and bands for quests.
    usage: /assemble create|invite|accept|decline
    tab complete:
        - determine <server.list_online_players.parse[name]>
    script:
        - define rawArgs:<context.args>
        # Handle Two Arguments (/assemble invite player)
        - if <[rawArgs].size> == 2:
            - define firstArg:<[rawArgs].get[1]>
            - if <[firstArg]> == invite:
                - inject AssembleInvite
        # Handle One Arguments (/assemble thing)
        - if <[rawArgs].size> == 1:
            - define firstArg:<[rawArgs].get[1]>
            # assemble accept
            - if <[firstArg]> == accept:
                - inject AssembleAccept
            # assemble decline
            - if <[firstArg]> == decline:
                - inject AssembleDecline
            # assemble create
            - if <[firstArg]> == create:
                - inject AssembleCreate
            # assemble leave
            - if <[firstArg]> == leave:
                - inject AssembleLeave
            # assemble disband
            - if <[firstArg]> == disband:
                - inject AssembleDisbandHelper
            # assemble list
            - if <[firstArg]> == list:
                - inject AssembleList

#=====================================================================#
#============================Helper Scripts===========================#
#=====================================================================#

AssembleCreate:
    type: task
    script:
        - if <player.has_flag[assemble]>:
            - narrate "<&c>[Assemble] - You are already a part of a group! Use /assemble leave before creating a new group."
        - else:
            - flag player assemble:<player.name>
            - flag server <player.name>_assembleGroup:<player.name>
            - narrate "<&c>[Assemble] - You have created a new group! Invite others with /assemble invite <&lt>player name<&gt>"
AssembleInvite:
    type: task
    script:
        - if !<player.has_flag[assemble]>:
            - narrate "<&c>[Assemble] - You are currently not a part of a group."
            - narrate "<&c>[Assemble] - Create one with /assemble create"
        - else:
            - if <player.flag[assemble]> != <player.name>:
                - narrate "<&c>[Assemble] - You cannot invite players to another person<&sq>s group!"
            - else:
                - define targetName:<server.match_player[<[rawArgs].get[2]>]||null>
                - if <[targetName]> == null:
                    - narrate "<&c>[Assemble] - That player is not online!"
                - else:
                    - narrate "<&c>[Assemble] - An invitation to <&a><[targetName].name><&c> has been sent. They have 5 minutes to accept."
                    - narrate "<&c>[Assemble] - You have received a group invite from <&a><player.name><&c>. Use <&a>/assemble accept <&c> or <&4>/assemble decline<&c>." targets:<[targetName]>
                    - flag server <[targetName].name>_assembleInvite:<player.name> duration:5m
AssembleLeave:
    type: task
    script:
        - if <player.has_flag[assemble]>:
            - if <player.flag[assemble]> == <player.name>:
                - narrate "<&c>[Assemble] - If you leave your own group, you will disband it! Are you sure? Confirm with <&4>/assemble disband"
            - else:
                - define host:<player.flag[assemble]>
                - define group:<[host]>_assembleGroup
                - define list:<server.flag[<[group]>].as_list>
                - narrate "<&c>[Assemble] - You have left your group."
                - narrate "<&c>[Assemble] - <&a><player.name><&c> has left your group." targets:<server.match_player[<[host]>]||null>
                - flag player assemble:!
                - flag server <[host]>_assembleGroup:<[list].exclude[<player.name>].unseparated>
        - else:
            - narrate "<&c>[Assemble] - You are not a member of any party."
AssembleAccept:
    type: task
    script:
        - if !<server.has_flag[<player.name>_assembleInvite]>:
            - narrate "<&c>[Assemble] - You have no pending invitations!"
        - else:
            - define host:<server.flag[<player.name>_assembleInvite]>
            - narrate "<&c>[Assemble] - You have accepted <&a><[host]><&c><&sq>s invitation!"
            - narrate "<&c>[Assemble] - <&a><player.name><&c> has accepted your invitation." targets:<server.match_player[<[host]>]||null>
            - flag player assemble:<[host]>
            - flag server <[host]>_assembleGroup:->:<player.name>
AssembleDecline:
    type: task
    script:
        - if !<server.has_flag[<player.name>_assembleInvite]>:
            - narrate "<&c>[Assemble] - You have no pending invitations!"
        - else:
            - define host:<server.flag[<player.name>_assembleInvite]>
            - narrate "<&c>[Assemble] - You have declined <&a><[host]><&c><&sq>s invitation."
            - narrate "<&c>[Assemble] - <&a><player.name><&c> has declined your invitation." targets:<server.match_player[<[host]>]||null>
            - flag server <player.name>_assembleInvite:!
AssembleDisbandHelper:
    type: task
    script:
        - if !<player.has_flag[assemble]>:
            - narrate "<&c>[Assemble] - You are not in a group!"
            - stop
        - if <player.flag[assemble]> != <player.name>:
            - narrate "<&c>[Assemble] - You cannot disband someone else<&sq>s group!"
            - stop
        - if <player.flag[assemble]> == <player.name>:
            - narrate "<&c>[Assemble] - You have disbanded your group."
            - inject AssembleDisband
AssembleDisband:
    type: task
    script:
        - define host:<player.flag[assemble]>
        - define group:<[host]>_assembleGroup
        - foreach <server.flag[<[group]>].as_list> as:character:
            - flag <server.match_player[<[character]>]> assemble:!
        - flag server <[host]>_assembleGroup:!
AssembleList:
    type: task
    script:
        - if !<player.has_flag[assemble]>:
            - narrate "<&c>[Assemble] - You are not in a group!"
        - else:
            - narrate "<server.flag[<player.flag[assemble]>_assembleGroup].separated_by[ ]>"

#=====================================================================#
#============================World Scripts============================#
#=====================================================================#

AssembleOnPlayerQuits:
    type: task
    script:
        - if <player.has_flag[assemble]>:
            - flag server <player.name>_assembleTimeout duration:2m
AssembleOnPlayerLogsIn:
    type: task
    script:
        # If we have a countdown for that player's party, then cancel it and do nothing
        - if <server.has_flag[<player.name>_assembleTimeout]>:
            - flag server <player.name>_assembleTimeout:!
AssembleOnFlagExpires:
    type: task
    script:
        - if <context.name.contains_text[_assembleTimeout]>:
            - define player:<context.name.exclude[_assembleTimeout]>
            - define host <[player].flag[assemble]>
            # If the original party is still active, remove this player from it
            - if !<server.has_flag[<[host]>_assembleGroup]>:
                - flag player assemble:!
                - stop
            # Are they the leader of the original party? If so, disband
            - if <[host]> == <player.name>:
                - inject AssembleDisband
            # If not, just remove them from the party
            - else:
                - flag server <[host]>_assembleGroup:<server.flag[<[host_assembleGroup]>].as_list.exclude[<player.name>]>

#=====================================================================#
#============================Sample Quests============================#
#=====================================================================#


AssembleAssignment:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set"
    interact scripts:
    - 1 AssembleInteract

AssembleInteract:
    type: interact
    steps:
        1:
          chat trigger:
            1:
                trigger: /Hello/
                script:
                    - chat "Want to do this solo or as a party"
            2:
                trigger: /solo/
                script:
                    - chat "Alright! YEET"
                    - flag player AssembleTestQuest
            3:
                trigger: /party/
                script:
                    - if <player.has_flag[assemble]> && <player.flag[assemble]> == <player.name>:
                        - chat "Begin! Say <&dq>done<&dq> to complete"
                        - flag server <player.name>_assembleQuestID:AssembleTestQuest
                        - flag player AssembleTestQuest
                    - else:
                        - chat "You don't have a group though! Come back when you have one."
            4:
                trigger: /done/
                script:
                    # If you're on this stage
                    - if <player.has_flag[AssembleTestQuest]>:
                        # If you're in a group
                        - if <player.has_flag[assemble]> && <player.flag[assemble]> == <player.name>:
                            - chat "Group complete!"
                            - define host:<player.flag[assemble]>
                            - define group:<[host]>_assembleGroup
                            - foreach <server.flag[<[group]>].as_list> as:character:
                                - give diamond to:<server.match_player[<[character]>].inventory>
                            - flag server <player.name>_assembleQuestID:!
                        # If you're on your own
                        - else:
                            - chat "Solo completed!"
                            - give diamond
                        - flag player AssembleTestQuest:!
