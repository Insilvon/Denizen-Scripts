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
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - chat "Hello!"
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
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - chat "Hello!"
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