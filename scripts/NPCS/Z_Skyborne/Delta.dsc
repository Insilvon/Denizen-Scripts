DeltaDriver1:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set"
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
    interact scripts:
    - 1 DeltaDriverInteract1
DeltaDriverInteract1:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello|Hi|Hey/.
                    script:
                        - chat "Hi there. Would you like to head to Centrecrest? Only 64 coal or 192 charcoal!"
                        - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&a>[Yes]<&f><&end_click><&end_hover> | <&hover[Click Me!]><&click[No thanks.]><&c>[No]<&f><&end_click><&end_hover>"
                2:
                    trigger: /Regex:Yes/.
                    script:
                        - chat "Would you like to pay with Coal or charcoal?"
                        - narrate "<&hover[Click Me!]><&click[Coal.]><&a>[Coal]<&f><&end_click><&end_hover> | <&hover[Click Me!]><&click[Charcoal.]><&c>[Charcoal]<&f><&end_click><&end_hover>"
                3:
                    trigger: /Regex:Coal/.
                    script:
                        - if <player.inventory.contains[coal].quantity[64]>:
                            - take coal quantity:64
                            - chat "Alright - here we go!"
                            - teleport <player.location.find.players.within[6.6]> l@-5284.4863,101,-463.465,skyworld_v2
                        - else:
                            - chat "I charge for gas - you need 64 coal for this. Come back when you've got it."

                4:
                    trigger: /Regex:Charcoal/.
                    script:
                        - if <player.inventory.contains[charcoal].quantity[192]>:
                            - take charcoal quantity:192
                            - chat "Alright - here we go!"
                            - teleport <player.location.find.players.within[6.6]> l@-5284.4863,101,-463.465,skyworld_v2
                        - else:
                            - chat "I charge for gas - you need 192 charcoal for this. Come back when you've got it."
                5:
                    trigger: /Regex:No/.
                    script:
                        - chat "Hey no worries. Come again!"
DeltaDriver2:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set"
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
    interact scripts:
    - 1 DeltaDriverInteract2
DeltaDriverInteract2:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello|Hi|Hey/.
                    script:
                        - chat "Hi there. Would you like to head to the Crimson Sun? Only 64 coal or 192 charcoal!"
                        - if <player.has_flag[Pirate]>:
                            - chat "Or... As I can see you are of a respectable organization... eheh... would you like to head back to the Cove?"
                            - narrate "<&hover[Click Me!]><&click[Crimson Sun.]><&a>[Go to the Crimson Sun]<&f><&end_click><&end_hover> | <&hover[Click Me!]><&click[Miasmyyn Cove.]><&4>[Go to Miasmyyn Cove]<&f><&end_click><&end_hover> | <&hover[Click Me!]><&click[No thanks.]><&c>[No]<&f><&end_click><&end_hover>"
                        - else:
                            - narrate "<&hover[Click Me!]><&click[Crimson Sun.]><&a>[Go to the Crimson Sun]<&f><&end_click><&end_hover> | <&hover[Click Me!]><&click[No thanks.]><&c>[No]<&f><&end_click><&end_hover>"
                        
                2:
                    trigger: Yes, take me to the /Regex:Crimson Sun/.
                    script:
                        - chat "Would you like to pay with Coal or charcoal?"
                        - narrate "<&hover[Click Me!]><&click[Coal.]><&a>[Coal]<&f><&end_click><&end_hover> | <&hover[Click Me!]><&click[Charcoal.]><&c>[Charcoal]<&f><&end_click><&end_hover>"
                3:
                    trigger: /Regex:Coal/.
                    script:
                        - if <player.inventory.contains[coal].quantity[64]>:
                            - take coal quantity:64
                            - chat "Alright - here we go!"
                            - teleport <player.location.find.players.within[6.6]> l@-7847.4726,116,1879.7007,skyworld_v2
                        - else:
                            - chat "I charge for gas - you need 64 coal for this. Come back when you've got it."

                4:
                    trigger: /Regex:Charcoal/.
                    script:
                        - if <player.inventory.contains[charcoal].quantity[192]>:
                            - take charcoal quantity:192
                            - chat "Alright - here we go!"
                            - teleport <player.location.find.players.within[6.6]> l@-7847.4726,116,1879.7007,skyworld_v2
                        - else:
                            - chat "I charge for gas - you need 192 charcoal for this. Come back when you've got it."
                5:
                    trigger: /Regex:No/.
                    script:
                        - chat "Hey no worries. Come again!"
                6:
                    trigger: Take me to /Regex:Miasmyyn Cove/.
                    script:
                        - if <player.has_flag[Pirate]>:
                            - chat "Certainly certainly... off we go."
                            - teleport <player.location.find.players.within[4.4]> l@5687,153,5099,skyworld_v2
                        - else:
                            - chat "I'm afraid I just don't know where that is!"
            