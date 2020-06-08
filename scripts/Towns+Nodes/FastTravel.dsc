FastTravelGuy3:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
    interact scripts:
    - 1 FastTravelGuyI3
FastTravelGuyI3:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello|Hi|Hey|Greetings/.
                    script:
                        - chat "Hi there! Can I take you to the Crimson Sun or Brewhaven?"
                        - wait 1s
                        - narrate "<&click[Take me to the Crimson Sun.]><&a>[Travel to Crimson Sun]<&f><&end_click> | <&click[Take me to Brewhaven.]><&a>[Travel to Brewhaven.]<&f><&end_click> |  <&click[Goodbye.]><&c>[Stay]<&f><&end_click>"
                2:
                    trigger: Take me to /Brewhaven/.
                    script:
                        - flag player Travel:Brewhaven d:5m
                        - chat "Certainly. Would you like to pay in Charcoal or Coal?"
                        - wait 1s
                        - narrate "<&click[Charcoal.]><&a>[Charcoal]<&f><&end_click> | <&click[Coal.]><&3>[Coal]<&f><&end_click> | <&click[Goodbye.]><&c>[Stay]<&f><&end_click>"
                3:
                    trigger: Take me to the /Crimson Sun/.
                    script:
                        - flag player Travel:CrimsonSun d:5m
                        - chat "Certainly. Would you like to pay in Charcoal or Coal?"
                        - wait 1s
                        - narrate "<&click[Charcoal.]><&a>[Charcoal]<&f><&end_click> | <&click[Coal.]><&3>[Coal]<&f><&end_click> | <&click[Goodbye.]><&c>[Stay]<&f><&end_click>"
                4:
                    trigger: /Regex:Coal/.
                    script:
                        - if <player.inventory.contains[coal].quantity[32]>:
                            - choose <player.flag[Travel]>:
                                - case CrimsonSun:
                                    - take coal quantity:32
                                    - chat "Alright - here we go!"
                                    - wait 1s
                                    - teleport <player.location.find.players.within[6.6]> l@-7853,116,1886,skyworld_v2
                                - case Brewhaven:
                                    - take coal quantity:32
                                    - chat "Alright - here we go!"
                                    - wait 1s
                                    - teleport <player.location.find.players.within[6.6]> l@-1159,154,-435,skyworld_v2
                        - else:
                            - chat "I charge for gas - you need 32 coal for this. Come back when you've got it."
                5:
                    trigger: /Regex:Charcoal/.
                    script:
                        - if <player.inventory.contains[charcoal].quantity[96]>:
                            - choose <player.flag[Travel]>:
                                - case CrimsonSun:
                                    - take charcoal quantity:96
                                    - chat "Alright - here we go!"
                                    - wait 1s
                                    - teleport <player.location.find.players.within[6.6]> l@-7853,116,1886,skyworld_v2
                                - case Brewhaven:
                                    - take charcoal quantity:96
                                    - chat "Alright - here we go!"
                                    - wait 1s
                                    - teleport <player.location.find.players.within[6.6]> l@-1159,154,-435,skyworld_v2
                        - else:
                            - chat "I charge for gas - you need 96 charcoal for this. Come back when you've got it."
                6:
                    trigger: /Regex:Goodbye/.
                    script:
                        - chat "See you around."

FastTravelGuy:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
    interact scripts:
    - 1 FastTravelGuyI
FastTravelGuyI:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello|Hi|Hey|Greetings/.
                    script:
                        - chat "Hi there! Can I take you to Brewhaven?"
                        - wait 1s
                        - narrate "<&click[Take me to Brewhaven.]><&a>[Travel to Brewhaven]<&f><&end_click> | <&click[Goodbye.]><&c>[Stay]<&f><&end_click>"
                2:
                    trigger: Take me to /Brewhaven/.
                    script:
                        - chat "Certainly. Would you like to pay in Charcoal or Coal?"
                        - wait 1s
                        - narrate "<&click[Charcoal.]><&a>[Charcoal]<&f><&end_click> | <&click[Coal.]><&3>[Coal]<&f><&end_click> | <&click[Goodbye.]><&c>[Stay]<&f><&end_click>"
                3:
                    trigger: /Regex:Coal/.
                    script:
                        - if <player.inventory.contains[coal].quantity[32]>:
                            - take coal quantity:32
                            - chat "Alright - here we go!"
                            - wait 1s
                            - teleport <player.location.find.players.within[6.6]> l@-1159,154,-435,skyworld_v2
                        - else:
                            - chat "I charge for gas - you need 32 coal for this. Come back when you've got it."
                4:
                    trigger: /Regex:Charcoal/.
                    script:
                        - if <player.inventory.contains[charcoal].quantity[96]>:
                            - take charcoal quantity:96
                            - chat "Alright - here we go!"
                            - wait 1s
                            - teleport <player.location.find.players.within[6.6]> l@-1159,154,-435,skyworld_v2
                        - else:
                            - chat "I charge for gas - you need 96 charcoal for this. Come back when you've got it."
                5:
                    trigger: /Regex:Goodbye/.
                    script:
                        - chat "See you around."

