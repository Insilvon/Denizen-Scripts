SentryVoucher:
    type: item
    material: paper
    display name: Sentry
    lore:
    - Spawns a Sentry

SentryTask:
    type: task
    script:
        - create player <proc[GetRandomName]> <player.location.cursor_on.add[0,1,0]> traits:Sentinel save:temp
        - adjust <entry[temp].created_npc> lookclose:TRUE
        - adjust <entry[temp].created_npc> set_assignment:SentryAssignment
        - equip <entry[temp].created_npc> hand:stone_sword
        - execute as_server "npc select <entry[temp].created_npc.id>"
        - execute as_server "sentinel guard <player.name>"
        - execute as_server "sentinel addtarget MONSTERS"

SentryAssignment:
    type: assignment
    actions:
        on assignment:
            - narrate "assignment set"
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
    interact scripts:
    - 1 SentryInteract

SentryInteract:
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
                        - execute as_server "sentinel speed 1"
                        - random:
                            - chat "I'm on you."
                            - chat "On it. Let's go."
                            - chat "Right behind you."

            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - chat "Hello!"