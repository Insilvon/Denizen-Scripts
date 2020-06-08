# GenevahCitizen:
#     type: assignment
#     actions:
#         on assignment:
#             - narrate "Assignment set."
#         on click:
#             - inject GenevahRandomTalk
#     interact scripts:
#     - 1 GenevahCitizenInteract
# GenevahCitizenInteract:
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
#                         - inject GenevahRandomTalk
# GenevahRandomTalk:
#     type: task
#     script:
#         - random:
#             - chat "Hello there. Welcome to Genevah."
#             - chat "It's always nice to see a new face. I hope you stick around a while."
#             - chat "Hello <proc[GetCharacterDisplayName].context[<player>]>."
#             - chat "We're a peaceful community here. I hope you intend to keep it that way."
#= Misc Seller
GenevahTownMisc:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set."
        on click:
            - define inv:GenevahMiscMerchantInventory
            - inject NewMerchantFlagSetup
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
    interact scripts:
        - 1 GenevahMiscMerchantInteract

GenevahMiscMerchantInteract:
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
                        - chat "*Coughs* *Hacks* *Vomits in his mouth a little.*"
                        - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&f>[Offer to trade some goods.]<&f><&end_click><&end_hover>"
                2:
                    trigger: /Regex:Yes/, that sounds good.
                    script:
                        - chat "*BURP*"
                        - wait 1s
                        - define inv:GenevahMiscMerchantInventory
                        - inject NewMerchantFlagSetup


#= Manager/Worker seller
GenevahTownSeller:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set."
        on click:
            - define inv:GenevahTownSellerInventory
            - inject NewMerchantFlagSetup
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
    interact scripts:
        - 1 GenevahTownSellerInteract

GenevahTownSellerInteract:
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
                        - chat "Hail! Do you need some hired hands to help get your Town a-growing?"
                        - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&f>[Offer to trade some goods.]<&f><&end_click><&end_hover>"
                2:
                    trigger: /Regex:Yes/, that sounds good.
                    script:
                        - chat "Fantastic! *The manager would go to investigate your supply.*"
                        - wait 1s
                        - define inv:GenevahTownSellerInventory
                        - inject NewMerchantFlagSetup


#= Brewer
GenevahBrewer:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set."
        on click:
            - define inv:GenevahBrewerInventory
            - inject NewMerchantFlagSetup
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
    interact scripts:
        - 1 GenevahBrewerInteract

GenevahBrewerInteract:
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
                            - chat "AH!"
                            - chat "Ho! You look like a drinker! Come come!"
                            - chat "*Burp*"
                        - wait 1s
                        - chat "You want to buy some brewing goods? *burp*"
                        - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&f>[Offer to trade some goods.]<&f><&end_click><&end_hover>"
                2:
                    trigger: /Regex:Yes/, that sounds good.
                    script:
                        - chat "Fantastic! *The brewer would go to investigate your supply.*"
                        - wait 1s
                        - define inv:GenevahBrewerInventory
                        - inject NewMerchantFlagSetup



#= Dockworker
GenevahDockWorker:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set."
        on click:
            - define inv:GenevahDockworkerInventory
            - inject NewMerchantFlagSetup
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
    interact scripts:
        - 1 GenevahDockWorkerInteract

GenevahDockWorkerInteract:
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
                        - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&f>[Offer to trade some goods.]<&f><&end_click><&end_hover>"
                2:
                    trigger: /Regex:Yes/, that sounds good.
                    script:
                        - chat "Fantastic! *The dockworker would go to investigate your supply.*"
                        - wait 1s
                        - define inv:GenevahDockworkerInventory
                        - inject NewMerchantFlagSetup


#= Blacksmith
GenevahBlacksmith:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set."
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
        on click:
            - inject GenevahRandomTalk
    interact scripts:
    - 1 GenevahBlacksmithInteract
