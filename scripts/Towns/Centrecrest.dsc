# CentrecrestCitizen:
#     type: assignment
#     actions:
#         on assignment:
#             - narrate "Assignment set."
#         on click:
#             - inject CentrecrestRandomTalk
#     interact scripts:
#     - 1 CentrecrestCitizenInteract
# CentrecrestCitizenInteract:
#     type: interact
#     steps:
#         1:
#             proximity trigger:
#                 exit:
#                     script:
#                         - inject RandomWalk
#             chat trigger:
#                 1:
#                     trigger: /Regex:Hello/
#                     script:
#                         - inject CentrecrestRandomTalk
# CentrecrestRandomTalk:
#     type: task
#     script:
#         - random:
#             - chat "Hello there. Welcome to Centrecrest."
#             - chat "It's always nice to see a new face. I hope you stick around a while."
#             - chat "Hello <proc[GetCharacterDisplayName].context[<player>]>."
#             - chat "We're a peaceful community here. I hope you intend to keep it that way."
#= Dockworker
CentrecrestDockWorker:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set."
        on click:
            - flag player NPCInventory:CentrecrestDockworkerInventory
            - inventory open d:NewMerchantInventory
    interact scripts:
        - 1 CentrecrestDockWorkerInteract

CentrecrestDockWorkerInteract:
    type: interact
    steps:
        1:
            proximity trigger:
                exit:
                    script:
                        - inject Randomwalk
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - random:
                            - chat "Greetings there."
                            - chat "Just pleasant weather we're having here today, isn't it?"
                            - chat "Look at it. Take in that view. Nothing but clouds and distance from the world's problems, eh?"
                            - chat "Welcome. Lookin' for some fuel?"
                        - wait 1s
                        - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&f>Offer to trade some goods.<&f><&end_click><&end_hover>"
                2:
                    trigger: /Regex:Yes/, that sounds good.
                    script:
                        - chat "Fantastic! *The dockworker would go to investigate your supply.*"
                        - wait 1s
                        - flag player NPCInventory:CentrecrestDockworkerInventory
                        - inventory open d:NewMerchantInventory


#= Blacksmith
CentrecrestBlacksmith:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set."
        on click:
            - inject CentrecrestRandomTalk
    interact scripts:
    - 1 CentrecrestBlacksmithInteract
CentrecrestBlacksmithInteract:
    type: interact
    steps:
        1:
            proximity trigger:
                exit:
                    script:
                        - inject RandomWalk
                        - inject ClearRepairFlag
                        - zap 1
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - chat "Greetings there. I'm <npc.name>, at your service."
                        - wait 1s
                        - chat "How can I assist you today?"
                        - wait 1s
                        - narrate "<&hover[Click Me!]><&click[Can you repair this?]>Ask to repair your held item.<&end_click><&end_hover>"
                2:
                    trigger: Can you /repair/ this?
                    script:
                        - define item:<player.item_in_hand>
                        - if <[item].material.name> != air && <[item].durability> != 0:
                            - chat "So let's see, you've got this <[item].material.name> here..."
                            - wait 1s
                            - if <[item].script.name> == SkyborneParafoil:
                                - chat "A parafoil for sure. I believe I can repair this for some goods."
                                - wait 1s
                                - chat "I'll need 16 diamonds, 8 iron ingots, and 4 emeralds for now."
                                - wait 1s
                                - flag player <npc>_RepairItem:<[item]>
                                - flag player <npc>_RepairRequirements:i@Diamond
                                - flag player <npc>_RepairRequirements:->:i@Iron_Ingot
                                - flag player <npc>_RepairRequirements:->:i@Emerald
                                - flag player <npc>_RepairQuantities:16
                                - flag player <npc>_RepairQuantities:->:8
                                - flag player <npc>_RepairQuantities:->:4
                                - chat "Does this sound fair to you?"
                                - wait 1s
                                - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&a>Agree and trade the items.<&f><&end_click><&end_hover> | <&hover[Click Me!]><&click[No thanks.]><&c>Decline and leave.<&end_click><&end_hover>"
                                - zap 3
                            - else:
                                - if <[item].material.name.contains[iron]>:
                                    - chat "I can repair this for two iron ingots and an emerald."
                                    - wait 1s
                                    - chat "Does this sound good to you?"
                                    - flag player <npc>_RepairItem:<[item]>
                                    - flag player <npc>_RepairRequirements:i@iron_ingot
                                    - flag player <npc>_RepairRequirements:->:i@Emerald
                                    - flag player <npc>_RepairQuantities:2
                                    - flag player <npc>_RepairQuantities:->:1
                                    - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&a>Agree and trade the items.<&f><&end_click><&end_hover> | <&hover[Click Me!]><&click[No thanks.]><&c>Decline and leave.<&end_click><&end_hover>"
                                    - zap 3
                                    - stop
                                - if <[item].material.name.contains[bow]>:
                                    - chat "I can repair this for 16 dark oak logs and an emerald."
                                    - wait 1s
                                    - chat "Does this sound good to you?"
                                    - flag player <npc>_RepairItem:<[item]>
                                    - flag player <npc>_RepairRequirements:i@dark_oak_log
                                    - flag player <npc>_RepairRequirements:->:i@Emerald
                                    - flag player <npc>_RepairQuantities:16
                                    - flag player <npc>_RepairQuantities:->:1
                                    - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&a>Agree and trade the items.<&f><&end_click><&end_hover> | <&hover[Click Me!]><&click[No thanks.]><&c>Decline and leave.<&end_click><&end_hover>"
                                    - zap 3
                                    - stop
                                - chat "I'm not sure I can repair this yet. Come back later."
                                - chat "((If you think I should repair this, tell Sil!))"

