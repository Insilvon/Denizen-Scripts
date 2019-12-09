# Utility Town NPCs Proof of Concept
# Made and designed for AETHERIA
# @author Insilvon
# @version 2.0.1
# Allows players to recruit NPCs from the world and bring them to their town
# Special thanks to Mergu for his NPC Skin->URL script, originally found
# here: https://one.denizenscript.com/denizen/repo/entry/154, adapted for this specific task

# =================================================================================
# ==================================== FARMERS ====================================
# =================================================================================
FarmerNPCAssignment:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment Set!"
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
    interact scripts:
        - 1 PlacedTownFarmerInteract

PlacedTownFarmerInteract:
    type: interact
    steps:
        1:
            proximity trigger:
                exit:
                    script:
                        - random:
                            - anchor walkto i:A1
                            - anchor walkto i:A2
                            - anchor walkto i:A3
                        - zap 1
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - wait 1s
                        - chat "Hello! Have you come to deliver goods to Stratum?"
                        - wait 1s
                        - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&f>Offer to trade some wheat.<&f><&end_click><&end_hover>"
                2:
                    trigger: /Regex:Yes/, that sounds good.
                    script:
                        - chat "Fantastic! *The farmer would go to investigate your wheat supply.*"
                        - wait 1s
                        - if <player.inventory.contains[wheat]>:
                            - chat "I see that you currently have <player.inventory.quantity[wheat]> harvested wheat."
                            - if <player.inventory.quantity[wheat]> < 32:
                                - wait 1s
                                - chat "I only accept donations in quantities of 32 or more..."
                                - wait 1s
                                - chat "Come back with more!"
                                - zap 1
                            - else:
                                - wait 1s
                                - chat "How much would you like to trade?"
                                - narrate "<&hover[Click Me!]><&click[32]><&f>Offer 32 wheat.<&f><&end_click><&end_hover> | <&hover[Click Me!]><&click[64]><&f>Offer 64 wheat.<&f><&end_click><&end_hover> | <&hover[Click Me!]><&click[128]><&f>Offer 128 wheat.<&f><&end_click><&end_hover>"
                                - zap 2
                        - else:
                            - chat "You... have none? Maybe come back with some actual supplies next time."
                            - zap 1
        2:
            proximity trigger:
                exit:
                    script:
                        - chat "See you around."
                        - random:
                            - anchor walkto i:A1
                            - anchor walkto i:A2
                            - anchor walkto i:A3
                        - zap 1

            chat trigger:
                1:
                    trigger: /32/
                    script:
                        - if <player.inventory.contains[wheat].quantity[32]>:
                            - take wheat quantity:32
                            - chat "Thank you for your donation! In exchange I will grant you one emerald."
                            - give emerald
                            - wait 1s
                            - chat "Take care!"
                            - zap 1
                        - else:
                            - chat "You don't have that many! Don't pull my leg."
                            - wait 1s
                            - chat "Get outta here."
                2:
                    trigger: /64/
                    script:
                        - if <player.inventory.contains[wheat].quantity[64]>:
                            - take wheat quantity:64
                            - chat "Thank you for your donation! In exchange I will grant you two emeralds."
                            - give emerald quantity:2
                            - wait 1s
                            - chat "Take care!"
                            - zap 1
                        - else:
                            - chat "You don't have that many! Don't pull my leg."
                            - wait 1s
                            - chat "Get outta here."

                3:
                    trigger: /128/
                    script:
                        - if <player.inventory.contains[wheat].quantity[128]>:
                            - take wheat quantity:128
                            - chat "Thank you for your donation! In exchange I will grant you four emeralds."
                            - give emerald quantity:4
                            - wait 1s
                            - chat "Take care!"
                            - zap 1
                        - else:
                            - chat "You don't have that many! Don't pull my leg."
                            - wait 1s
                            - chat "Get outta here."
                        
# TownShopController:
#     type: world
#     events:
#         on player clicks <item> in <inventory>:
            #- define click:<context.click>
            # Buy material/acquire ingredient
            #- if <[click]> == left:
            # Give material/sell ingredient
            #- if <[click]> == right:
