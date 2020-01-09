Invisibility:
    type: command
    name: invis
    desc: sh
    usage: /invis
    permission: aetheria.invis
    script:
        - if <player.has_flag[Invis]>:
            - cast invisibility remove <player>
            - narrate "You are now visible."
            - flag player Invis:!
        - else:
            - flag player Invis
            - cast invisibility d:120m hide_particles
            - narrate "You are now hidden"

RescueRing:
    type: command
    name: rescuering
    description: null
    usage: /rescuering
    permission: Aetheria.rescuering
    script:
        - if <player.has_flag[Below]>:
            - narrate "<&c>[RescueRing]:<&f> *The sky has heard your request. A line is being deployed shortly.*"
            - wait 15s
            - narrate "<&c>[RescueRing]:<&f> *The line appears! Going up!*"
            - wait 2s
            - teleport <player> l@-7810,116,1840,skyworld_v2