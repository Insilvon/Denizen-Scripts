RequiemVoucher:
    type: item
    material: paper
    display name: Requiem
    lore:
    - Spawns a Requiem

RequiemTask:
    type: task
    script:
        - create player <&e>Requiem <player.location.cursor_on.add[0,1,0]> traits:Sentinel save:temp
        - adjust <entry[temp].created_npc> lookclose:TRUE
        - adjust <entry[temp].created_npc> set_assignment:RequiemAssignment
        - equip <entry[temp].created_npc> hand:diamond_sword
        - execute as_server "npc select <entry[temp].created_npc.id>"
        - execute as_server "sentinel guard <player.name>"
        - execute as_server "npc owner <player.name>"

RequiemAssignment:
    type: assignment
    actions:
        on assignment:
            - narrate "assignment set"
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
    interact scripts:
    - 1 RequiemInteract

RequiemInteract:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello|Hi|Hey|Greetings/
                    script:
                        - wait 1s
                        - chat "I don't understand why you feel the need to introduce yourself. I've been following you for a while."
                        - wait 1s
                        - narrate "<&hover[Click Me!]><&click[Tell me about yourself.]>Ask about their history.<&end_click><&end_hover> | <&hover[Click Me!]><&click[I think you should leave.]>Ask them to stop following you.<&end_click><&end_hover>"

                2:
                    trigger: Tell me about /Regex:yourself/.
                    script:
                        - if <player> == <npc.owner>:
                            - chat "You want to know about me?"
                            - wait 1s
                            - chat "There's not very much to tell. I wander, I trade, and occasionally I fight."
                            - wait 1s
                            - chat "What else is there to know?"
                        - else:
                            - wait 1s
                            - chat "I don't know who you think you are, but I don't speak to strangers."
                3:
                    trigger: I think its time for you to /Regex:(?i)leave|go|split/.
                    script:
                        - if <player> == <npc.owner>:
                            - chat "I see. You no longer desire my companionship."
                            - wait 1s
                            - chat "This is fine, there is much work to be done."
                            - wait 1s
                            - chat "Take care, <proc[GetCharacterName].context[<player>]>"
                            - remove <npc>
                        - else:
                            - wait 1s
                            - chat "I don't serve you, nor am I following you. Get out of my face."