TownFarmerInventory:
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
# =================================== TRAINERS ====================================
# =================================================================================
PlacedTownTrainerAssignment:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment Set!"
    interact scripts:
        - 1 PlacedTownTrainerInteract
PlacedTownTrainerInteract:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - chat "Hello! Want to train some militia?"
                2:
                    trigger: /Regex:Yes/
                    script:
                        - chat "Excellent. What do you want to train?"
                3:
                    trigger: /Regex:Infantry/
                    script:
                        - if <player.inventory.contains[InfantryVoucher]>:
                            - chat "Alright! I'll take that voucher and... bam! You've acquired new militia."
                            - give TownInfantryVoucher
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
    interact scripts:
        - 1 PlacedTownBlacksmithInteract

PlacedTownBlacksmithInteract:
    type: interact
    steps:
        1:
            proximity trigger:
                exit:
                    script:
                        - random:
                            - anchor walkto i:A1
                            - anchor walkto i:A2
                            - anchor walkto i:A3
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
                        - if <[item].material.name> != air:
                            - chat "So let's see, you've got this <[item].material.name> here..."
                            - wait 1s
                            - if <[item].script.name> == SkyborneParafoil:
                                - chat "A parafoil for sure. I believe I can repair this for some goods."
                                - wait 1s
                                - chat "I'll need 16 diamonds, 8 iron ingots, and 4 emeralds for now."
                                - wait 1s
                                - if <[item].durability> == 0:
                                    - chat "Wait... this is already fully repaired! Is there something else you could need repaired?"
                                    - stop
                                - if <player.inventory.contains[diamond].quantity[16]> && <player.inventory.contains[iron_ingot].quantity[8]> && <player.inventory.contains[emerald].quantity[4]>:
                                    - chat "Does this sound fair to you?"
                                    - wait 1s
                                    - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&a>Agree and trade the items.<&f><&end_click><&end_hover> | <&hover[Click Me!]><&click[No thanks.]><&c>Decline and leave.<&end_click><&end_hover>"
                                    - zap 2
                                - else:
                                    - chat "Come on back when you've got those materials!"
                            - else:
                                - if <[item].material.name.contains[iron]>:
                                    - chat "I can repair this for two iron ingots and an emerald."
                                    - wait 1s
                                    - chat "Does this sound good to you?"
                                    - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&a>Agree and trade the items.<&f><&end_click><&end_hover> | <&hover[Click Me!]><&click[No thanks.]><&c>Decline and leave.<&end_click><&end_hover>"
                                    - zap 3
                                - else:
                                    - chat "I'm not sure I can repair this yet. Come back later."
                                    - chat "((If you think I should repair this, tell Sil!))"
        2:
            proximity trigger:
                exit:
                    script:
                        - chat "See you around."
                        - random:
                            - anchor walkto i:A1
                            - anchor walkto i:A2
                            - anchor walkto i:A3
                        - zap 1
            chat trigger:
                1:
                    trigger: /Regex:Yes|Yeah|Okay/, that sounds good.
                    script:
                        - define item:<player.item_in_hand>
                        - if <player.inventory.contains[diamond].quantity[16]> && <player.inventory.contains[iron_ingot].quantity[8]> && <player.inventory.contains[emerald].quantity[4]>:
                            - if <player.item_in_hand> == <[item]>:
                                - take diamond quantity:16
                                - take iron_ingot quantity:8
                                - take emerald quantity:4
                                - execute as_op "repair"
                            - else:
                                - chat "You're swapping items on me. Choose one. Flat rate."
                        - chat "See you around."
                        - zap 1
                2:
                    trigger: /Regex:No|Nope|Nah/, but thanks.
                    script:
                        - chat "No worries. See you around."
                        - zap 1
        3:
            proximity trigger:
                exit:
                    script:
                        - chat "See you around."
                        - random:
                            - anchor walkto i:A1
                            - anchor walkto i:A2
                            - anchor walkto i:A3
                        - zap 1
            chat trigger:
                1:
                    trigger: /Regex:Yes|Yeah|Okay/, that sounds good.
                    script:
                        - define item:<player.item_in_hand>
                        - if <player.inventory.contains[iron_ingot].quantity[2]> && <player.inventory.contains[emerald].quantity[1]>:
                            - if <player.item_in_hand> == <[item]>:
                                - take iron_ingot quantity:2
                                - take emerald quantity:1
                                - execute as_op "repair"
                            - else:
                                - chat "You're swapping items on me. Choose one. Flat rate."
                        - else:
                            - chat "You don't have the materials. Come back when you've got them."
                        - chat "See you around."
                        - zap 1
                2:
                    trigger: /Regex:No|Nope|Nah/, but thanks.
                    script:
                        - chat "No worries. See you around."
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

