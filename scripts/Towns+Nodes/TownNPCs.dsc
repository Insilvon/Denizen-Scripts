# Utility Town NPCs Proof of Concept
# Made and designed for AETHERIA
# @author Insilvon
# @version 2.0.1
# Allows players to recruit NPCs from the world and bring them to their town
# Special thanks to Mergu for his NPC Skin->URL script, originally found
# here: https://one.denizenscript.com/denizen/repo/entry/154, adapted for this specific task
# =================================================================================
# ================================== Controller ===================================
# =================================================================================
TownNPCController:
    type: world
    events:
        on player right clicks with TownFarmerVoucher|TownBlacksmithVoucher|TownAlchemistVoucher|TownWoodcutterVoucher|TownMinerVoucher|TownTrainerVoucher:
            # permission check
            - define locale:<player.location.cursor_on.relative[0,1,0]>
            - define scriptname:<context.item.script>
            - define npcType:<proc[GetNPCType].context[<[scriptname]>]>
            - define town:<player.flag[<[character]>_Town]||null>
            
            - if !<server.flag[TownList].contains[<[town]>]>:
                - narrate "You must be a member of a town to do this!" format:TownFormat
                - stop
            - define npcCount:<proc[GetTownYAML].context[<[town]>|NPCs.<[npcType]>]||0>
            - if <[npcCount]> == 0:
                # create DNPC
                - create player <proc[GetRandomName]> <[locale]> save:temp
                - adjust <entry[temp].created_npc> lookclose:TRUE
                - adjust <entry[temp].created_npc> set_assignment:PlacedTown<[npcType]>Assignment
                - flag <entry[temp].created_npc> Town
                - run SetVulnerable npc:<entry[temp].created_npc>
                
                # set skin of DNPC
                - define url:<proc[GetTownNPCSkin].context[<[npcType]>]>
                - define counter:0
                - define success:false
                - while <[success].matches[false]> && <[counter].as_int> <= 10:
                    - define counter:<[counter].add_int[1]>
                    - define url:<proc[GetTownNPCSkin].context[<[npcType]>]>
                    - inject SetNPCURLSkin
                
                - run TownAddNewNPC instantly def:<[town]>|<entry[temp].created_npc>/<[npcType]>|<[npcType]>

# =================================================================================
# ==================================== FARMERS ====================================
# =================================================================================
FarmerNPCAssignment:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment Set!"
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
    interact scripts:
        - 1 FarmerNPCInteract

FarmerNPCInteract:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - chat "I am a farmer. I want to help you. Want me to help?"
                        - narrate "YES|NO"
                2:
                    trigger: /Regex:Yes/
                    script:
                        - chat "Excellent, I am now yours."
                        - chat "Take this voucher. Place it where you want me to work."
                        - give TownFarmerVoucher
PlacedTownFarmerAssignment:
    type: assignment
    actions:
        on click:
            - flag player NPCInventory:DeltaFarmerInventory
            - inventory open d:NewMerchantInventory
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
    interact scripts:
        - 1 PlacedTownFarmerInteract


PlacedTownFarmerInteract:
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
                        - chat "Hello! Have you come to deliver goods to Stratum?"
                        - wait 1s
                        - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&f>Offer to trade some goods.<&f><&end_click><&end_hover>"
                2:
                    trigger: /Regex:Yes/, that sounds good.
                    script:
                        - chat "Fantastic! *The farmer would go to investigate your supply.*"
                        - wait 2s
                        - flag player NPCInventory:DeltaFarmerInventory
                        - inventory open d:NewMerchantInventory

