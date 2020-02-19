# Server Tasks
# Made and designed for AETHERIA
# @author Insilvon
# @version 1.0.1
# Core Scripts which apply to either a large number of scripts, or run on launch/closure

# =================================================================================
# ==========================="Kernal Core Setup Script"============================
# =================================================================================
CreeperCheck:
    type: world
    debug: false
    events:
        on entity spawns:
        - if <context.entity.entity_type> == CREEPER:
            - determine cancelled
        - if <context.entity.entity_type> == PHANTOM:
            - determine cancelled
Kernel:
    type: world
    debug: false
    events:
        on server start:
            - yaml "load:Utilities/DiscordBot.yml" id:DiscordBot
            
            - wait 5s
            - ~discord id:mybot connect code:<yaml[DiscordBot].read[info.code]>
            - define channel:<discord[mybot].group[Aetheria].channel[big-sister]>
            - define "message:<&co>white_check_mark<&co> **Server has started.**"
            - ~discord id:mybot message channel:<[channel]> <[message]>
            # Load all the Town Files
            - foreach <server.flag[Town_List]> as:Town:
                - if <server.has_file[/Towns/<[Town]>.yml]>:
                    - ~yaml "load:/Towns/<[Town]>.yml" id:<[Town]>
        on shutdown:
            - define channel:<discord[mybot].group[Aetheria].channel[big-sister]>
            - define "message:<&co>octagonal_sign<&co> **Server has stopped.**"
            - ~discord id:mybot message channel:<[channel]> <[message]>
        on NPC dies:
            - if <npc.has_flag[Follower]>:
                - remove <npc>
            - if <npc.has_flag[Town]>:
                - define town:<proc[TownFindNPC].context[<npc>]||null>
                - if <[town]> != null:
                    - run TownRemoveNPC instantly def:<npc>|<[town]>
        # on player logs in:
        #     - wait 1s
            
        on player joins:
            - if !<player.has_flag[notnew]>:
                - define channel:<discord[mybot].group[Aetheria].channel[⚙clockworks⚙]>
                - define "message:@everyone - <player.name> has joined the server for the first time!"
                - ~discord id:mybot message channel:<[channel]> <[message]>
                - flag player notnew
            - inject SkinSave
            - inject PlayerControllerOnJoin
            - inject LetterOnJoin
            - if <player.has_flag[CurrentCharacter]>:
                - inject QuestOnPlayerLogin
            - define channel:<discord[mybot].group[Aetheria].channel[big-sister]>
            - define "message:**<player.name> joined the server**"
            - ~discord id:mybot message channel:<[channel]> <[message]>
        on player quits:
            - define channel:<discord[mybot].group[Aetheria].channel[big-sister]>
            - define "message:**<player.name> left the server**"
            - ~discord id:mybot message channel:<[channel]> <[message]>
        on player dies:
            - define channel:<discord[mybot].group[Aetheria].channel[big-sister]>
            - define "message:**<&co>skull<&co> <player.name><&co> <context.message>**"
            - ~discord id:mybot message channel:<[channel]> <[message]>
            #= - inject LoadCharacterSheet
        on player clicks item in inventory priority:1:
            - if <context.inventory> == <player.inventory>:
                - stop
            - define character:<proc[GetCharacterName].context[<player>]>
            
            - if <context.inventory.notable_name||null> == <[character]>_Mailbox:
                - if <context.cursor_item.script.name||null> != LETTERBASE && <context.item.script.name||null> != LETTERBASE:
                    - determine cancelled
            # Check notable inventory Names
            - if <context.inventory.notable_name||null> == <[character]>_ProfessionMenu:
                - inject ClicksItemInCharacterProfessionMenu
                - stop
            # Check The Item Clicked
            - choose <context.item.script.name||null>:
                - case ConfirmItem:
                    - inject ClicksConfirmItemInInventory
                - case RejectItem:
                    - inject RejectMenu
                - case ActiveQuestItem:
                    - run QuestMenuHandler def:ActiveQuest instantly
                - case CompletedQuestItem:
                    - run QuestMenuHandler def:CompletedQuest instantly
                - case NextPageActiveQuestItem:
                    - run QuestPageHandler def:ActiveQuest|next instantly
                - case NextPageCompletedQuestItem:
                    - run QuestPageHandler def:CompletedQuest|next instantly
                - case LastPageActiveQuestItem:
                    - run QuestPageHandler def:ActiveQuest|back instantly
                - case LastPageCompletedQuestItem:
                    - run QuestPageHandler def:CompletedQuest|back instantly
                - default:
                    - inject QuestOnPlayerClicksInInventory
                    - inject SkillOnPlayerClicksInInventory
        on player enters SkyworldZone:
            - if <player.inventory.list_contents.contains_text[Elytra]>:
                - teleport <player> l@1194,197,-877,aetheria
        on item recipe formed:
            - if <context.item.material.name.contains[diamond]>:
                - determine cancelled
        on player changes world from skyworld_v2 to aetheria:
            - flag player Below
        on player changes world from aetheria to skyworld_v2:
            - flag player Below:!
        on item enchanted:
            - determine cancelled
        on player prepares anvil craft item:
            - determine cancelled
        on player places block:
            - inject OnPlayerPlacesCustomTree
            - inject LockpickOnPlayerPlacesBlock
        on player right clicks block:
            - inject LockpickCheckIfLocked
        on player breaks block:
            - inject LockpickBreakCheckIfLocked
        on player fishes item:
            - define acceptable:li@pufferfish|tropical_fish|cod|salmon
            - if !<[acceptable].contains[<context.item.material.name>]>:
                - determine cancelled
        on player right clicks with firework_rocket:
            - if <player.equipment.contains_text[elytra]> && <context.item.script.name||null> != ParafoilBoostCanister:
                - determine cancelled
            - else:
                - narrate "<&e>*You unleash a canister and feel the force of the wind on your face.*"
                - take ParafoilBoostCanister
        on player right clicks with COTSSkyStone:
             - if <player.equipment.contains_text[elytra]>:
                - define slot:<player.item_in_hand.slot>
                - define uses:<context.item.lore.get[2]||null>:
                - if <[uses]> == 1:
                    - narrate "<&a>Your stone has broke!"
                    - take <player.item_in_hand>
                    - give COTSSkyStoneBroken
                - else:
                    - narrate "<&a>Your skystone has <[uses].sub_int[1]> charges left."
                    - inventory adjust s:<[slot]> "lore:Use to give yourself a short boost|<[uses].sub_int[1]>|charges remaining."
                - shoot <player> origin:<player> speed:2
        on player enters Portal1:
            - if !<player.has_flag[Teleporting]> && <server.has_flag[Portal]> && <l@-5082,169,568,skyworld_v2.material.name> == player_head:
                - flag player Teleporting d:5s
                - teleport <player> l@-7467,178,1765,skyworld_v2
        on player enters Portal2:
            - if !<player.has_flag[Teleporting]> && <server.has_flag[Portal]> && <l@-7452,174,1781,skyworld_v2.material.name> == player_head:
                - flag player Teleporting d:5s
                - teleport <player> l@-5049,176,600,skyworld_v2

        on sit command:
            - determine cancelled
        on gsit command:
            - determine cancelled
        on player places torch:
            - if <player.flag[mode]||null> != builder:
                - if !<player.has_flag[TorchNotified]>:
                    - narrate "<&e>Your torches will burn out in 15 minutes."
                    - flag player TorchNotified d:15m
                - wait 15m
                - if <context.location.material.name> == torch:
                    - modifyblock <context.location> air
                    - drop BurntOutTorch <context.location>
                    - playsound location:<context.location> sound:block.fire.extinguish volume:0.5 custom
        #     # - if <player.flag[mode]||null> != RP:
        #     #     - determine FORMAT:BuildFormat
        on player left clicks skeleton_skull:
            - playsound <player.location> sound:BLOCK_NOTE_BLOCK_XYLOPHONE volume:10 pitch:<util.random.decimal[0.6].to[1.4]>