# =================================================================================
# ================================== Controller ===================================
# =================================================================================
TownNPCController:
    type: world
    events:
        on entity death:
            - define entity:<context.entity>
            - if <[entity].contains_text[n@]>:
                - define town:<proc[TownFindNPC].context[<[entity]>]||null>
                - if <[town]> != null:
                    - run TownRemoveNPC instantly def:<[entity]>|<[town]>
        on player right clicks with TownFarmerVoucher|TownBlacksmithVoucher|TownAlchemistVoucher|TownWoodcutterVoucher|TownMinerVoucher|TownTrainerVoucher:
            # permission check
            - define locale:<player.location.cursor_on.relative[0,1,0]>
            - define scriptname:<context.item.script>
            - define npcType:<proc[GetNPCType].context[<[scriptname]>]>
            - define townID:<proc[GetCharacterTown].context[<player>]>

            - inject TownPermissionHelper

            # create DNPC
            - create player <proc[GetRandomName]> <[locale]> save:temp
            - adjust <entry[temp].created_npc> lookclose:TRUE
            - adjust <entry[temp].created_npc> set_assignment:PlacedTown<[npcType]>Assignment
            - run SetVulnerable npc:<entry[temp].created_npc>
            
            # set skin of DNPC
            - define url:<proc[GetTownNPCSkin].context[<[npcType]>]>
            - define counter:0
            - define success:false
            - while <[success].matches[false]> && <[counter].as_int> <= 10:
                - define counter:<[counter].add_int[1]>
                - define url:<proc[GetTownNPCSkin].context[<[npcType]>]>
                - inject SetNPCURLSkin

            - run TownAddNPC instantly def:<[townID]>|<entry[temp].created_npc>/<[npcType]>|<[npcType]>
        on player right clicks with TownInfantryVoucher:
            - define locale:<player.location.cursor_on.relative[0,1,0]>
            - define scriptname:<context.item.script>
            - define npcType:<proc[GetNPCType].context[<[scriptname]>]>
            - define townID:<proc[GetCharacterTown].context[<player>]>

            - inject TownPermissionHelper

            # create DNPC
            - create player <proc[GetRandomName]> <[locale]> traits:Sentinel save:temp
            - adjust <entry[temp].created_npc> lookclose:TRUE
            - adjust <entry[temp].created_npc> set_assignment:PlacedTown<[npcType]>Assignment

            - run InfantrySetup npc:<entry[temp].created_npc>
            
            # set skin of DNPC
            - define url:<proc[GetTownNPCSkin].context[<[npcType]>]>
            - define counter:0
            - define success:false
            - while <[success].matches[false]> && <[counter].as_int> <= 10:
                - define counter:<[counter].add_int[1]>
                - define url:<proc[GetTownNPCSkin].context[<[npcType]>]>
                - inject SetNPCURLSkin

            - run TownAddNPC instantly def:<[townID]>|<entry[temp].created_npc>/<[npcType]>|<[npcType]>

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
        - foreach Farmer|Blacksmith|Alchemist|Woodcutter|Trainer|Miner as:type:
            - if <[name].contains_text[<[type]>]>:
                - determine <[type]>
