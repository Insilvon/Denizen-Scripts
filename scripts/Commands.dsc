Invisibility:
    type: command
    name: invis
    desc: sh
    usage: /invis
    script:
        - if <player.has_flag[Invis]>:
            - cast invisibility remove <player>
            - narrate "You are now visible."
            - flag player Invis:!
        - else:
            - flag player Invis
            - cast invisibility d:120m hide_particles
            - narrate "You are now hidden"