ModeToggle:
    type: command
    debug: false
    name: rp
    description: no
    usage: /rp
    permission: aetheria.rp
    script:
        - if !<player.has_flag[mode]>:
            - flag player mode:RP
            - narrate "You are now in RP mode."
            - flag player chat_channel:casual
            - stop
        - if <player.flag[mode]> == RP:
            - flag player mode:Builder
            - narrate "You are now in Build mode."
        - else:
            - flag player mode:RP
            - narrate "You are now in RP mode."
            - flag player chat_channel:casual



# =================================================================================
# ===========================Custom Block YAML Add/Edit============================
# =================================================================================

CreateChunkFile:
    type: task
    debug: false
    definitions: chunkID|locale|theItem
    script:
        - yaml create id:<[chunkID]>
        - yaml "savefile:/ChunkData/<[chunkID]>.yml" id:<[chunkID]>
        - yaml "load:/ChunkData/<[chunkID]>.yml" id:<[chunkID]>
        - yaml id:<[chunkID]> set info.<[locale]>:<[theItem]>
        - yaml "savefile:/ChunkData/<[chunkID]>.yml" id:<[chunkID]>
        - yaml unload id:<[chunkID]>
AddToChunkFile:
    type: task
    debug: false
    definitions: chunkID|locale|theItem
    speed: 3t
    script:
        - yaml "load:/ChunkData/<[chunkID]>.yml" id:<[chunkID]>
        - yaml id:<[chunkID]> set info.<[locale]>:<[theItem]>
        - yaml "savefile:/ChunkData/<[chunkID]>.yml" id:<[chunkID]>
        - yaml unload id:<[chunkID]>