TownFarmerController:
    type: world
    events:
        on player clicks item in TownFarmerInventory:
            - determine cancelled passively
            - define item:<context.item||null>
            - define click:<context.click>
            - if <[click]> == left && <[item]> != null && <[item].has_lore>:
                - choose <[item].material.name>:
                    - case wheat:
                        - define quantity:<context.item.lore.get[1]>
                        - if <player.inventory.contains[Wheat].quantity[<[quantity]>]>:
                            - take wheat quantity:<[quantity]>
                            - if <[quantity]> == 32:
                                - give emerald quantity:1
                            - if <[quantity]> == 64:
                                - give emerald quantity:2
                            - if <[quantity]> == 128:
                                - give emerald quantity:4
                        - else:
                            - inventory close
                            - narrate "<&c>You do not have enough supply for that!"
                    - case apple:
                        - define quantity:<context.item.lore.get[1]>
                        - if <player.inventory.contains[apple].quantity[<[quantity]>]>:
                            - take apple quantity:<[quantity]>
                            - if <[quantity]> == 32:
                                - give emerald quantity:1
                            - if <[quantity]> == 64:
                                - give emerald quantity:2
                            - if <[quantity]> == 128:
                                - give emerald quantity:4
                        - else:
                            - inventory close
                            - narrate "<&c>You do not have enough supply for that!"
                    - case cooked_beef:
                        - define quantity:<context.item.lore.get[1]>
                        - if <player.inventory.contains[cooked_beef].quantity[<[quantity]>]>:
                            - take cooked_beef quantity:<[quantity]>
                            - if <[quantity]> == 32:
                                - give emerald quantity:1
                            - if <[quantity]> == 64:
                                - give emerald quantity:2
                            - if <[quantity]> == 128:
                                - give emerald quantity:4
                        - else:
                            - inventory close
                            - narrate "<&c>You do not have enough supply for that!"
                    - case cooked_chicken:
                        - define quantity:<context.item.lore.get[1]>
                        - if <player.inventory.contains[cooked_chicken].quantity[<[quantity]>]>:
                            - take cooked_chicken quantity:<[quantity]>
                            - if <[quantity]> == 32:
                                - give emerald quantity:1
                            - if <[quantity]> == 64:
                                - give emerald quantity:2
                            - if <[quantity]> == 128:
                                - give emerald quantity:4
                        - else:
                            - inventory close
                            - narrate "<&c>You do not have enough supply for that!"
                    - case carrot:
                        - define quantity:<context.item.lore.get[1]>
                        - if <player.inventory.contains[carrot].quantity[<[quantity]>]>:
                            - take carrot quantity:<[quantity]>
                            - if <[quantity]> == 32:
                                - give emerald quantity:1
                            - if <[quantity]> == 64:
                                - give emerald quantity:2
                            - if <[quantity]> == 128:
                                - give emerald quantity:4
                        - else:
                            - inventory close
                            - narrate "<&c>You do not have enough supply for that!"
                    - case cooked_mutton:
                        - define quantity:<context.item.lore.get[1]>
                        - if <player.inventory.contains[cooked_mutton].quantity[<[quantity]>]>:
                            - take cooked_mutton quantity:<[quantity]>
                            - if <[quantity]> == 32:
                                - give emerald quantity:1
                            - if <[quantity]> == 64:
                                - give emerald quantity:2
                            - if <[quantity]> == 128:
                                - give emerald quantity:4
                        - else:
                            - inventory close
                            - narrate "<&c>You do not have enough supply for that!"
                    - case baked_potato:
                        - define quantity:<context.item.lore.get[1]>
                        - if <player.inventory.contains[baked_potato].quantity[<[quantity]>]>:
                            - take baked_potato quantity:<[quantity]>
                            - if <[quantity]> == 32:
                                - give emerald quantity:1
                            - if <[quantity]> == 64:
                                - give emerald quantity:2
                            - if <[quantity]> == 128:
                                - give emerald quantity:4
                        - else:
                            - inventory close
                            - narrate "<&c>You do not have enough supply for that!"
                    - case beetroot:
                        - define quantity:<context.item.lore.get[1]>
                        - if <player.inventory.contains[beetroot].quantity[<[quantity]>]>:
                            - take beetroot quantity:<[quantity]>
                            - if <[quantity]> == 32:
                                - give emerald quantity:1
                            - if <[quantity]> == 64:
                                - give emerald quantity:2
                            - if <[quantity]> == 128:
                                - give emerald quantity:4
                        - else:
                            - inventory close
                            - narrate "<&c>You do not have enough supply for that!"
                            
