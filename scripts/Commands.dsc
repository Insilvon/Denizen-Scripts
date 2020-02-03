dEnchant:
    type: command
    name: dEnchant
    desc: sh
    usage: /dEnchant set/add Enchantment Level
    permission: aetheria.enchant
    script:
        - define choice:<context.args.get[1]||null>
        - define enchantment:<context.args.get[2]||null>
        - define level:<context.args.get[3]||null>
        - if <[enchantment]> == null || <[level]> == null || <[choice]> == null:
            - narrate "<&e>[Enchant]<&co><&f> You must specify an enchant and level!"
            - stop
        - if <[choice]> == set:
            - narrate "<&e>[Enchant]<&co><&f> Enchanting your held item with <[enchantment]> level <[level]>"
            - inventory adjust slot:<player.item_in_hand.slot> enchantments:<[enchantment]>,<[level]>
            - stop
        - if <[choice]> == add:
            - narrate "<&e>[Enchant]<&co><&f> Adding enchant of <[enchantment]> level <[level]>."
            - define enchants:<player.item_in_hand.enchantments.with_levels>
            - define enchants:->:<[enchantment]>,<[level]>
            - inventory adjust slot:<player.item_in_hand.slot> enchantments:<[enchants]>


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

SetCharacterLimit:
    type: command
    name: climit
    usage: /climit
    permission: aetheria.climit
    script:
        - narrate <context.args>
        - define target:<context.args.get[1]||null>
        - if <[target]> == null || <[target]> == help:
            - narrate "/climit <username> <newlimit>"
            - stop
        - define target:<server.match_offline_player[<[target]>]||null>
        - if <[target]> == null:
            - narrate "No matches found for that username. Are you sure it's right?"
            - stop
        - define newLimit:<context.args.get[2]||null>
        - if <[newLimit]> == null:
            - narrate "You must provide the new limit!"
            - stop
        - ~yaml "load:/CharacterSheets/<[target].uuid>/base.yml" id:<[target]>
        - yaml id:<[target]> set permissions.character_limit:<[newLimit]>
        - ~yaml "savefile:/CharacterSheets/<[target].uuid>/base.yml" id:<[target]>
        - yaml unload id:<[target]>
        - narrate "Character limit successfully set."

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