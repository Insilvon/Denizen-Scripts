# Player Character Controller Proof of Concept
# Made and designed for AETHERIA
# @author Insilvon
# @version 2.0.4
# Allows players to create and save data between multiple "characters" on one account

# Current Flags: Character (# of Chars), Character List, Equipment flags (e_id)
# Character GUI
# TODO: Refactor and clean up code - verify this works with quests

CharacterFormat:
    type: format
    format: "<&b>[Characters]<&co><&f> <text>"

PlayerControllerOnJoin:
    type: task
    script:
        - wait 0.1s
        - if !<player.has_flag[Character]>:
            - flag player Character:0
            - flag player TotalCharacters:0
            - flag player LiveCharacters:0
            - narrate "Setting your total number of characters." format:CharacterFormat
        - if !<player.has_flag[CharacterGUI]>:
            - flag player CharacterGUI
            - note in@CharacterGUIMenu as:<player.uuid>_GUI
        - if !<server.has_file[CharacterSheets/<player.uuid>/base.yml]>:
            - narrate "Creating Base File" format:CharacterFormat
            - yaml create id:base
            - yaml "savefile:/CharacterSheets/<player.uuid>/base.yml" id:base
            - yaml "load:/CharacterSheets/<player.uuid>/base.yml" id:base
            # Set data here
            - yaml id:base set info.username:<player.name>
            - yaml id:base set permissions.character_limit:1
            - yaml "savefile:/CharacterSheets/<player.uuid>/base.yml" id:base
            - yaml unload id:base
        - else:
            - narrate "All loaded!" format:CharacterFormat
            - if !<player.has_flag[CurrentCharacter]>:
                - narrate "Create your first character with /character create <&lt>YourCharacter'sName<&gt>!" format:CharacterFormat


PlayerController:
    type: world
    events:
        # TODO - MOVE THIS TO GENERAL SCRIPTS
        on player right clicks entity:
            - if <context.entity.is_player> && <player.is_sneaking> && !<player.has_flag[Reading]>:
                - flag player Reading d:1s
                - define target:<context.entity>
                - define targetCharacter:<[target].flag[CurrentCharacter]>
                - yaml "load:/CharacterSheets/<[target].uuid>/<[targetCharacter]>.yml" id:<[target].uuid_desc>
                - narrate "<yaml[<[target].uuid_desc>].read[Description.Text]>"
                - yaml unload id:<[target].uuid_desc>
        # TODO - ...does this need to be generalized?
        on player clicks player_head in inventory:
            - if <context.inventory> == <player.inventory>:
                - stop
            - if <context.inventory.notable_name> == <player.uuid>_GUI:
                - define arg:<context.item.lore.get[1]>
                - inject CharacterSwap

CharacterGUIMenu:
    type: inventory
    title: Character Select
    size: 9
    slots:
        - "[] [] [] [] [] [] [] [] []"
CharacterCommand:
    type: command
    name: Character
    aliases:
    - c
    description: Manage characters
    usage: /character
    script:
        - if !<player.has_flag[Character]>:
            - inject PlayerControllerOnJoin
        - define command:<context.args.get[1]||null>
        - choose <[command]>:
            - case select:
                - inject CharacterSelect
                - stop
            - case reset:
                - inject CharacterReset
                - stop
            - case help:
                - inject CharacterHelp
                - stop
            - case create:
                - inject CharacterCreate
                - stop
            - case nick:
                - define arg:<context.args.get[2]>
                - inject CharacterNick
            - case remove:
                - if <context.args.get[2]> == confirm:
                    - inject CharacterRemoveConfirm
                - else:
                    - define arg:<context.args.get[2]>
                    - inject CharacterRemove
                    - stop
            - case skin:
                - define arg:<context.args.get[2]||null>
                - choose <[arg]>:
                    - case help:
                        - narrate "To use this feature, you must upload your character's skin to <&a>http://imgur.com<&f> and get the .png link from the image." format:CharacterFormat
                        - narrate "Then run /c skin i.imgur.com/yourskinlink.png to set this character's skin." format:CharacterFormat
                    - case reset:
                        - adjust <player> skin_blob:<server.flag[<player.uuid>_DefaultSkin]>
                    - default:
                        - narrate "Changing skin to <context.args.get[2]>!" format:CharacterFormat
                        - define character:<player.flag[CurrentCharacter]>
                        - flag player <[character]>_skin:<context.args.get[2]>
                        - define skinTexture:true
                        - inject SkinHandler
                        - narrate "<[skinTexture]>"
                        - define inv:in@<player.uuid>_GUI
                        - narrate "<[inv]>"
                        - define target:<[inv].list_contents.with_lore[<[character]>].get[1].get[1]>
                        - narrate "<[target]>"
                        - define slot:<[inv].find[<[target]>]>
                        - narrate "<[slot]>"
                        - inventory adjust "skull_skin:<player.uuid>|<[skinTexture]>" d:<[inv]> slot:<[slot]>

                - stop
            - case desc:
                - define arg:<context.args.get[2]||null>
                - choose <[arg]>:
                    - case set:
                        - inject CharacterDescSet
                        - stop
                    - case read:
                        - inject CharacterDescRead
                        - stop
                    - case add:
                        - inject CharacterDescAdd
                        - stop
            - default:
                - inject CharacterSelect