TownFarmerInventory:
    type: inventory
    title: Crimson Delta Farmer
    size: 54
    slots:
    - "[] [] [] [] [QuestionMarkItem] [] [] [] []"
    - "[] [i@wheat[lore=32|<&a>Sell Price<&co> 1 Emerald]] [i@wheat[lore=64|<&a>Sell Price<&co> 2 Emeralds]] [i@wheat[lore=128|<&a>Sell Price<&co> 4 Emeralds]] [] [i@baked_potato[lore=32|<&a>Sell Price<&co> 1 Emerald]] [i@baked_potato[lore=64|<&a>Sell Price<&co> 2 Emeralds]] [i@baked_potato[lore=128|<&a>Sell Price<&co> 4 Emeralds]] []"
    - "[] [i@apple[lore=32|<&a>Sell Price<&co> 1 Emerald]] [i@apple[lore=64|<&a>Sell Price<&co> 2 Emeralds]] [i@apple[lore=128|<&a>Sell Price<&co> 4 Emeralds]] [] [i@carrot[lore=32|<&a>Sell Price<&co> 1 Emerald]] [i@carrot[lore=64|<&a>Sell Price<&co> 2 Emeralds]] [i@carrot[lore=128|<&a>Sell Price<&co> 4 Emeralds]] []"
    - "[] [i@cooked_beef[lore=32|<&a>Sell Price<&co> 1 Emerald]] [i@cooked_beef[lore=64|<&a>Sell Price<&co> 2 Emeralds]] [i@cooked_beef[lore=128|<&a>Sell Price<&co> 4 Emeralds]] [] [i@cooked_mutton[lore=32|<&a>Sell Price<&co> 1 Emerald]] [i@cooked_mutton[lore=64|<&a>Sell Price<&co> 2 Emeralds]] [i@cooked_mutton[lore=128|<&a>Sell Price<&co> 4 Emeralds]] []"
    - "[] [i@cooked_chicken[lore=32|<&a>Sell Price<&co> 1 Emerald]] [i@cooked_chicken[lore=64|<&a>Sell Price<&co> 2 Emeralds]] [i@cooked_chicken[lore=128|<&a>Sell Price<&co> 4 Emeralds]] [] [i@beetroot[lore=32|<&a>Sell Price<&co> 1 Emerald]] [i@beetroot[lore=64|<&a>Sell Price<&co> 2 Emeralds]] [i@beetroot[lore=128|<&a>Sell Price<&co> 4 Emeralds]] []"
    - "[] [] [] [] [] [] [] [] []"

# =================================================================================
# =================================== TRAINERS ====================================
# =================================================================================
PlacedTownTrainerAssignment:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment Set!"
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
    interact scripts:
        - 1 PlacedTownTrainerInteract
