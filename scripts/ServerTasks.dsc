# Server Tasks
# Made and designed for AETHERIA
# @author Insilvon
# @version 1.0.1
# Core Scripts which apply to either a large number of scripts, or run on launch/closure

# =================================================================================
# ==========================="Kernal Core Setup Script"============================
# =================================================================================
Kernel:
    type: world
    events:
        on server start:
            - yaml "load:Utilities/DiscordBot.yml" id:DiscordBot
            - ~discord id:mybot connect code:<yaml[DiscordBot].read[info.code]>
            # Load all the Town Files
            - foreach <server.flag[TownList]> as:Town:
                - if <server.has_file[/Towns/<[Town]>.yml]>:
                    - ~yaml "load:/Towns/<[name]>.yml" id:<[Town]>

        on NPC dies:
            - if <npc.has_flag[Follower]>:
                - remove <npc>
            - if <npc.has_flag[Town]>:
                - define town:<proc[TownFindNPC].context[<npc>]||null>
                - if <[town]> != null:
                    - run TownRemoveNPC instantly def:<npc>|<[town]>
        on player logs in:
            - wait 1s
            - inject QuestOnPlayerLogin
        on player joins:
            - inject SkinSave
            - inject PlayerControllerOnJoin
            - inject LetterOnJoin
            #= - inject LoadCharacterSheet
        on player clicks item in inventory priority:1:
            - if <context.inventory> == <player.inventory>:
                - stop
            - define character:<proc[GetCharacterName].context[<player>]>
            
            - if <context.inventory.notable_name> == <[character]>_Mailbox:
                - if <context.cursor_item.script.name> != LETTERBASE && <context.item.script.name> != LETTERBASE:
                    - determine cancelled
            # Check notable inventory Names
            - if <context.inventory.notable_name> == <[character]>_ProfessionMenu:
                - inject ClicksItemInCharacterProfessionMenu
                - stop
            # Check The Item Clicked
            - choose <context.item.script.name>:
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
                - teleport <[player]> l@1194,197,-877,aetheria
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
            - define acceptable:li@pufferfish,tropical_fish,cod,salmon
            - if !<[acceptable].contains[<context.item>]>:
                - determine cancelled
# =================================================================================
# ===========================Custom Block YAML Add/Edit============================
# =================================================================================

CreateChunkFile:
    type: task
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
    definitions: chunkID|locale|theItem
    speed: 3t
    script:
        - yaml "load:/ChunkData/<[chunkID]>.yml" id:<[chunkID]>
        - yaml id:<[chunkID]> set info.<[locale]>:<[theItem]>
        - yaml "savefile:/ChunkData/<[chunkID]>.yml" id:<[chunkID]>
        - yaml unload id:<[chunkID]>

# =================================================================================
# ============================Custom File YAML Add/Edit============================
# =================================================================================
AlchemyDevMode:
    type: command
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
    definitions: player|key|value
    script:
        - define id:<[player].flag[CurrentCharacter]>
        - ~yaml "load:/CharacterSheets/<[player].uuid>/<[id]>.yml" id:<[player]>
        - yaml id:<[player]> set <[key]>:<[value]>
        - ~yaml "savefile:/CharacterSheets/<[player].uuid>/<[id]>.yml" id:<[player]>
        - yaml unload id:<[player]>

SetBaseYAML:
    type: task
    definitions: player|key|value
    script:
        - define id:<[player]>
        - ~yaml "load:/CharacterSheets/<[player].uuid>/base.yml" id:<[player]>
        - yaml id:<[player]> set <[key]>:<[value]>
        - ~yaml "savefile:/CharacterSheets/<[player].uuid>/base.yml" id:<[player]>
        - yaml unload id:<[player]>
ReadBaseYAML:
    type: procedure
    definitions: player|key
    script:
        - yaml load:/CharacterSheets/<[player].uuid>/base.yml id:<[player]>
        - define result:<yaml[<[player]>].read[<[key]>]>
        - yaml unload id:<[player]>
        - determine <[result]>
ModifyCharacterYAML:
    type: task
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
    definitions: player
    script:
        - define name:<proc[GetCharacterYAML].context[<[player]>|Info.Character_Name]>
        - if <[name]> == yaml[<&lt>[character]<&gt>].read[<&lt>[key]<&gt>]:
            - determine <[player].name>
        - else:
            - determine <[name]>
GetCharacterDisplayName:
    type: procedure
    definitions: player
    script:
        - determine <proc[GetCharacterYAML].context[<[player]>|Info.Character_Display_Name]>
# Gets the last known location of this player
GetCharacterLocation:
    type: procedure
    definitions: player
    script:
        - determine <proc[GetCharacterYAML].context[<[player]>|Info.Character_Location]>
# Gets the name of the town the player is currently a member of
GetCharacterTown:
    type: procedure
    definitions: player
    script:
        - determine <proc[GetCharacterYAML].context[<[player]>|Town.Name]>
# General utility to access character sheet info
GetCharacterYAML:
    type: procedure
    definitions: player|key
    script:
        - define character:<[player].flag[CurrentCharacter]>
        - yaml load:/CharacterSheets/<[player].uuid>/<[character]>.yml id:<[character]>
        - define result:<yaml[<[character]>].read[<[key]>]>
        - yaml unload id:<[character]>
        - determine <[result]>
GetOtherCharacterYAML:
    type: procedure
    definitions: player|id|key
    script:
        - yaml load:/CharacterSheets/<[player].uuid>/<[id]>.yml id:<[id]>
        - define result:<yaml[<[id]>].read[<[key]>]>
        - yaml unload id:<[id]>
        - determine <[result]>
CharacterHasTown:
    type: procedure
    definitions: player
    script:
        - define town:<proc[GetCharacterTown].context[<player>]>
        - if <[town]> == none:
            - determine false
        - else:
            - determine true