FastTravelGuy2:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
    interact scripts:
    - 1 FastTravelGuyI2
FastTravelGuyI2:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello|Hi|Hey|Greetings/.
                    script:
                        - chat "Hi there! Can I take you to Centrecrest or Brewhaven?"
                        - wait 1s
                        - narrate "<&click[Take me to Brewhaven.]><&a>[Travel to Brewhaven]<&f><&end_click> | <&click[Travel to Centrecrest.]><&a>[Travel to Centrecrest.]<&f><&end_click> |  <&click[Goodbye.]><&c>[Stay]<&f><&end_click>"
                2:
                    trigger: Take me to /Brewhaven/.
                    script:
                        - flag player Travel:Brewhaven d:5m
                        - chat "Certainly. Would you like to pay in Charcoal or Coal?"
                        - wait 1s
                        - narrate "<&click[Charcoal.]><&a>[Charcoal]<&f><&end_click> | <&click[Coal.]><&3>[Coal]<&f><&end_click> | <&click[Goodbye.]><&c>[Stay]<&f><&end_click>"
                3:
                    trigger: Take me to /Centrecrest/.
                    script:
                        - flag player Travel:Centrecrest d:5m
                        - chat "Certainly. Would you like to pay in Charcoal or Coal?"
                        - wait 1s
                        - narrate "<&click[Charcoal.]><&a>[Charcoal]<&f><&end_click> | <&click[Coal.]><&3>[Coal]<&f><&end_click> | <&click[Goodbye.]><&c>[Stay]<&f><&end_click>"
                4:
                    trigger: /Regex:Coal/.
                    script:
                        - if <player.inventory.contains[coal].quantity[32]>:
                            - choose <player.flag[Travel]>:
                                - case Centrecrest:
                                    - take coal quantity:32
                                    - chat "Alright - here we go!"
                                    - wait 1s
                                    - teleport <player.location.find.players.within[6.6]> l@-5288,101,-477,skyworld_v2
                                - case Brewhaven:
                                    - take coal quantity:32
                                    - chat "Alright - here we go!"
                                    - wait 1s
                                    - teleport <player.location.find.players.within[6.6]> l@-1159,154,-435,skyworld_v2
                        - else:
                            - chat "I charge for gas - you need 32 coal for this. Come back when you've got it."
                5:
                    trigger: /Regex:Charcoal/.
                    script:
                        - if <player.inventory.contains[charcoal].quantity[96]>:
                            - choose <player.flag[Travel]>:
                                - case Centrecrest:
                                    - take charcoal quantity:96
                                    - chat "Alright - here we go!"
                                    - wait 1s
                                    - teleport <player.location.find.players.within[6.6]> l@-5288,101,-477,skyworld_v2
                                - case Brewhaven:
                                    - take charcoal quantity:96
                                    - chat "Alright - here we go!"
                                    - wait 1s
                                    - teleport <player.location.find.players.within[6.6]> l@-1159,154,-435,skyworld_v2
                        - else:
                            - chat "I charge for gas - you need 96 charcoal for this. Come back when you've got it."
                6:
                    trigger: /Regex:Goodbye/.
                    script:
                        - chat "See you around."

FastTravelGuy1:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
    interact scripts:
    - 1 FastTravelGuyI1