PlacedTownTrainerInteract:
    type: interact
    steps:
        1:
            proximity trigger:
                exit:
                    script:
                        - inject RandomWalk
                        - inject ClearTrainingFlag
                        - zap 1
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - random:
                            - chat "Ah! Welcome welcome! Are you from the Firstborne? I am at your service!"
                            - chat "Welcome! I'm <npc.name>. Are you ready to do some training?"
                            - chat "Good of you to show - I've got several candidates chomping at the bit to train."
                        - wait 1s
                        - chat "How can I assist you today?"
                        - wait 1s
                        - narrate "<&hover[Click Me!]><&click[Can we train some units?]>Ask to train some units.<&end_click><&end_hover>"
                2:
                    trigger: Can we train some /units/?
                    script:
                        - random:
                            - chat "Yes, we can most certainly get to training."
                            - chat "Of course."
                            - chat "It would be my pleasure."
                        - wait 1s
                        # Edit this line when more are in
                        - chat "Currently I have Infantry units available for training."
                        - wait 1s
                        - narrate "<&hover[Click Me!]><&click[Let<&sq>s train some infantry.]>Ask to train some Infantry.<&end_click><&end_hover>"
                3:
                    trigger: Let<&sq>s train some /infantry/.
                    script:
                        - chat "As always, they demand their payment ahead of time. They'll want one emerald, 16 bread, and a stone sword each."
                        - wait 2s
                        - chat "How many would you like to train?"
                        - narrate "<&hover[Click Me!]><&click[Let<&sq>s train 1.]>Train One Infantry.<&end_click><&end_hover> | <&hover[Click Me!]><&click[Let<&sq>s train 2.]>Train two Infantry.<&end_click><&end_hover> | <&hover[Click Me!]><&click[Let<&sq>s train 3.]>Train three Infantry.<&end_click><&end_hover> | <&hover[Click Me!]><&click[Nevermind, maybe later.]>Change your mind.<&end_click><&end_hover>"
                        - flag player <npc>_Unit:Infantry
                        - flag player <npc>_UnitRequirements:i@Emerald
                        - flag player <npc>_UnitRequirements:->:i@Bread
                        - flag player <npc>_UnitRequirements:->:i@Stone_Sword
                        - flag player <npc>_UnitReqQuantity:1
                        - flag player <npc>_UnitReqQuantity:->:16
                        - flag player <npc>_UnitReqQuantity:->:1
                4:
                    trigger: Regex:/Goodbye|Maybe Later/.
                    script:
                        - chat "No worries. I serve at your pleasure."
                        - wait 1s
                        - chat "Take care."
                        - inject ClearTrainingFlag
                5:
                    trigger: Give me /Regex:1|2|3/.
                    script:
                        - if !<player.has_flag[<npc>_Unit]>:
                            - wait 1s
                            - chat "I have no idea what unit you'd like me to train."
                            - narrate "<&hover[Click Me!]><&click[Let<&sq>s train some infantry.]>Ask to train some Infantry.<&end_click><&end_hover>"
                            - stop
                        - define number:<context.keyword>
                        - define requirements:<player.flag[<npc>_UnitRequirements]>
                        - define quantities:<player.flag[<npc>_UnitReqQuantity].as_list>
                        - define pass:true
                        - foreach <player.flag[<npc>_UnitRequirements]> as:item:
                            - define amount:<player.flag[<npc>_UnitReqQuantity].get[<[loop_index]>].mul_int[<[number]>]>
                            - if !<player.inventory.contains[<[item]>].quantity[<[amount]>]>:
                                - chat "You're missing some supplies for this. Come back when you have them!"
                                - define pass:false
                                - foreach stop
                        - if <[pass]>:
                            - foreach <player.flag[<npc>_UnitRequirements]> as:item:
                                - define amount:<player.flag[<npc>_UnitReqQuantity].get[<[loop_index]>].mul_int[<[number]>]>
                                - narrate "<[item]>"
                                - take <[item]> quantity:<[amount]>
                            - give <player.flag[<npc>_Unit]>Voucher quantity:<[number]>
                            - chat "And there you go."
                            - narrate "You have received a follower. After using this ticket, the Follower will be at your side for 15 minutes."
                            - narrate "At any time, you can request your follower to wait or follower by right-clicking them."
                            - wait 1s
                        - chat "See you around."
                        - inject ClearTrainingFlag
                        - zap 1

# TownShopController:
#     type: world
#     events:
#         on player clicks <item> in <inventory>:
            #- define click:<context.click>
            # Buy material/acquire ingredient
            #- if <[click]> == left:
            # Give material/sell ingredient
            #- if <[click]> == right:
TownTrainerInventory:
    type: inventory
    title: Learned Skills
    size: 54
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
# =================================================================================
# ================================= BLACKSMITHS ===================================
# =================================================================================
PlacedTownBlacksmithAssignment:
    type: assignment
    actions:
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
    interact scripts:
        - 1 PlacedTownBlacksmithInteract