# =================================================================================
# =================================== SKINS =======================================
# =================================================================================
# Using the provided keyword, returns a random URL for a skin
# To use for that NPC
GetTownNPCSkin:
    type: procedure
    definitions: type
    script:
        - if <[type]> == farmer:
            - random:
                - determine https://i.imgur.com/MGvfad2.png
                - determine https://i.imgur.com/vC27pzA.png
                - determine https://i.imgur.com/FEKIxq9.png
                - determine https://i.imgur.com/PlWEXxe.png
        - if <[type]> == blacksmith:
            - random:
                - determine https://i.imgur.com/6xVVUEZ.png
                - determine https://i.imgur.com/Tpj5ZYR.png
                - determine https://i.imgur.com/DcHXhoD.png
        - if <[type]> == woodcutter:
            - random:
                - determine https://i.imgur.com/nwLYKhd.png
                - determine https://i.imgur.com/eWP6rOu.png
                - determine https://i.imgur.com/lWBukOp.png
        - if <[type]> == alchemist:
            - random:
                - determine https://i.imgur.com/lyYfGkS.png
                - determine https://i.imgur.com/4P1o5Tj.png
                - determine https://i.imgur.com/SuC8B29.png
        - if <[type]> == trainer:
            - random:
                - determine https://i.imgur.com/t0LvBI6.png
                - determine https://i.imgur.com/zNPkKhp.png
                - determine https://i.imgur.com/LombOzu.png
        - if <[type]> == miner:
            - random:
                - determine https://i.imgur.com/BjpGsf6.png
                - determine https://i.imgur.com/nO1AsGv.png
                - determine https://i.imgur.com/K61pPMU.png
        - if <[type]> == automata:
            - random:
                - determine https://i.imgur.com/xY3LOqf.png
                - determine https://i.imgur.com/ZioUK54.png
                - determine https://i.imgur.com/veIFOmY.png
                - determine https://i.imgur.com/pr6OEID.png
                - determine https://i.imgur.com/viCeTLf.png
                - determine https://i.imgur.com/yIrM2d7.png
                - determine https://i.imgur.com/OAS66Rt.png
                - determine https://i.imgur.com/L2xqwtc.png
                - determine https://i.imgur.com/0WAaBk6.png
        - random:
            - determine https://i.imgur.com/8m9UiRb.png
            - determine https://i.imgur.com/fX5LM0i.png
SetNPCURLSKin:
    type: task
    script:
        - define key <util.random.uuid>
        - run skin_url_task def:<def[key]>|<def[url]>|empty id:<def[key]> instantly
        - while <queue.exists[<def[key]>]>:
            - if <def[loop_index]> > 20:
                - queue q@<def[key]> clear
                - queue clear
            - wait 5t
        # Quick sanity check - ideally this should never be true
        - if !<server.has_flag[<def[key]>]>:
            - queue clear
        - if <server.flag[<def[key]>]> == null:
            - flag server <def[key]>:!
        - yaml loadtext:<server.flag[<def[key]>]> id:response
        - if <yaml[response].contains[data.texture]>:
            - adjust <entry[temp].created_npc> skin_blob:<yaml[response].read[data.texture.value]>;<yaml[response].read[data.texture.signature]>
            - define success:true
        - flag server <def[key]>:!
        - yaml unload id:response

RandomTownAssignment:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment Set"
            - trigger name:proximity state:true
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
                # entry:
                #     script:
                #         - random:
                #             - anchor walkto i:A1
                #             - anchor walkto i:A2
                #             - anchor walkto i:A3
                exit:
                    script:
                        - random:
                            - anchor walkto i:A1
                            - anchor walkto i:A2
                            - anchor walkto i:A3
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
    interact scripts:
        - 1 PlacedTownLeaderInteract
PlacedTownLeaderInteract:
    type: interact
    steps:
        1:
            proximity trigger:
                exit:
                    script:
                        - random:
                            - anchor walkto i:A1
                            - anchor walkto i:A2
                            - anchor walkto i:A3
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
                        - random:
                            - anchor walkto i:A1
                            - anchor walkto i:A2
                            - anchor walkto i:A3
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
                        - random:
                            - anchor walkto i:A1
                            - anchor walkto i:A2
                            - anchor walkto i:A3
ElytraCheck:
    type: world
    events:
        on player prepares anvil craft item:
            - determine cancelled