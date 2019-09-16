# Player Character Controller Proof of Concept
# Made and designed for AETHERIA
# @author Insilvon
# @version 1.0.0
# Allows players to create and save data between multiple "characters" on one account

# Current Flags: Character (# of Chars), Character List, Equipment flags (e_id)
# Character GUI

PlayerController:
  type: world
  events:
    on player joins:
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
    on player clicks player_head in inventory:
      - if <context.item.lore.contains[$*@*$]>:
        - determine passively cancelled
        - define arg:<context.raw_slot>
        - define path:/CharacterSheets/<player.uuid>/<[arg]>.yml
        - if <player.flag[Character]> >= 1:
          - if <server.has_file[/CharacterSheets/<player.uuid>/<context.raw_slot>.yml]>:
            # TODO: Fix the proc
            - if <player.has_flag[CurrentCharacter]>:
              - yaml load:/CharacterSheets/<player.uuid>/<player.flag[CurrentCharacter]>.yml id:<player.flag[CurrentCharacter]>
              - yaml id:<player.flag[CurrentCharacter]> set info.character_location:<player.location>
              - yaml savefile:/CharacterSheets/<player.uuid>/<player.flag[CurrentCharacter]>.yml id:<player.flag[CurrentCharacter]>
              - yaml unload id:<player.flag[CurrentCharacter]>
              - note <player.inventory> as:<player.uuid>_<player.flag[CurrentCharacter]>
              - narrate "<&b>[Characters] - Inventory Saved!"
              - flag <player> e_<player.flag[CurrentCharacter]>:<player.equipment>
            - define character_name:<proc[CharacterFetch].context[<[path]>|<context.raw_slot>]>
            - execute as_server "nickname <player.name> <[character_name]>"
            - narrate "<&b>[Characters] - You are now <[character_name]>"
            - flag player CurrentCharacter:<context.raw_slot>
            - yaml load:/CharacterSheets/<player.uuid>/<player.flag[CurrentCharacter]>.yml id:<player.flag[CurrentCharacter]>
            - teleport <player> <yaml[<player.flag[CurrentCharacter]>].read[<info.character_location>]>
            - yaml unload id:<player.flag[CurrentCharacter]>
            - inventory clear d:<player.inventory>
            - inventory set d:<player.inventory> o:in@<player.uuid>_<player.flag[CurrentCharacter]>
            - adjust <player> 'equipment:<player.flag[e_<player.flag[CurrentCharacter]>]>'


CharacterGUIMenu:
  type: inventory
  title: Character Select
  size: 9
  slots:
  - "[] [] [] [] [] [] [] [] []"

CharacterSelect:
  type: command
  name: CharacterSelect
  description: ""
  usage: /CharacterSelect
  aliases:
    - cselect
  script:
    - inventory open d:in@<player.uuid>_GUI

CharacterReset:
  type: command
  name: CharacterReset
  description: ""
  usage: /characterreset
  aliases:
    - creset
  script:
    - flag player Character:0
    - flag player Character_List:!
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
    - inventory clear d:in@<player.uuid>_GUI

CreateCharacter:
  type: command
  name: CreateCharacter
  description: ""
  usage: /CreateCharacter
  aliases:
    - ccreate
  script:
    - define path:/CharacterSheets/<player.uuid>/
    - if !<server.has_file[/CharacterSheets/<player.uuid>/base.yml]>:
      - narrate "You are lacking crucial backend files. Please message an admin."
    - else:
      - yaml load:<[path]>base.yml id:base
      - define limit:<yaml[base].read[permissions.character_limit]>
      - if <player.flag[Character]> < <[limit]>:
        - narrate "<&b>[Characters] - You have successfully created a new character with the name <context.args.get[0]>"
        - narrate "<&b>[Characters] - Swap to your character with /sc number"
        - flag player Character:+:1
        - define newFile:/CharacterSheets/<player.uuid>/<player.flag[Character]>.yml
        - define newID:<player.flag[Character]>
        - yaml create id:<[newID]>
        - yaml savefile:<[newFile]> id:<[newID]>
        - yaml load:<[newFile]> id:<[newID]>
        - yaml id:<[newID]> set info.username:<player.name>
        - yaml id:<[newID]> set info.character_name:<context.args.get[0]>
        - yaml id:<[newID]> set info.character_location:<player.location>
        - yaml savefile:<[newFile]> id:<[newID]>
        - yaml unload id:<[newID]>
        - if !<player.has_flag[Character_List]>:
          - flag player Character_List:<context.args.get[0]>
        - else:
          - flag player Character_List:->:<context.args.get[0]>
        - note "i@player_head[display_name=<context.args.get[0]>;lore=$*@*$]" as:<player.uuid>_head<player.flag[Character]>
        - inventory add d:in@<player.uuid>_GUI o:i@<player.uuid>_head<player.flag[Character]>
      - else:
        - narrate "<&b>[Characters] - You have reached your maximum amount of characters."
        - narrate "<&b>[Characters] - Is this an error?"

SwapCharacter:
  type: command
  name: SwapCharacter
  speed: 1t
  description: swap your current character
  usage: /SwapCharacter <&lt>index<&gt>
  aliases:
    - cswap
  script:
    - define arg:<context.args.get[0]>
    - define path:/CharacterSheets/<player.uuid>/<[arg]>.yml
    - if <player.flag[Character]> >= 1:
      - if <server.has_file[/CharacterSheets/<player.uuid>/<context.args.get[0]>.yml]>:
        # TODO: Fix the proc
        - if <player.has_flag[CurrentCharacter]>:
          - yaml load:/CharacterSheets/<player.uuid>/<player.flag[CurrentCharacter]>.yml id:<player.flag[CurrentCharacter]>
          - yaml id:<player.flag[CurrentCharacter]> set info.character_location:<player.location>
          - yaml savefile:/CharacterSheets/<player.uuid>/<player.flag[CurrentCharacter]>.yml id:<player.flag[CurrentCharacter]>
          - yaml unload id:<player.flag[CurrentCharacter]>
          - note <player.inventory> as:<player.uuid>_<player.flag[CurrentCharacter]>
          - narrate "<&b>[Characters] - Inventory Saved!"
          - flag <player> e_<player.flag[CurrentCharacter]>:<player.equipment>
        - define character_name:<proc[CharacterFetch].context[<[path]>|<[arg]>]>
        - execute as_server "nickname <player.name> <[character_name]>"
        - narrate "<&b>[Characters] - You are now <[character_name]>"
        - flag player CurrentCharacter:<context.args.get[0]>
        - yaml load:/CharacterSheets/<player.uuid>/<player.flag[CurrentCharacter]>.yml id:<player.flag[CurrentCharacter]>
        - teleport <player> <yaml[<player.flag[CurrentCharacter]>].read[<info.character_location>]>
        - yaml unload id:<player.flag[CurrentCharacter]>
        - inventory clear d:<player.inventory>
        - inventory set d:<player.inventory> o:in@<player.uuid>_<player.flag[CurrentCharacter]>
        - adjust <player> 'equipment:<player.flag[e_<player.flag[CurrentCharacter]>]>'
SwapTask:
  type: task
  script:

CharacterFetch:
  type: procedure
  definitions: path|target
  script:
    - yaml load:<[path]> id:<[target]>
    - determine <yaml[<[target]>].read[info.character_name]>