# # Command script - handles /character
# CharacterCommand:
#     type: command
#     name: Character
#     aliases:
#     - c
#     description: Manage your characters
#     usage: /character select|reset|swap|nick
#     script:
#         - if !<player.has_flag[Character]>:
#             - inject PlayerControllerOnJoin
#         - define args:<context.args>

#             - if <[command]> == desc:
#                 - if <context.args.get[2]||null> == read:
#                     - inject CharacterDescRead
#                     - stop
#         - if <[args].size> == 3:
#             - define command:<context.args.get[1]>
#             - if <[command]> == description || <[command]> == desc:
#                 - if <context.args.get[2]> == set:
#                     - inject CharacterDescSet
#                     - stop
#                 - if <context.args.get[2]> == add:
#                     - inject CharacterDescAdd
#                     - stop
#                 - narrate "Unrecognized command." format:CharacterFormat
#         - inject CharacterSelect
CharacterHelp:
    type: task
    script:
        - narrate "Character Commands:" format:CharacterFormat
        - narrate "<&b>/c<&f>, <&b>/c select<&f> - Become one of your Characters"
        - narrate "<&b>/c reset<&f> - Wipe ALL DATA regarding ALL CHARACTERS."
        - narrate "<&b>/c help<&f> - Display this menu."
        - narrate "<&b>/c create YourCharactersRealName<&f> - Create a new Character with a given real name. Ex: /c create JamesBond"
        - narrate "<&b>/c nick YourCharactersDisplayName<&f> - Nickname your character something other than their real name. Ex: /c nick &b007"
        - narrate "<&b>/c remove ID<&f> - In the character select menu, the ID of each character is shown in the lore of the head. This removes that character."
        - narrate "<&b>/c remove confirm<&f> - Confirms you wish to remove your selected character."
        - narrate "<&b>/c desc set <&lt>Text<&gt><&f> - Sets your character's description, clearing anything present."
        - narrate "<&b>/c desc add <&lt>Text<&gt><&f> - Adds onto your current description."
        - narrate "<&b>/c desc read<&f> - Shows you your current description as someone else would see it."
        - stop
# Script to open the character select screen
CharacterSelect:
    type: task
    script:
        - inventory open d:in@<player.uuid>_GUI
        - stop
CharacterRemove:
    type: task
    script:
        - narrate "Warning - deleting a character will remove all data associated with them! Admins cannot restore data after this!" format:CharacterFormat
        - wait 2s
        - narrate "You are attempting to delete Character with ID <[arg]> and with the name <proc[GetOtherCharacterYAML].context[<player>|<[arg]>|Info.Character_Display_Name]>" format:CharacterFormat
        - wait 2s
        - narrate "If this is truly what you want, please run /character remove confirm" format:CharacterFormat
        - flag player CharacterRemove:<[arg]> d:1m
        - stop