FastTravelGuyI1:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello|Hi|Hey|Greetings/.
                    script:
                        - chat "Hi there!"
                        # - if <player.has_flag[COTS]>:
                        - chat "Can I take you to Lapidas?"
                        - wait 1s
                        - narrate "<&click[Take me to Lapidas.]><&a>[Travel to Lapidas]<&f><&end_click> | <&click[Goodbye.]><&c>[Stay]<&f><&end_click>"
                        - wait 1s
                        # - if <player.has_flag[Skyborne]>:
                        - chat "Can I take you to Centrecrest? Or would you prefer the Crimson Sun?"
                        - wait 1s
                        - narrate "<&click[Take me to Centrecrest.]><&a>[Take me to Centrecrest.]<&f><&end_click> | <&3><&click[Take me to the Crimson Sun.]>[Travel to the Crimson Sun]<&end_click><&f> | <&click[Goodbye.]><&c>[Stay]<&f><&end_click>"
                        - wait 1s
                        - if <player.has_flag[Pirate]>:
                            - chat "Or... since I see you have a recognizable face... "
                            - wait 1s
                            - narrate "<&click[Take me to Miasmyyn Cove.]><&a>[Travel to Miasmyyn Cove]<&f><&end_click> | <&click[Goodbye.]><&c>[Stay]<&f><&end_click>"
                2:
                    trigger: Take me to /Lapidas/.
                    script:
                        - chat "Would you like to pay in charcoal or coal?"
                        - flag player Travel:Lapidas d:5m
                        - wait 1s
                        - narrate "<&click[Coal]><&c>[Coal]<&f><&end_click> | <&click[Charcoal]><&3>[Charcoal]<&f><&end_click>"
                3:
                    trigger: Take me to /Centrecrest/.
                    script:
                        - chat "Would you like to pay in charcoal or coal?"
                        - flag player Travel:Centrecrest d:5m
                        - wait 1s
                        - narrate "<&click[Coal]><&c>[Coal]<&f><&end_click> | <&click[Charcoal]><&3>[Charcoal]<&f><&end_click>"
                4:
                    trigger: Take me to the /Crimson Sun/.
                    script:
                        - chat "Would you like to pay in charcoal or coal?"
                        - flag player Travel:CrimsonSun d:5m
                        - wait 1s
                        - narrate "<&click[Coal]><&c>[Coal]<&f><&end_click> | <&click[Charcoal]><&3>[Charcoal]<&f><&end_click>"
                5:
                    trigger: Take me to Miasmyyn /Cove/.
                    script:
                        - chat "Would you like to pay in charcoal or coal?"
                        - flag player Travel:MiasmyynCove d:5m
                        - wait 1s
                        - narrate "<&click[Coal]><&c>[Coal]<&f><&end_click> | <&click[Charcoal]><&3>[Charcoal]<&f><&end_click>"
                6:
                    trigger: /Regex:Coal/.
                    script:
                        - if <player.inventory.contains[coal].quantity[32]>:
                            - choose <player.flag[Travel]||null>:
                                - case Lapidas:
                                    # - if <player.has_flag[COTS]>:
                                    - take coal quantity:32
                                    - chat "Here we go!"
                                    - wait 1s
                                    - teleport <player.location.find.players.within[4]> l@-2,71,-2564,skyworld_v2
                                - case Centrecrest:
                                    # - if <player.has_flag[Skyborne]>:
                                    - take coal quantity:32
                                    - chat "Here we go!"
                                    - wait 1s
                                    - teleport <player.location.find.players.within[4]> l@-5288,101,-477,skyworld_v2
                                - case CrimsonSun:
                                    # - if <player.has_flag[Skyborne]>:
                                    - take coal quantity:32
                                    - chat "Here we go!"
                                        - wait 1s
                                    - teleport <player.location.find.players.within[4]> l@-7853,116,1886,skyworld_v2
                                - case MiasmyynCove:
                                    - if <player.has_flag[Pirate]>:
                                        - take coal quantity:32
                                        - chat "Here we go!"
                                        - wait 1s
                                        - teleport <player.location.find.players.within[4]> l@5690,153,5109,skyworld_v2
                        - else:
                            - chat "I charge for gas - you need 32 coal for this. Come back when you've got it."
                7:
                    trigger: /Regex:Charcoal/.
                    script:
                        - if <player.inventory.contains[charcoal].quantity[96]>:
                            - choose <player.flag[Travel]||null>:
                                - case Lapidas:
                                    # - if <player.has_flag[COTS]>:
                                    - take charcoal quantity:96
                                    - chat "Here we go!"
                                    - wait 1s
                                    - teleport <player.location.find.players.within[4]> l@-2,71,-2564,skyworld_v2
                                - case Centrecrest:
                                    # - if <player.has_flag[Skyborne]>:
                                    - take charcoal quantity:96
                                    - chat "Here we go!"
                                    - wait 1s
                                    - teleport <player.location.find.players.within[4]> l@-5288,101,-477,skyworld_v2
                                - case CrimsonSun:
                                    # - if <player.has_flag[Skyborne]>:
                                    - take charcoal quantity:96
                                    - chat "Here we go!"
                                        - wait 1s
                                    - teleport <player.location.find.players.within[4]> l@-7853,116,1886,skyworld_v2
                                - case MiasmyynCove:
                                    - if <player.has_flag[Pirate]>:
                                        - take charcoal quantity:96
                                        - chat "Here we go!"
                                        - wait 1s
                                        - teleport <player.location.find.players.within[4]> l@5690,153,5109,skyworld_v2
                        - else:
                            - chat "I charge for gas - you need 96 charcoal for this. Come back when you've got it."
                8:
                    trigger: /Regex:Goodbye/.
                    script:
                        - chat "See you around."
                