# #= Woodcutter
CentrecrestWoodcutter:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment Set!"
        on click:
            - flag player NPCInventory:CentrecrestWoodcutterInventory
            - inventory open d:NewMerchantInventory
    interact scripts:
        - 1 CentrecrestWoodcutterInteract

CentrecrestWoodcutterInteract:
    type: interact
    steps:
        1:
            proximity trigger:
                exit:
                    script:
                        - inject RandomWalk
                        - zap 1
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - wait 1s
                        - random:
                            - chat "Greetings. Do yuh have wood for me?"
                            - chat "Hullo there. I'm a man partial to a good log. Got something for me?"
                            - chat "Nuffin better than choppin' sum wood. Do you want to trade?"
                            - chat "Oho! Do yuh have some logs on you?"
                        - wait 1s
                        - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&f>Offer to trade some goods.<&f><&end_click><&end_hover>"
                2:
                    trigger: /Regex:Yes/, that sounds good.
                    script:
                        - chat "Fantastic! *The woodcutter would go to investigate your supply.*"
                        - wait 1s
                        - flag player NPCInventory:CentrecrestWoodcutterInventory
                        - inventory open d:NewMerchantInventory


#=Farmer
CentrecrestFarmer:
    type: assignment
    actions:
        on click:
            - flag player NPCInventory:CentrecrestFarmerInventory
            - inventory open d:NewMerchantInventory
    interact scripts:
        - 1 CentrecrestFarmerInteract

CentrecrestFarmerInteract:
    type: interact
    steps:
        1:
            proximity trigger:
                exit:
                    script:
                        - inject RandomWalk
                        - zap 1
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - wait 1s
                        - chat "Hello! Do you have some farm goods for me?"
                        - wait 1s
                        - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&f>Offer to trade some goods.<&f><&end_click><&end_hover>"
                2:
                    trigger: /Regex:Yes/, that sounds good.
                    script:
                        - chat "Fantastic! *The farmer would go to investigate your supply.*"
                        - wait 1s
                        - flag player NPCInventory:CentrecrestFarmerInventory
                        - inventory open d:NewMerchantInventory


#=CentercrestBuilder
CentrecrestBuilder:
    type: assignment
    actions:
        on assignment:
            - narrate "assignment set."
    interact scripts:
        - 1 CentrecrestBuilderInteract

CentrecrestBuilderInteract:
    type: interact
    steps:
        1:
            proximity trigger:
                exit:
                    script:
                        - inject RandomWalk
                        - zap 1
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - chat "Hey there friend. Come back later, I'm busy right now."
#=Centrecrest Glass Merchant
#= Dockworker
CentrecrestGlassMerchant:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set."
        on click:
            - flag player NPCInventory:CentrecrestGlassMerchantInventory
            - inventory open d:NewMerchantInventory
    interact scripts:
        - 1 CentrecrestGlassMerchantInteract

CentrecrestGlassMerchantInteract:
    type: interact
    steps:
        1:
            proximity trigger:
                exit:
                    script:
                        - inject Randomwalk
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - random:
                            - chat "Greetings there."
                            - chat "Just pleasant weather we're having here today, isn't it?"
                            - chat "Look at it. Take in that view. Nothing but clouds and distance from the world's problems, eh?"
                            - chat "Welcome. Lookin' for some glass?"
                        - wait 1s
                        - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&f>Offer to trade some goods.<&f><&end_click><&end_hover>"
                2:
                    trigger: /Regex:Yes/, that sounds good.
                    script:
                        - chat "Fantastic! *The woodcutter would go to investigate your supply.*"
                        - wait 1s
                        - flag player NPCInventory:CentrecrestGlassMerchantInventory
                        - inventory open d:NewMerchantInventory

#= Miner
CentrecrestMiner:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment Set!"
        on click:
            - flag player NpcInventory:CentrecrestMinerInventory
            - inventory open d:NewMerchantInventory
    interact scripts:
        - 1 CentrecrestMinerInteract

CentrecrestMinerInteract:
    type: interact
    steps:
        1:
            proximity trigger:
                exit:
                    script:
                        - inject RandomWalk
                        - zap 1
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - wait 1s
                        - random:
                            - chat "Wha? Who?"
                            - chat "*Their head jerks up as they look at you*"
                            - chat "What yer doin? You got them gems?"
                        - wait 1s
                        - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&f>Offer to trade some goods.<&f><&end_click><&end_hover>"
                2:
                    trigger: /Regex:Yes/, that sounds good.
                    script:
                        - chat "Fantastic! *The Miner would go to investigate your supply.*"
                        - wait 1s
                        - flag player NpcInventory:CentrecrestMinerInventory
                        - inventory open d:NewMerchantInventory