PlacedTownBlacksmithInteract:
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
                        - narrate "<&hover[Click Me!]><&click[Can you repair this?]>[Ask to repair your held item.]<&end_click><&end_hover>"
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
                                    - chat "I can repair this for 16 dark oak logs and 10 emeralds."
                                    - wait 1s
                                    - chat "Does this sound good to you?"
                                    - flag player <npc>_RepairItem:<[item]>
                                    - flag player <npc>_RepairRequirements:i@dark_oak_log
                                    - flag player <npc>_RepairRequirements:->:i@Emerald
                                    - flag player <npc>_RepairQuantities:16
                                    - flag player <npc>_RepairQuantities:->:10
                                    - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&a>Agree and trade the items.<&f><&end_click><&end_hover> | <&hover[Click Me!]><&click[No thanks.]><&c>Decline and leave.<&end_click><&end_hover>"
                                    - zap 3
                                    - stop
                                - chat "I'm not sure I can repair this yet. Come back later."
                                - chat "((If you think I should repair this, tell Sil!))"
                        - else:
                            - narrate "It looks like you aren't holding anything!"
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
    
# TownShopController:
#     type: world
#     events:
#         on player clicks <item> in <inventory>:
            #- define click:<context.click>
            # Buy material/acquire ingredient
            #- if <[click]> == left:
            # Give material/sell ingredient
            #- if <[click]> == right:
TownSmithInventory:
    type: inventory
    title: Learned Skills
    size: 54
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
# =================================================================================
# =================================== BUILDERS ====================================
# =================================================================================
# TownShopController:
#     type: world
#     events:
#         on player clicks <item> in <inventory>:
            #- define click:<context.click>
            # Buy material/acquire ingredient
            #- if <[click]> == left:
            # Give material/sell ingredient
            #- if <[click]> == right:
TownBuilderInventory:
    type: inventory
    title: Learned Skills
    size: 54
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"



            
# TownAddNPCUpgrade:
#     type: task
#     definitions: name|npcType
#     script:
#         - 
TownAddNewNPC:
    type: task
    definitions: name|keypair|npcType
    script:
        #= will the following work the same?
        #- define currentMembers:<yaml[<[name]>].read[Inhabitants.NPCS]>.include[<[keypair]>]>
        - define currentMembers:<yaml[<[name]>].read[Inhabitants.NPCS].as_list||li@>
        - define currentMembers:<[currentMembers].insert[<[keypair]>].at[0]>
        - yaml id:<[name]> set Inhabitants.NPCS:<[currentMembers]>
        - yaml id:<[name]> set NPCs.Total:+:1
        - yaml id:<[name]> set NPCs.<[npcType]>:+:1
        - ~yaml "savefile:/Towns/<[name]>.yml" id:<[name]>
        - yaml unload id:<[name]>


SetVulnerable:
    type: task
    script:
        - vulnerable state:true

InfantrySetup:
    type: task
    script:
        - vulnerable state:true
        - execute as_server "sentinel addtarget denizen_proc:TownInfantryTargeting:<npc.id> --id:<npc.id>"

TownInfantryTargeting:
    type: procedure
    definitions: npc
    script:
        - if <entity.type> == player:
            # If the player is an enemy of the town
            - define character:<proc[GetCharacterName].context[<entity>]>
            - if <entity.flag[<[character]>_TownEnemy].contains[]>
        - if <entity.type> == npc:

# Based on the provided script voucher name, returns the keyword to use when
# referencing this npc type later
GetNPCType:
    type: procedure
    definitions: name
    script:
        - foreach Farmer|Blacksmith|Alchemist|Woodcutter|Trainer|Miner|Builder as:type:
            - if <[name].contains_text[<[type]>]>:
                - determine <[type]>

#======================MISC===================#
RandomTownAssignment:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment Set"
            - trigger name:proximity state:true
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
        on click:
            - random:
                - chat "Are you one of the sky-settlers? I wonder why you've decided to come here."
                - chat "You've wandered to the wrong camp. Did anyone tell you?"
                - chat "Did you see it? The cave?"
                - chat "I can't wait to get back up there. I've been on this surface too long."
                - chat "Look at this ground. Completely charred. I don't know why we can't find new fuel for the sky."
    interact scripts:
        - 10 RandomTownInteract