# NPCS Save character steps
SaveNPCStep:
    type: task
    script:
        - define "script:s@<npc.script.yaml_key[interact scripts].get[1].after[1 ]>"
        - define character:<proc[GetCharacterName].context[<player>]>
        - flag player <[character]>_<npc>:<[script].step>
LoadNPCStep:
    type: task
    script:
        - define step:<player.flag[<proc[GetCharacterName].context[<player>]>_<npc>]||1>
        - define "script:s@<npc.script.yaml_key[interact scripts].get[1].after[1 ]>"
        - zap step:<[step]> <[script]> player:<player>
# =================================================================================
# ============================Custom File YAML Add/Edit============================
# =================================================================================
AlchemyDevMode:
    type: command
    debug: false
    name: dev
    description: What
    usage: /dev
    script:
        - if <player.has_flag[dev]>:
            - flag player dev:!
        - else:
            - flag player dev
CreateAlchemyFile:
    type: task
    debug: false
    script:
        - yaml create id:recipes
        - yaml "savefile:/Recipes/recipes.yml" id:recipes
        - yaml "load:/Recipes/recipes.yml" id:recipes
        - yaml id:recipes set TestRecipe.GoldNode:stone
        - yaml id:recipes set TestRecipe.LapisNode:stone
        - yaml id:recipes set TestRecipe.IronNode:stone
        - yaml id:recipes set TestRecipe.EmeraldNode:stone
        - yaml "savefile:/Recipes/recipes.yml" id:recipes
        - yaml unload id:recipes
AddToAlchemyFile:
    type: task
    debug: false
    definitions: RecipeName|GoldNode|LapisNode|IronNode|EmeraldNode|DiamondNode|GoldQuantity|LapisQuantity|IronQuantity|EmeraldQuantity|DiamondQuantity
    script:
        - yaml "load:/Recipes/recipes.yml" id:recipes
        - yaml id:recipes set <[RecipeName]>.GoldNode:<[GoldNode]>
        - yaml id:recipes set <[RecipeName]>.LapisNode:<[LapisNode]>
        - yaml id:recipes set <[RecipeName]>.IronNode:<[IronNode]>
        - yaml id:recipes set <[RecipeName]>.EmeraldNode:<[EmeraldNode]>
        - yaml id:recipes set <[RecipeName]>.DiamondNode:<[DiamondNode]>
        - yaml id:recipes set <[RecipeName]>.GoldQuantity:<[GoldQuantity]>
        - yaml id:recipes set <[RecipeName]>.LapisQuantity:<[LapisQuantity]>
        - yaml id:recipes set <[RecipeName]>.IronQuantity:<[IronQuantity]>
        - yaml id:recipes set <[RecipeName]>.EmeraldQuantity:<[EmeraldQuantity]>
        - yaml id:recipes set <[RecipeName]>.DiamondQuantity:<[DiamondQuantity]>
        - yaml "savefile:/Recipes/recipes.yml" id:recipes
ReadAlchemyFile:
    type: task
    debug: false
    definitions: GoldNode|LapisNode|IronNode|EmeraldNode|DiamondNode|GoldQuantity|LapisQuantity|IronQuantity|EmeraldQuantity|DiamondQuantity
    script:
        - yaml "load:/Recipes/recipes.yml" id:recipes
        - define recipes:<yaml[recipes].list_keys[]>
        # Go through all recipes
        - foreach <[recipes]> as:recipe:
            - narrate "<[recipe]>"
            - define components:<yaml[recipes].list_keys[<[recipe]>]>
            # Define all components of the recipe
            - foreach <[components]> as:component:
                # - narrate "<[component]><&co><yaml[recipes].read[<[recipe]>.<[component]>]>"
                - define <[component]>_loaded:<yaml[recipes].read[<[recipe]>.<[component]>]>
            # Loop through them all, checking against the flag counterpart
            - define status:true
            - foreach GoldNode|LapisNode|IronNode|EmeraldNode|DiamondNode|GoldQuantity|LapisQuantity|IronQuantity|EmeraldQuantity|DiamondQuantity as:Node:
                - narrate "Comparing <[<[Node]>_loaded]> and <[<[Node]>]>"
                - if <[<[Node]>_loaded]> != <[<[Node]>]>:
                    - define status:false
                    - foreach stop
                - if <[status]>:
                    - narrate "True! Matched <[recipe]>"
                    - give <[recipe]>
                    - stop
        - narrate "Failed! No matches found"
TestRecipe1:
    type: item
    material: gold_block
    display name: Test Recipe 1
