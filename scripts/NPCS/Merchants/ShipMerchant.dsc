ShipMerchant:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
    interact scripts:
    - 1 ShipMerchantI
ShipMerchantI:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Hello/.
                    script:
                        - chat "my ship is at <npc.flag[Ship]>."
                2:
                    trigger: /Buy/
                    script:
                        - modifyblock <npc.flag[Ship]> air
                3:
                    trigger: /Sell/
                    script:
                        - modifyblock <npc.flag[Ship]> obsidian