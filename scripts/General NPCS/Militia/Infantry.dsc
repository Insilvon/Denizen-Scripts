InfantryVoucher:
    type: item
    material: paper
    display name: Infantry Voucher
    lore:
    - Summons some Infantry members
    - so support you for 15 minutes!
    - (Or until death.)

InfantryTask:
    type: task
    speed: instant
    script:
        - if !<player.has_flag[Follower]>:
            - flag <player> Follower:0
        - if <player.flag[Follower]> < 3:
            - take InfantryVoucher
            - create player[owner=<player>] <proc[GetRandomName]> <player.cursor_on.above> traits:Sentinel save:temp
            - adjust <entry[temp].created_npc> lookclose:TRUE
            - adjust <entry[temp].created_npc> set_assignment:MilitiaAssignment
            - equip <entry[temp].created_npc> hand:stone_sword
            - execute as_server "sentinel guard <player.name> --id <entry[temp].created_npc.id>"
            - execute as_server "sentinel addtarget MONSTERS --id <entry[temp].created_npc.id>"

            - define npcType:Militia
            - define url:<proc[GetTownNPCSkin].context[<[npcType]>]>
            - define counter:0
            - define success:false
            - while <[success].matches[false]> && <[counter].as_int> <= 10:
                - define counter:<[counter].add_int[1]>
                - define url:<proc[GetTownNPCSkin].context[<[npcType]>]>
                - inject SetNPCURLSkin

            - flag <player> Follower:++
            - flag <entry[temp].created_npc> Follower
            - wait 15m
            - flag <player> Follower:--
            - remove <entry[temp].created_npc>
        - else:
            - narrate "You have reached your maximum number of Followers."
            
        
InfantryAssignment:
    type: assignment
    actions:
        on assignment:
            - narrate "assignment set"
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
    interact scripts:
    - 1 InfantryInteract

InfantryInteract:
    type: interact
    steps:
        1:
            click trigger:
                script:
                    - if <npc.has_flag[Follow]>:
                        - random:
                            - execute as_server "sudo <player.name> c:Hold tight."
                            - execute as_server "sudo <player.name> c:Stay here."
                            - execute as_server "sudo <player.name> c:Wait here."
                        - flag npc Follow:!
                        - execute as_server "npc select <npc.id>"
                        - execute as_server "sentinel speed 0"
                        - random:
                            - chat "Okay <proc[GetCharacterName].context[<player>]>"
                            - chat "I'll wait here!"
                            - chat "Staying put."
                    - else:
                        - random:
                            - execute as_server "sudo <player.name> c:Come follow me."
                            - execute as_server "sudo <player.name> c:With me."
                            - execute as_server "sudo <player.name> c:Let's go."
                        - flag npc Follow
                        - execute as_server "npc select <npc.id>"
                        - execute as_server "sentinel speed 1.3"
                        - random:
                            - chat "I'm on you."
                            - chat "On it. Let's go."
                            - chat "Right behind you."

            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - chat "Hello!"