CharacterRemoveConfirm:
    type: task
    script:
        - define arg:<player.flag[CharacterRemove]>
        - flag player CharacterRemove:!
        - narrate "Now removing  Character with ID <[arg]>, name <proc[GetOtherCharacterYAML].context[<player>|<[arg]>|Info.Character_Display_Name]>" format:CharacterFormat
        - flag player LiveCharacters:--
        - if <player.flag[CurrentCharacter]> == <[arg]>:
            - flag player CurrentCharacter:!
            - inventory clear d:in@<player.uuid>_GUI
            - execute as_op "nickname <player.name>"
        - flag player e_<[arg]>:!
        - define inv:in@<player.uuid>_GUI
        - define target:i@player_head[display_name=<proc[GetOtherCharacterYAML].context[<player>|<[arg]>|Info.Character_Display_Name]>;lore=<[arg]>]
        - foreach <[inv].list_contents.full> as:head:
            - narrate "<[head]> vs <[target]>"
            - if <[head].lore.get[1]> == <[arg]>:
                - take <[head]> from:<[inv]>
                - stop
            
        # - note remove as:<player.uuid>_head<player.flag[Character]>
        # - define item:<player.uuid>_head<player.flag[Character]>
        # - inventory remove d:<[inv]> o:<[item]>

        - stop
# TODO: Create a "remove character" function+remove flags
# Removes all flags and character info
CharacterReset:
    type: task
    script:
        - repeat <player.flag[totalcharacters].as_int> as:number:
            - inject QuestReset
        - flag player Character:0
        # - flag player Character_List:!
        - flag player CurrentCharacter:!
        - flag player TotalCharacters:0
        - flag player LiveCharacters:0
        - repeat <player.flag[TotalCharacters]> as:id:
            - flag player e_<[id]>:!
            - note remove as:<player.uuid>_<[id]>
        - execute as_op "nickname <player.name>"
        - narrate "You have reset your account." format:CharacterFormat
        - inventory clear d:in@<player.uuid>_GUI
        - stop
# Creates a new character using the current display name
CharacterCreate:
    type: task
    script:
        - define path:/CharacterSheets/<player.uuid>/
        - if !<server.has_file[/CharacterSheets/<player.uuid>/base.yml]>:
            - narrate "You are lacking crucial backend files. Please message an admin." format:CharacterFormat
        - else:
            - yaml load:<[path]>base.yml id:base
            - define limit:<yaml[base].read[permissions.character_limit]>
            - if <player.flag[LiveCharacters]> < <[limit]>:
                - narrate "You have successfully created a new character with the name <context.args.get[2]>" format:CharacterFormat
                - narrate "Swap to your character with /character" format:CharacterFormat
                # Increment stats
                - flag player Character:+:1
                - flag player LiveCharacters:+:1
                - flag player TotalCharacters:+:1
                - define newFile:/CharacterSheets/<player.uuid>/<player.flag[Character]>.yml
                # Set the ID of this new character to be the newest totalcharacter - always unique
                - define id:<player.flag[TotalCharacters]>
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
                # Flags - Why are we setting them on a new character???
                # - foreach <player.list_flags> as:flag:
                #     - yaml id:<[id]> set Flags.<[flag]>:<player.flag[<[flag]>]>
                # Bounties ?
                # Town
                # Wayshrine ?
                # Titles ?
                # Achievements ?
                - ~yaml "savefile:/CharacterSheets/<player.uuid>/<[id]>.yml" id:<[id]>
                - yaml unload id:<[id]>
                # - if !<player.has_flag[Character_List]>:
                #     - flag player Character_List:<[args].get[2]>
                # - else:
                #     - flag player Character_List:->:<[args].get[2]>
                - note "i@player_head[display_name=<context.args.get[2]>;lore=<player.flag[TotalCharacters]>]" as:<player.uuid>_head<player.flag[Character]>
                - inventory add d:in@<player.uuid>_GUI o:<player.uuid>_head<player.flag[Character]>
            - else:
                - narrate "You have reached your maximum amount of characters." format:CharacterFormat
                - narrate "Is this an error?" format:CharacterFormat
        - stop