RandomTownInteract:
    type: interact
    steps:
        1:
            proximity trigger:
                exit:
                    script:
                        - inject RandomWalk
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - random:
                            - chat "Are you one of the sky-settlers? I wonder why you've decided to come here."
                            - chat "You've wandered to the wrong camp. Did anyone tell you?"
                            - chat "Did you see it? The cave?"
                            - chat "I can't wait to get back up there. I've been on this surface too long."
                            - chat "Look at this ground. Completely charred. I don't know why we can't find new fuel for the sky."
PlacedTownLeaderAssignment:
    type: assignment
    actions:
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
    interact scripts:
        - 1 PlacedTownLeaderInteract
PlacedTownLeaderInteract:
    type: interact
    steps:
        1:
            proximity trigger:
                exit:
                    script:
                        - inject RandomWalk
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - random:
                            - chat "Hello. Come to visit <npc.name>?"
                            - chat "Greetings, <proc[GetCharacterName].context[<player>]>."
                        - wait 1s
                        - chat "How can I assist you today?"
                        - narrate "<&hover[Click Me!]><&click[Tell me about yourself.]><&f>Ask about them.<&f><&end_click><&end_hover> | <&hover[Click Me!]><&click[Tell me about the town.]><&f>Ask about the sky-town.<&f><&end_click><&end_hover>"
                2:
                    trigger: Tell me about /yourself/.
                    script:
                        - chat "Well, as you may have put together already, I am a robonoid."
                        - wait 3s
                        - chat "Not necessarily a true robonoid as mentioned in some of the ancient literature, but a reincarnated Skyborne in an automata shell."
                        - wait 8s
                        - chat "You may find yourself concerned at my presence and general autonomy. I can assure you I am of mostly sound mind and body after my reintegration process."
                        - wait 8s
                        - chat "But now I am here, a commander of my own Sky-Town, the Crimson Delta. Now, if you'll excuse me, I have some business to attend to."
                        - wait 8s
                        - chat "Please speak with some of the current residents - there are others coming, however they are out on missions of their own."
                        - inject RandomWalk
                3:
                    trigger: Tell me about /the town/.
                    script:
                        - chat "The town here is called The Crimson Delta. Named it myself."
                        - wait 3s
                        - chat "We've come a long way. Stratum originally constructed a great number of these roaming platforms back in the day. I managed to luck out and purchase one for myself."
                        - wait 8s
                        - chat "So now we roam, floating from island to island diving and collecting goods for ourselves. Although, I believe now many of us simply wish to settle down and lay low for a while."
                        - wait 8s
                        - chat "Please speak with some of the current residents - there are others coming, however they are out on missions of their own."
                        - inject RandomWalk
ElytraCheck:
    type: world
    events:
        on player prepares anvil craft item:
            - determine cancelled
RandomWalk:
    type: task
    script:
        - if <npc.anchor[A1]||null> != null && <npc.anchor[A2]||null> != null && <npc.anchor[A3]||null> != null:
            - random:
                - walk <npc> <npc.anchor[A1]>
                - walk <npc> <npc.anchor[A2]>
                - walk <npc> <npc.anchor[A3]>
ClearRepairFlag:
    type: task
    script:
        - flag player <npc>_RepairItem:!
        - flag player <npc>_RepairRequirements:!
        - flag player <npc>_RepairQuantities:!
ClearTrainingFlag:
    type: task
    script:
        - flag player <npc>_Unit:!
        - flag player <npc>_UnitRequirements:!
        - flag player <npc>_UnitReqQuantity:!
QuestionMarkItem:
    type: Item
    material: player_head[skull_skin=945906b4-6fdc-4b99-9a26-30906befb63a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNjM4YzUzZTY2ZjI4Y2YyYzdmYjE1MjNjOWU1ZGUxYWUwY2Y0ZDdhMWZhZjU1M2U3NTI0OTRhOGQ2ZDJlMzIifX19]
    display name: Help
    lore:
        - <&a>Left click the item
        - <&a>you wish to sell, or
        - <&e>right click to buy!
        - (Buying only available
        - from some traders.)