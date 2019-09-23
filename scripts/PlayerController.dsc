# Player Character Controller Proof of Concept
# Made and designed for AETHERIA
# @author Insilvon
# @version 2.0.3
# Allows players to create and save data between multiple "characters" on one account

# Current Flags: Character (# of Chars), Character List, Equipment flags (e_id)
# Character GUI
# TODO: Refactor and clean up code - verify this works with quests
PlayerControllerOnJoin:
    type: task
    script:
        - wait 0.1s
        - if !<player.has_flag[Character]>:
            - flag player Character:0
        - narrate "<&b>[Characters] - Setting your total number of characters."
        - if !<player.has_flag[CharacterGUI]>:
            - flag player CharacterGUI
            - note in@CharacterGUIMenu as:<player.uuid>_GUI
        - define path:/CharacterSheets/<player.uuid>/
        - if !<server.has_file[<[path]>base.yml]>:
            - narrate "Creating Base File"
            - yaml create id:base
            - yaml "savefile:<[path]>base.yml" id:base
            - yaml "load:<[path]>base.yml" id:base
            # Set data here
            - yaml id:base set info.username:<player.name>
            - yaml id:base set permissions.character_limit:2
            - yaml "savefile:<[path]>base.yml" id:base
            - yaml unload id:base
        - else:
            - narrate "<&b>[Characters] - Missing base file!"

PlayerController:
    type: world
    events:
        # TODO - MOVE THIS TO GENERAL SCRIPTS
        on player joins:
            - inject PlayerControllerOnJoin
        # TODO - ...does this need to be generalized?
        on player clicks player_head in inventory:
            - define arg:<context.raw_slot>
            - inject CharacterSwap

CharacterGUIMenu:
    type: inventory
    title: Character Select
    size: 9
    slots:
        - "[] [] [] [] [] [] [] [] []"

# Command script - handles /character
CharacterCommand:
    type: command
    name: Character
    aliases:
    - c
    description: Manage your characters
    usage: /character select|reset|swap|nick
    script:
        - define args:<context.args>
        - if <[args].size> == 1:
            - define command:<[args].get[1]>
            - if <[command]> == select:
                - inject CharacterSelect
            - if <[command]> == reset:
                - inject CharacterReset
        - if <[args].size> == 2:
            - define command:<[args].get[1]>
            - if <[command]> == create:
                - inject CharacterCreate
            - if <[command]> == swap:
                - define arg:<context.args.get[2]>
                - inject CharacterSwap
            - if <[command]> == nick:
                - define arg:<context.args.get[2]>
                - inject CharacterNick
        - inject CharacterSelect

# Script to open the character select screen
CharacterSelect:
    type: task
    script:
        - inventory open d:in@<player.uuid>_GUI
        - stop

# TODO: Create a "remove character" function+remove flags
# Removes all flags and character info
CharacterReset:
    type: task
    script:
        - define totalCharacters:<player.flag[Character].as_int>
        - repeat <[totalCharacters]> as:number:
            - inject QuestReset
        - flag player Character:0
        - flag player Character_List:!
        - flag player CurrentCharacter:!
        - flag player e_1:!
        - flag player e_2:!
        - flag player e_3:!
        - flag player e_4:!
        - flag player e_5:!
        - note remove as:<player.uuid>_1
        - note remove as:<player.uuid>_2
        - note remove as:<player.uuid>_3
        - note remove as:<player.uuid>_4
        - note remove as:<player.uuid>_5
        - execute as_op "nickname <player.name>"
        - narrate "<&b>[Characters] - You have reset your account."
        - inventory clear d:in@<player.uuid>_GUI
        - stop
