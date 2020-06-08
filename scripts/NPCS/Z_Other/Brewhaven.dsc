MobMerchant:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
        on click:
            - define inv:MobMerchantInventory
            - inject NewMerchantFlagSetup
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
    interact scripts:
    - 1 MobMerchantI
MobMerchantI:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello|Hey|Hi|Greetings/.
                    script:
                        - chat "Hello there... Are you in the game of catching animals?"
                        - wait 1s
                        - chat "May I perhaps interest someone as humble as you to look at my wares?"
                        - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&f>[Offer to trade some goods.]<&f><&end_click><&end_hover>"
                2:
                    trigger: /Regex:Yes/, that sounds good.
                    script:
                        - chat "Most excellent..."
                        - wait 1s
                        - define inv:MobMerchantInventory
                        - inject NewMerchantFlagSetup
GunMerchant:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
        on click:
            - define inv:GunMerchantInventory
            - inject NewMerchantFlagSetup
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
    interact scripts:
    - 1 GunMerchantI
GunMerchantI:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello|Hey|Hi|Greetings/.
                    script:
                        - wait 1s
                        - random:
                            - chat "Guns! Get your guns here!"
                            - chat "Need a little more boom in your life!?"
                            - chat "Flintlocks! Ammo! Powder! Come get it!"
                        - wait 1s
                        - chat "You looking for a little more firepower or are you here for my infamous gunpowder services?"
                        - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&a>[Offer to trade some goods.]<&f><&end_click><&end_hover> | <&click[Tell me about the gunpowder.]><&c>[Ask about Gunpowder services.]<&f><&end_click>"
                2:
                    trigger: /Regex:Yes/, that sounds good.
                    script:
                        - wait 1s
                        - chat "Most excellent..."
                        - wait 1s
                        - define inv:GunMerchantInventory
                        - inject NewMerchantFlagSetup
GunpowderMerchant:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
    interact scripts:
    - 1 GunpowderMerchantI
GunpowderMerchantI:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello|Hi|Hey|Greetings/.
                    script:
                        - wait 1s
                        - chat "Hey there. You looking to convert some raw material to gunpowder?"
                        - wait 2s
                        - chat "For every two stacks of gravel and stack of coal you bring me, I can give you a stack of good old-fashioned powder."
                        - wait 4s
                        - chat "Now what do you say? Want to buy some powder?"
                        - narrate "<&click[I want a stack.]><&c>[Buy a stack.]<&f><&end_click>"
                2:
                    trigger: I want a /stack/.
                    script:
                        - wait 1s
                        - if <player.inventory.contains[gravel].quantity[128]> && <player.inventory.contains[coal].quantity[64]>:
                            - take gravel quantity:128
                            - take coal quantity:64
                            - give gunpowder quantity:64
                            - chat "And there you go!"
                            - wait 1s
                            - narrate "<&click[I want a stack.]><&c>[Buy another stack.]<&f><&end_click>"
                        - else:
                            - chat "You don't have the materials for this! Now get on - get!"