GenevahBlacksmithInteract:
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
                                - if <[item].material.name.contains[stone]>:
                                    - chat "I can repair this for... eh... 16 stone blocks and an emerald."
                                    - wait 1s
                                    - chat "Does that sound good to you?"
                                    - flag player <npc>_RepairItem:<[item]>
                                    - flag player <npc>_RepairRequirements:i@stone
                                    - flag player <npc>_RepairRequirements:->:i@Emerald
                                    - flag player <npc>_RepairQuantities:16
                                    - flag player <npc>_RepairQuantities:->:1
                                    - zap 3
                                    - stop
                                - chat "I'm not sure I can repair this yet. Come back later."
                                - chat "((If you think I should repair this, tell Sil!))"
        3:
            proximity trigger:
                exit:
                    script:
                        - chat "See you around."
                        - inject ClearRepairFlag
                        - inject RandomWalk
                        - zap 1
            chat trigger:
                1:
                    trigger: /Regex:Yes|Yeah|Okay/, that sounds good.
                    script:
                        - define pass:true
                        - foreach <player.flag[<npc>_RepairRequirements]> as:item:
                            - define amount:<player.flag[<npc>_RepairQuantities].get[<[loop_index]>]>
                            - if !<player.inventory.contains[<[item]>].quantity[<[amount]>]>:
                                - chat "You're missing some supplies for this. Come back when you have them!"
                                - define pass:false
                                - foreach stop
                        - if <[pass]>:
                            - foreach <player.flag[<npc>_RepairRequirements]> as:item:
                                - define amount:<player.flag[<npc>_RepairQuantities].get[<[loop_index]>]>
                                - take <[item]> quantity:<[amount]>
                            - execute as_op "repair"
                            - chat "And there you go."
                            - wait 1s
                        - chat "See you around."
                        - inject ClearRepairFlag
                        - zap 1
                2:
                    trigger: /Regex:No|Nope|Nah/, but thanks.
                    script:
                        - chat "No worries. See you around."
                        - inject ClearRepairFlag
                        - zap 1
# #= Woodcutter
GenevahWoodcutter:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment Set!"
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
        on click:
            - define inv:GenevahWoodcutterInventory
            - inject NewMerchantFlagSetup
    interact scripts:
        - 1 GenevahWoodcutterInteract

GenevahWoodcutterInteract:
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
                        - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&f>[Offer to trade some goods.]<&f><&end_click><&end_hover>"
                2:
                    trigger: /Regex:Yes/, that sounds good.
                    script:
                        - chat "Fantastic! *The woodcutter would go to investigate your supply.*"
                        - wait 1s
                        - define inv:GenevahWoodcutterInventory
                        - inject NewMerchantFlagSetup


#=Farmer
GenevahFarmer:
    type: assignment
    actions:
        on click:
            - define inv:GenevahFarmerInventory
            - inject NewMerchantFlagSetup
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
    interact scripts:
        - 1 GenevahFarmerInteract

GenevahFarmerInteract:
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
                        - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&f>[Offer to trade some goods.]<&f><&end_click><&end_hover>"
                2:
                    trigger: /Regex:Yes/, that sounds good.
                    script:
                        - chat "Fantastic! *The farmer would go to investigate your supply.*"
                        - wait 1s
                        - define inv:GenevahFarmerInventory
                        - inject NewMerchantFlagSetup


#=CentercrestBuilder
GenevahBuilder:
    type: assignment
    actions:
        on assignment:
            - narrate "assignment set."
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
        on click:
            - define inv:GenevahBuilderInventory
            - inject NewMerchantFlagSetup
    interact scripts:
        - 1 GenevahBuilderInteract

GenevahBuilderInteract:
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
                        - chat "Hey there friend. Want to buy some supplies?"
                        - wait 1s
                        - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&f>[Offer to trade some goods.]<&f><&end_click><&end_hover>"
                2:
                    trigger: /Regex:Yes/, that sounds good.
                    script:
                        - chat "Fantastic! *The builder would go to investigate your supply.*"
                        - wait 1s
                        - define inv:GenevahBuilderInventory
                        - inject NewMerchantFlagSetup

#=Genevah Glass Merchant
#= Dockworker
GenevahGlassMerchant:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set."
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
        on click:
            - define inv:GenevahGlassMerchantInventory
            - inject NewMerchantFlagSetup
    interact scripts:
        - 1 GenevahGlassMerchantInteract

GenevahGlassMerchantInteract:
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
                        - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&f>[Offer to trade some goods.]<&f><&end_click><&end_hover>"
                2:
                    trigger: /Regex:Yes/, that sounds good.
                    script:
                        - chat "Fantastic! *The woodcutter would go to investigate your supply.*"
                        - wait 1s
                        - define inv:GenevahGlassMerchantInventory
                        - inject NewMerchantFlagSetup

#= Miner
GenevahMiner:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment Set!"
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
        on click:
            - define inv:GenevahMinerInventory
            - inject NewMerchantFlagSetup
    interact scripts:
        - 1 GenevahMinerInteract

GenevahMinerInteract:
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
                        - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&f>[Offer to trade some goods.]<&f><&end_click><&end_hover>"
                2:
                    trigger: /Regex:Yes/, that sounds good.
                    script:
                        - chat "Fantastic! *The Miner would go to investigate your supply.*"
                        - wait 1s
                        - define inv:GenevahMinerInventory
                        - inject NewMerchantFlagSetup