# Swaps to the other character
# == MAKE THIS LOAD THE YAML ONCE, RATHER THAN UNLOAD AND RELOAD 800 TIMES
CharacterSwap:
    type: task
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - if !<player.has_flag[<[character]>_Letter]> && <player.has_flag[character]>:
            - note in@LetterInventory as:<[character]>_Mailbox
            - flag player <[character]>_Letter
        - define path:/CharacterSheets/<player.uuid>/<[arg]>.yml
        - if <player.flag[Character]> >= 1:
            - if <server.has_file[/CharacterSheets/<player.uuid>/<[arg]>.yml]>:
                # TODO: Fix the proc
                - if <player.has_flag[CurrentCharacter]>:
                    - yaml load:/CharacterSheets/<player.uuid>/<player.flag[CurrentCharacter]>.yml id:<player.flag[CurrentCharacter]>
                    - yaml id:<player.flag[CurrentCharacter]> set info.character_location:<player.location>
                    # - foreach <player.list_flags> as:flag:
                    #     - yaml id:<player.flag[CurrentCharacter]> set flags:->:<[flag]>
                    #     - if !<[flag].contains_text[Character]>:
                    #         - flag <player> <[flag]>:!
                    - yaml savefile:/CharacterSheets/<player.uuid>/<player.flag[CurrentCharacter]>.yml id:<player.flag[CurrentCharacter]>
                    - yaml unload id:<player.flag[CurrentCharacter]>
                    - note <player.inventory> as:<player.uuid>_<player.flag[CurrentCharacter]>
                    - narrate "Inventory Saved!" format:CharacterFormat
                    - flag <player> e_<player.flag[CurrentCharacter]>:<player.equipment>
                # Set character
                - flag player CurrentCharacter:<[arg]>
                - define character_name:<proc[GetCharacterName].context[<player>]>
                - define character_display_name:<proc[GetCharacterYAML].context[<player>|Info.Character_Display_Name]>
                # Set nick
                - execute as_server "nickname <player.name> <[character_display_name]>"
                - narrate "You are now <[character_name]>" format:CharacterFormat
                # move them to their last location
                # CHECK THIS
                - define location:<proc[GetCharacterLocation].context[<player>]>
                - teleport <player> <[location]>
                # set their inventory/equipment
                - inventory clear d:<player.inventory>
                # TODO: Edit this so it only runs when the player has 2+ characters
                - define origin:in@<player.uuid>_<player.flag[CurrentCharacter]>
                - inventory set d:<player.inventory> o:<[origin]>
                - adjust <player> 'equipment:<player.flag[e_<player.flag[CurrentCharacter]>]>'
                - define character:<player.flag[CurrentCharacter]>
                - if <player.has_flag[<[character]>_skin]>:
                    - inject SkinHandler
                    - define skin_blob:<player.skin_blob>
                    - adjust <context.item> skull_skin:<player.uuid>|<[skin_blob]|Twisted_Fractal>
                - else:
                    - narrate "You have not set a skin for this character! Do so with <&hover[View Skin Command]><&click[/c skin help]><&3>/c skin help<&f><&end_click><&end_hover>" format:CharacterFormat
                - inject AddCharacterToSheet
                # - execute as_op "skin <player.flag[<[character]>_skin]>"
        - stop
AddCharacterToSheet:
    type: task
    script:
        - define id:<player.uuid>_base
        - define character:<proc[GetCharacterName].context[<player>]>
        - ~yaml "load:/CharacterSheets/<player.uuid>/base.yml" id:<[id]>
        - if !<yaml[<[id]>].read[characters].contains[<[character]>]>:
            - yaml id:<[id]> set characters:->:<proc[GetCharacterName].context[<player>]>
            - ~yaml "savefile:/CharacterSheets/<player.uuid>/base.yml" id:<[id]>
        - yaml unload id:<[id]>
ReadAllCharacters:
    type: task
    script:
        - define id:<player.uuid>_base
        - ~yaml "load:/CharacterSheets/<player.uuid>/base.yml" id:<[id]>
        - narrate <yaml[<[id]>].read[characters].space_separated> format:CharacterFormat
        - yaml unload id:<[id]>