# Creates a new character using the current display name
CharacterCreate:
    type: task
    script:
        - define path:/CharacterSheets/<player.uuid>/
        - if !<server.has_file[/CharacterSheets/<player.uuid>/base.yml]>:
            - narrate "You are lacking crucial backend files. Please message an admin."
        - else:
            - yaml load:<[path]>base.yml id:base
            - define limit:<yaml[base].read[permissions.character_limit]>
            - if <player.flag[Character]> < <[limit]>:
                - narrate "<&b>[Characters] - You have successfully created a new character with the name <context.args.get[2]>"
                - narrate "<&b>[Characters] - Swap to your character with /character"
                - flag player Character:+:1
                - define newFile:/CharacterSheets/<player.uuid>/<player.flag[Character]>.yml
                - define id:<player.flag[Character]>
                - yaml create id:<[id]>
                - ~yaml "savefile:/CharacterSheets/<player.uuid>/<[id]>.yml" id:<[id]>
                - ~yaml "load:/CharacterSheets/<player.uuid>/<[id]>.yml" id:<[id]>
                # Script Info
                - ~yaml id:<[id]> set Script.Version:0.0.2
                # Info
                - ~yaml id:<[id]> set Info.Character_Name:<context.args.get[2]>
                - ~yaml id:<[id]> set Info.Character_Display_Name:<context.args.get[2]>
                - ~yaml id:<[id]> set Info.Character_Location:<player.location>
                # SkillAPI
                # Description
                - ~yaml id:<[id]> set Description.Text:""
                # Faction
                - ~yaml id:<[id]> set Faction.Name:""
                # Town
                - ~yaml id:<[id]> set Town.Name:""
                # Renown
                - ~yaml id:<[id]> set Renown.ChildrenOfTheSun:0
                - ~yaml id:<[id]> set Renown.Skyborne:0
                - ~yaml id:<[id]> set Renown.Outsiders:0
                # Flags
                - foreach <player.list_flags> as:flag:
                    - yaml id:<[id]> set Flags.<[flag]>:<player.flag[<[flag]>]>
                # Bounties ?
                # Town
                # Wayshrine ?
                # Titles ?
                # Achievements ?
                - ~yaml "savefile:/CharacterSheets/<player.uuid>/<[id]>.yml" id:<[id]>
                - yaml unload id:<[id]>
                - if !<player.has_flag[Character_List]>:
                    - flag player Character_List:<[args].get[2]>
                - else:
                    - flag player Character_List:->:<[args].get[2]>
                - note "i@player_head[display_name=<[args].get[2]>;lore=$*@*$]" as:<player.uuid>_head<player.flag[Character]>
                - inventory add d:in@<player.uuid>_GUI o:i@<player.uuid>_head<player.flag[Character]>
            - else:
                - narrate "<&b>[Characters] - You have reached your maximum amount of characters."
                - narrate "<&b>[Characters] - Is this an error?"
        - stop

# Swaps to the other character
CharacterSwap:
    type: task
    script:
        - define path:/CharacterSheets/<player.uuid>/<[arg]>.yml
        - if <player.flag[Character]> >= 1:
            - if <server.has_file[/CharacterSheets/<player.uuid>/<[arg]>.yml]>:
                # TODO: Fix the proc
                - if <player.has_flag[CurrentCharacter]>:
                    - yaml load:/CharacterSheets/<player.uuid>/<player.flag[CurrentCharacter]>.yml id:<player.flag[CurrentCharacter]>
                    - yaml id:<player.flag[CurrentCharacter]> set info.character_location:<player.location>
                    - yaml savefile:/CharacterSheets/<player.uuid>/<player.flag[CurrentCharacter]>.yml id:<player.flag[CurrentCharacter]>
                    - yaml unload id:<player.flag[CurrentCharacter]>
                    - note <player.inventory> as:<player.uuid>_<player.flag[CurrentCharacter]>
                    - narrate "<&b>[Characters] - Inventory Saved!"
                    - flag <player> e_<player.flag[CurrentCharacter]>:<player.equipment>
                - narrate "End of IF statement! Running through nick changes!"
                - define character_name:<proc[CharacterFetch].context[<[path]>|<[arg]>]>
                - execute as_server "nickname <player.name> <[character_name]>"
                - narrate "<&b>[Characters] - You are now <[character_name]>"
                - flag player CurrentCharacter:<[arg]>
                - yaml load:/CharacterSheets/<player.uuid>/<[arg]>.yml id:<[arg]>
                - teleport <player> <yaml[<[arg]>].read[info.character_location]>
                - yaml unload id:<[arg]>
                - inventory clear d:<player.inventory>
                - define origin:in@<player.uuid>_<player.flag[CurrentCharacter]>
                - inventory set d:<player.inventory> o:<[origin]>
                - adjust <player> 'equipment:<player.flag[e_<player.flag[CurrentCharacter]>]>'
        - stop
# Changes the display name for the current character
CharacterNick:
    type: task
    script:
        - define character:<player.flag[CurrentCharacter]>
        # TODO: Check permissions to change display name/implement cooldown
        - ~yaml load:/CharacterSheets/<player.uuid>/<[character]>.yml id:<[character]>
        - ~yaml id: <[character]> set Info.Character_Display_Name:<[arg]>
        - ~yaml savefile:/CharacterSheets/<player.uuid>/<[character]>.yml id:<[character]>
        - ~yaml unload id:<[character]>
        - execute as_server "nickname <player.name> <[arg]>"

# Helper script for Character Swap
CharacterFetch:
    type: procedure
    definitions: path|target
    script:
        - yaml load:<[path]> id:<[target]>
        - define result:<yaml[<[target]>].read[info.character_name]>
        - yaml unload id:<[target]>
        - determine <[result]>