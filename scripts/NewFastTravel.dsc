FastTravelTest:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
    interact scripts:
    - 1 FastTravelTestI
FastTravelTestI:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello|Hi|Hey|Greetings/.
                    script:
                        - chat "Hi there! Can I take you somewhere?"
                        - wait 1s
                        - narrate "<&click[Yes]>[Yes]<&end_click> | <&click[No]>[No]<&end_click>"
                2:
                    trigger: /Yes/.
                    script:
                        - chat "Certainly. Would you like to pay in Charcoal, Coal, or Crests?"
                        - wait 1s
                        - narrate "<&click[Charcoal.]><&a>[Charcoal]<&f><&end_click> | <&click[Coal.]><&3>[Coal]<&f><&end_click> | <&click[Crests.]><&b>[Crests]<&f><&end_click> | <&click[Goodbye.]><&c>[Stay]<&f><&end_click>"
                4:
                    trigger: /Regex:Coal/.
                    script:
                        - if <player.inventory.contains[coal].quantity[32]>:
                            - flag player FastTravel:coal
                            - narrate "Where would you like to go?"
                            - wait 1s
                            - inventory open d:FastTravelInventory
                        - else:
                            - chat "I charge for gas - you need 32 coal for this. Come back when you've got it."
                5:
                    trigger: /Regex:Charcoal/.
                    script:
                        - if <player.inventory.contains[charcoal].quantity[96]>:
                            - flag player FastTravel:charcoal
                            - narrate "Where would you like to go?"
                            - wait 1s
                            - inventory open d:FastTravelInventory
                        - else:
                            - chat "I charge for gas - you need 96 charcoal for this. Come back when you've got it."
                6:
                    trigger: /Regex:Crests|Crest|crests|crest/.
                    script:
                        - if <player.money> >= 350:
                            - flag player FastTravel:crests
                            - narrate "Where would you like to go?"
                            - wait 1s
                            - inventory open d:FastTravelInventory
                        - else:
                            - chat "I charge for gas - you need 350 Crests for this. Come back when you've got it."
                7:
                    trigger: /Regex:No|Goodbye/.
                    script:
                        - chat "See you around."

FastTravelInventoryController:
    type: world
    debug: true
    events:
        on player clicks item in FastTravelInventory:
            - determine cancelled passively
            - define click:<context.click>
            - define item:<context.item.script.name||null>
            - choose <[item]>:
                - case MountainGladeFT:
                    - inject FastTravelPay
                    - narrate "Here we go!"
                    - teleport <player.location.find.players.within[4]> l@-5288,101,-477,skyworld_v2
                - case BrewhavenFT:
                    - inject FastTravelPay
                    - narrate "Here we go!"
                    - teleport <player.location.find.players.within[6.6]> l@-1159,154,-435,skyworld_v2
                - case CrimsonSunFT:
                    - inject FastTravelPay
                    - narrate "Here we go!"
                    - teleport <player.location.find.players.within[6.6]> l@-7853,116,1886,skyworld_v2
                - case EverlushFT:
                    - inject FastTravelPay
                    - narrate "Here we go!"
                    - teleport <player.location.find.players.within[4]> l@975,112,-2514,skyworld_v2
                - case MiasmyynFT:
                    - inject FastTravelPay
                    - narrate "Here we go!"
                    - teleport <player.location.find.players.within[4]> l@5690,153,5109,skyworld_v2
                - case LapidasFT:
                    - inject FastTravelPay
                    - narrate "Here we go!"
                    - teleport <player.location.find.players.within[4]> l@-2,71,-2564,skyworld_v2

FastTravelPay:
    type: task
    speed: instant
    script:
        - choose <player.flag[FastTravel]>:
            - case coal:
                - take coal quantity:32
            - case charcoal:
                - take charcoal quantity:96
            - case crests:
                - money take quantity:350
        - flag player FastTravel:!
FastTravelInventory:
    type: inventory
    inventory: chest
    size: 54
    title: <&3>Choose your destination!
    procedural items:
        - define list:<list[]>
        - if <player.has_flag[Skyborne]>:
            - define list:<[list].include[CrimsonSunFT]>
        - if <player.has_flag[Pirate]>:
            - define list:<[list].include[MiasmyynFT]>
        - if <player.has_flag[COTS]>:
            - define list:<[list].include[LapidasFT]>
        - determine <[list]>
    slots:
    - "[MountainGladeFT] [BrewhavenFT] [EverlushFT] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[i@emerald[display_name=Your Balance;lore=<player.money>]] [] [] [] [] [] [] [] []"

MountainGladeFT:
    type: item
    material: Orange_Stained_Glass
    display name: <&e>Mountainglade
    lore:
        - Mountainglade Isle,
        - home to the golden trees
        - and the town of Centrecrest.
BrewhavenFT:
    type: item
    material: Iron_Block
    display name: <&6>Brewhaven
    lore:
        - A neutral island in the sky.
        - Home to the Steel Dragon Tavern
        - and the Geezer Garage.
CrimsonSunFT:
    type: item
    material: Red_Wool
    display name: <&c>The Crimson Sun
    lore:
        - A Skyborne colony with
        - a rebellious history.
EverlushFT:
    type: item
    material: Grass_Block
    display name: <&a>Everlush Island
    lore:
        - A forested jungle, rich
        - with trees and grass. Home
        - to Genevah and Lapidas.
MiasmyynFT:
    type: item
    material: Skeleton_Skull
    display name: <&b>Miasmyyn Cove
    lore:
        - The Home of the Pirates.
LapidasFT:
    type: item
    material: Jungle_Log
    display name: <&a>Lapidas
    lore:
        - A Children of the Sun
        - colony, nestled in the jungles
        - of Everlush.
