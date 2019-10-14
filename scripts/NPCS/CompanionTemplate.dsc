CompanionVoucher:
    type: item
    material: paper
    display name: Companion
    lore:
    - Spawns a companion

CompanionTask:
    type: task
    script:
        - create player <proc[GetRandomName]> <player.location.cursor_on.add[0,1,0]> traits:Sentinel save:temp
        - adjust <entry[temp].created_npc> lookclose:TRUE
        - adjust <entry[temp].created_npc> set_assignment:CompanionAssignment
        - equip <entry[temp].created_npc> hand:diamond_sword
        - execute as_server "npc select <entry[temp].created_npc.id>"
        - execute as_server "sentinel guard <player.name>"

CompanionAssignment:
    type: assignment
    actions:
        on assignment:
            - narrate "assignment set"
    interact scripts:
    - 1 CompanionInteract

CompanionInteract:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - chat "Hello!"