# Changes the display name for the current character
CharacterNick:
    type: task
    script:
        - define character:<player.flag[CurrentCharacter]>
        # TODO: Check permissions to change display name/implement cooldown
        - ~yaml load:/CharacterSheets/<player.uuid>/<[character]>.yml id:<[character]>
        - ~yaml id:<[character]> set Info.Character_Display_Name:<[arg]>
        - ~yaml savefile:/CharacterSheets/<player.uuid>/<[character]>.yml id:<[character]>
        - ~yaml unload id:<[character]>
        - execute as_server "nickname <player.name> <[arg]>"
        - stop

# # Helper script for Character Swap
# CharacterFetch:
#     type: procedure
#     definitions: path|target
#     script:
#         - yaml load:<[path]> id:<[target]>
#         - define result:<yaml[<[target]>].read[info.character_name]>
#         - yaml unload id:<[target]>
#         - determine <[result]>

# Description:
#     type: command
#     name: description
#     description: Set and manage your character<&sq>s description.
#     usage: /description set|add <&lt>Your Description<&gt>
#     aliases: /d
#     script:
#         - if !<player.has_flag[CurrentCharacter]>:
#             - narrate "You do not have a current character! Set this up first!" format:CharacterFormat
#         - define rawArgs:<context.args>
#         - define id:<player.flag[CurrentCharacter]>
#         - if <[rawArgs].size> == 1:
#             - define command:<[rawArgs].get[1]>
#             - if <[command]> == read:
#                 - yaml "load:/CharacterSheets/<player.uuid>/<[id]>.yml" id:<[id]>
#                 - narrate "<yaml[<[id]>].read[Description.Text]>"
#                 - yaml unload id:<[id]>
#             - else:
#                 - narrate "Descriptions<&co> Use <&a>/description set<&f> or <&a>/description add." format:CharacterFormat
#                 - narrate "Descriptions<&co> To view another player<&sq>s description, right click them!" format:CharacterFormat
#             - stop
#         - if <[rawArgs].size> == 3:
#             - define command:<[rawArgs].get[1]>
#             - define text:<[rawArgs].get[2]>
#             - yaml "load:/CharacterSheets/<player.uuid>/<[id]>.yml" id:<[id]>
#             - if <[command]> == set:
#                 - yaml id:<[id]> set Description.Text:<[text]>
#             - if <[command]> == add:
#                 - yaml id:<[id]> set "Description.Text:<yaml[<[id]>].read[Description.Text]> <[text]>"
#             - yaml "savefile:/CharacterSheets/<player.uuid>/<[id]>.yml" id:<[id]>
#             - yaml unload id:<[id]>
#             - stop
#         - narrate "Descriptions<&co> Use <&a>/description set<&f> or <&a>/description add." format:CharacterFormat
#         - narrate "Descriptions<&co> To view another player<&sq>s description, shift-right click them!" format:CharacterFormat
CharacterDescAdd:
    type: task
    debug: false
    script:
        - define text:<context.args.get[3].to[<context.args.size>].space_separated||null>
        - define id:<player.flag[CurrentCharacter]>
        - ~yaml "load:/CharacterSheets/<player.uuid>/<[id]>.yml" id:<[id]>
        - yaml id:<[id]> set "Description.Text:<yaml[<[id]>].read[Description.Text]> <[text]>"
        - ~yaml "savefile:/CharacterSheets/<player.uuid>/<[id]>.yml" id:<[id]>
        - yaml unload id:<[id]>
        - narrate "Your description has been updated." format:CharacterFormat
CharacterDescSet:
    type: task
    debug: false
    script:
        - define text:<context.args.get[3].to[<context.args.size>].space_separated||null>
        - define id:<player.flag[CurrentCharacter]>
        - ~yaml "load:/CharacterSheets/<player.uuid>/<[id]>.yml" id:<[id]>
        - yaml id:<[id]> set "Description.Text:<[text]>"
        - ~yaml "savefile:/CharacterSheets/<player.uuid>/<[id]>.yml" id:<[id]>
        - yaml unload id:<[id]>
        - narrate "Your description has been set." format:CharacterFormat
CharacterDescRead:
    type: task
    debug: false
    script:
        - define id:<player.flag[CurrentCharacter]>
        - ~yaml "load:/CharacterSheets/<player.uuid>/<[id]>.yml" id:<[id]>
        - narrate "<yaml[<[id]>].read[Description.Text]>"
        - yaml unload id:<[id]>