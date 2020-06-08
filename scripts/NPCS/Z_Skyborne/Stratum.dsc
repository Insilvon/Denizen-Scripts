StratumTinkerer:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
        on click:
            - define inv:StratumTinkererInventory
            - inject NewMerchantFlagSetup
    interact scripts:
    - 1 StratumTinkererInteract
StratumTinkererInteract:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello|Hi|Hey|Greetings/.
                    script:
                        - random:
                            - chat "I'm a merchant. Have a look at my wares."
                            - chat "I've come from Stratum to offer these gifts."
                            - chat "Hello there. Would you like to trade?"
                        - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&f>[Offer to trade some goods.]<&f><&end_click><&end_hover>"
                2:
                    trigger: /Regex:Yes/, that sounds good.
                    script:
                        - wait 1s
                        - define inv:StratumTinkererInventory
                        - inject NewMerchantFlagSetup