TestRecipe2:
    type: item
    material: iron_block
    display name: Test Recipe 2
TestRecipe3:
    type: item
    material: diamond_block
    display name: Test Recipe 3

SetCharacterYAML:
    type: task
    debug: false
    definitions: player|key|value
    script:
        - define id:<[player].flag[CurrentCharacter]>
        - ~yaml "load:/CharacterSheets/<[player].uuid>/<[id]>.yml" id:<[player]>
        - yaml id:<[player]> set <[key]>:<[value]>
        - ~yaml "savefile:/CharacterSheets/<[player].uuid>/<[id]>.yml" id:<[player]>
        - yaml unload id:<[player]>

SetBaseYAML:
    type: task
    debug: false
    definitions: player|key|value
    script:
        - define id:<[player]>
        - ~yaml "load:/CharacterSheets/<[player].uuid>/base.yml" id:<[player]>
        - yaml id:<[player]> set <[key]>:<[value]>
        - ~yaml "savefile:/CharacterSheets/<[player].uuid>/base.yml" id:<[player]>
        - yaml unload id:<[player]>
ReadBaseYAML:
    type: procedure
    debug: false
    definitions: player|key
    script:
        - yaml load:/CharacterSheets/<[player].uuid>/base.yml id:<[player]>
        - define result:<yaml[<[player]>].read[<[key]>]>
        - yaml unload id:<[player]>
        - determine <[result]>
ModifyCharacterYAML:
    type: task
    debug: false
    definitions: player|key|value
    script:
        - define id:<[player].flag[CurrentCharacter]>
        - ~yaml "load:/CharacterSheets/<[player].uuid>/<[id]>.yml" id:<[player]>
        - define newValue:<yaml[<[player]>].read[<[key]>].add_int[<[value]>]>
        - yaml id:<[player]> set <[key]>:<[newValue]>
        - ~yaml "savefile:/CharacterSheets/<[player].uuid>/<[id]>.yml" id:<[player]>
        - yaml unload id:<[player]>
# This expects that all queries are of acceptable length
GetCharacterFromQuery:
    type: procedure
    debug: false
    definitions: player|query
    script:
        - define id:<[player]>_base>
        - yaml "load:/CharacterSheets/<[player].uuid>/base.yml" id:<[id]>
        - define characters:<yaml[<[id]>].read[characters]>
        - define index:<[characters].find_partial[<[query]>]>
        - if <[index]> == -1:
            - define result:false
        - else:
            - define result:<[characters].get[<[index]>]>
        - yaml unload id:<[id]>
        - determine <[result]>
# Gets this character's base name
# Could be replaced, purely here for accessibility
GetCharacterName:
    type: procedure
    debug: false
    definitions: player
    script:
        - define name:<proc[GetCharacterYAML].context[<[player]>|Info.Character_Name]>
        - if <[name]> == yaml[<&lt>[character]<&gt>].read[<&lt>[key]<&gt>]:
            - determine <[player].name>
        - else:
            - determine <[name]>
GetCharacterDisplayName:
    type: procedure
    debug: false
    definitions: player
    script:
        - define name:<proc[GetCharacterYAML].context[<[player]>|Info.Character_Display_Name]>
        - if <[name]> == yaml[<&lt>[character]<&gt>].read[<&lt>[key]<&gt>]:
            - determine  <[player].name>
        - else:
            - determine <[name]>
# Gets the last known location of this player
GetCharacterLocation:
    type: procedure
    debug: false
    definitions: player
    script:
        - determine <proc[GetCharacterYAML].context[<[player]>|Info.Character_Location]>
# Gets the name of the town the player is currently a member of
GetCharacterTown:
    type: procedure
    debug: false
    definitions: player
    script:
        - determine <proc[GetCharacterYAML].context[<[player]>|Town.Name]>
# General utility to access character sheet info
GetCharacterYAML:
    type: procedure
    debug: false
    definitions: player|key
    script:
        - define character:<[player].flag[CurrentCharacter]>
        - yaml load:/CharacterSheets/<[player].uuid>/<[character]>.yml id:<[character]>
        - define result:<yaml[<[character]>].read[<[key]>]>
        - yaml unload id:<[character]>
        - determine <[result]>
GetOtherCharacterYAML:
    type: procedure
    debug: false
    definitions: player|id|key
    script:
        - yaml load:/CharacterSheets/<[player].uuid>/<[id]>.yml id:<[id]>
        - define result:<yaml[<[id]>].read[<[key]>]>
        - yaml unload id:<[id]>
        - determine <[result]>
CharacterHasTown:
    type: procedure
    debug: false
    definitions: player
    script:
        - define town:<proc[GetCharacterTown].context[<player>]>
        - if <[town]> == none:
            - determine false
        - else:
            - determine true
