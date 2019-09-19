# Player Character Controller Proof of Concept
# Made and designed for AETHERIA
# @author Insilvon
# @version 2.0.1
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
  usage: /character select|reset|swap
  script:
    - define args:<context.args>
    - if <[args].size> == 1:
      - foreach select|reset as:switch:
        - if <[args].get[1]> == <[switch]>:
          - inject Character<[switch]>
    - if <[args].size> == 2:
      - foreach create|swap as:switch:
        - if <[args].get[1]> == <[switch]>:
          - inject Character<[switch]>
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
        - narrate "<&b>[Characters] - Swap to your character with /sc number"
        - flag player Character:+:1
        - define newFile:/CharacterSheets/<player.uuid>/<player.flag[Character]>.yml
        - define newID:<player.flag[Character]>
        - yaml create id:<[newID]>
        - yaml savefile:<[newFile]> id:<[newID]>
        - yaml load:<[newFile]> id:<[newID]>
        - yaml id:<[newID]> set info.username:<player.name>
        - yaml id:<[newID]> set info.character_name:<[args].get[2]>
        - yaml id:<[newID]> set info.character_location:<player.location>
        - yaml savefile:<[newFile]> id:<[newID]>
        - yaml unload id:<[newID]>
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
    - define arg:<context.args.get[2]>
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
        - yaml load:/CharacterSheets/<player.uuid>/<player.flag[CurrentCharacter]>.yml id:<player.flag[CurrentCharacter]>
        - teleport <player> <yaml[<player.flag[CurrentCharacter]>].read[<info.character_location>]>
        - yaml unload id:<player.flag[CurrentCharacter]>
        - inventory clear d:<player.inventory>
        - inventory set d:<player.inventory> o:in@<player.uuid>_<player.flag[CurrentCharacter]>
        - adjust <player> 'equipment:<player.flag[e_<player.flag[CurrentCharacter]>]>'
    - stop

# Helper script for Character Swap
CharacterFetch:
  type: procedure
  definitions: path|target
  script:
    - yaml load:<[path]> id:<[target]>
    - determine <yaml[<[target]>].read[info.character_name]>