Crest:
    type: item
    material: gold_nugget[flags=HIDE_ENCHANTS]
    display name: <&e>Crest
    lore:
        - A unit of currency
        - in the sky, representing
        - 1 Crest.
    enchantments:
        - INFINITY:1

Plume:
    type: item
    material: gold_ingot[flags=HIDE_ENCHANTS]
    display name: <&e>Plume
    lore:
        - A unit of currency
        - in the sky, representing
        - 10 crests.
    enchantments:
        - INFINITY:1

Sol:
    type: item
    material: gold_block[flags=HIDE_ENCHANTS]
    display name: <&e>Sol
    lore:
        - A unit of currency in
        - the sky, representing
        - 100 crests.
    enchantments:
        - INFINITY:1

SolCanceller:
    type: world
    events:
        on player places Sol:
            - determine cancelled

Money:
    type: command
    name: money
    desc: money
    usage: money
    script:
        - if !<player.has_flag[CharacterSheet_CurrentCharacter]>:
            - narrate "You need a character to do this."
            - stop
        - choose <context.args.get[1]||null>:
            - case withdraw:
                - define amount:<context.args.get[2]||0>
                - if <[amount]> > 0:
                    - if <player.money> >= <[amount]>:
                        - money take quantity:<[amount]>
                        
                        - define sols:<[amount].div_int[100]>
                        # - narrate "Number of Sols to take: <[sols]>"
                        - define amount:<[amount].sub_int[<[sols].mul_int[100]>]>
                        # - narrate "Amount left: <[amount]>"

                        - define plumes:<[amount].div_int[10]>
                        # - narrate "Number of plumes to take: <[plumes]>"
                        
                        - define amount:<[amount].sub_int[<[plumes].mul_int[10]>]>
                        # - narrate "Amount left: <[amount]>"

                        - define crests:<[amount]>
                        
                        - give Sol quantity:<[sols]>
                        - give Plume quantity:<[plumes]>
                        - give Crest quantity:<[crests]>
            - case deposit:
                - define item:<player.item_in_hand||air>
                - define amount:<player.item_in_hand.quantity>
                - define theScript:<[item].script.name>
                # - narrate "You're holding <[item]> with amount <[amount]> and script <[thescript]>."
                - choose <[theScript]>:
                    - case Crest:
                        - take Crest quantity:<[amount]> from:<player.inventory>
                        - money give quantity:<[amount]>
                    - case Plume:
                        - take Plume quantity:<[amount]> from:<player.inventory>
                        - money give quantity:<[amount].mul_int[10]>
                    - case Sol:
                        - take Sol quantity:<[amount]> from:<player.inventory>
                        - money give quantity:<[amount].mul_int[100]>
            - default:
                - narrate "You have <player.money> Crests."