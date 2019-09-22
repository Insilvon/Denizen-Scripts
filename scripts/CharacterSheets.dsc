# Character Sheets
# Made and designed for AETHERIA
# @author Insilvon
# @version 1.0.5
# Allows players to create and save descriptions of their character for others to view

# You should only run this when the player creates a new character
# CharacterSheetFolderSetup:
#   type: task
#   script:
#     - if !<player.has_flag[CurrentCharacter]>:
#       - narrate "You are not currently playing a character! Is this an issue?"
#       - stop
#     - if !<server.has_file[/CharacterSheets/<player.uuid>/<player.flag[CurrentCharacter]>.yml]>:
#       - define id:<player.flag[CurrentCharacter]>
#       - yaml create id:<[id]>
#       - ~yaml "savefile:/CharacterSheets/<player.uuid>/<[id]>.yml" id:<[id]>
#       - ~yaml "load:/CharacterSheets/<player.uuid>/<[id]>.yml" id:<[id]>
#       # Script Info
#       - ~yaml id:<[id]> set Script.Version:0.0.2
#       # Info
#       - ~yaml id:<[id]> set Info.Name:<[id]>
#       # SkillAPI
#       # Description
#       - ~yaml id:<[id]> set Description.Text:""
#       # Faction
#       - ~yaml id:<[id]> set Faction.Name:""
#       # Town
#       - ~yaml id:<[id]> set Town.Name:""
#       # Renown
#       - ~yaml id:<[id]> set Renown.ChildrenOfTheSun:0
#       - ~yaml id:<[id]> set Renown.Skyborne:0
#       - ~yaml id:<[id]> set Renown.Outsiders:0
#       # Flags
#       - foreach <player.list_flags> as:flag:
#         - yaml id:<[id]> set Flags.<[flag]>:<player.flag[<[flag]>]>
#       # Bounties ?
#       # Town
#       # Wayshrine ?
#       # Titles ?
#       # Achievements ?
#       - ~yaml "savefile:/CharacterSheets/<player.uuid>/<[id]>.yml" id:<[id]>
#       - yaml unload id:<[id]>

YAMLScript:
  type: world
  events:
    on player logs in:
      - wait 1s
      - inject CharacterSheetFolderSetup
      - if !<player.has_flag[questjournal]>:
        - note in@QuestJournalMenu as:<player.uuid>questjournal
        - note in@QuestCompleteMenu as:<player.uuid>completedquests
        - flag player questjournal
    on player right clicks player:
    - yaml "load:/CharacterSheets/<context.entity.uuid>/<context.entity.flag[CurrentCharacter]>.yml" id:<context.entity.flag[CurrentCharacter]>
    - narrate "<yaml[<context.entity.flag[CurrentCharacter]>].read[Description.Text]>"
    - yaml unload id:<context.entity.flag[CurrentCharacter]>

# When a player saves their game at a wayshrine, Denizen will save the location in the event that
# Regular Respawning doesn't work
#TODO:// UPDATE WAYSHRINE SYSTEM
# WayshrineSave:
#   type: task
#   script:
#     - yaml "load:/CharacterSheets/<player.uuid>.yml" id:<player.uuid>
#     - yaml id:<player.uuid> set achievements.last_wayshrine:<player.location>
#     - yaml "savefile:/CharacterSheets/<player.uuid>.yml" id:<player.uuid>
#     - yaml unload id:<player.uuid>

# Description Related Commands
Description:
  type: command
  name: description
  description: Set and manage your character<&sq>s description.
  usage: /description set|add <&lt>Your Description<&gt>
  aliases: /d
  script:
    - if !<player.has_flag[CurrentCharacter]>:
      - narrate "You do not have a current character! Set this up first!"
    - define rawArgs:<context.args>
    - define id:<player.flag[CurrentCharacter]>
    - if <[rawArgs].size> == 1:
      - define command:<[rawArgs].get[1]>
      - if <[command]> == read:
        - yaml "load:/CharacterSheets/<player.uuid>/<[id]>.yml" id:<[id]>
        - narrate "<yaml[<[id]>].read[Description.Text]>"
        - yaml unload id:<[id]>
      - else:
        - narrate "Descriptions<&co> Use <&a>/description set<&f> or <&a>/description add."
        - narrate "Descriptions<&co> To view another player<&sq>s description, right click them!"
      - stop
    - if <[rawArgs].size> == 3:
      - define command:<[rawArgs].get[1]>
      - define text:<[rawArgs].get[2]>
      - yaml "load:/CharacterSheets/<player.uuid>/<[id]>.yml" id:<[id]>
      - if <[command]> == set:
        - yaml id:<[id]> set Description.Text:<[text]>
      - if <[command]> == add:
        - yaml id:<[id]> set "Description.Text:<yaml[<[id]>].read[Description.Text]> <[text]>"
      - yaml "savefile:/CharacterSheets/<player.uuid>/<[id]>.yml" id:<[id]>
      - yaml unload id:<[id]>
      - stop
    - narrate "Descriptions<&co> Use <&a>/description set<&f> or <&a>/description add."
    - narrate "Descriptions<&co> To view another player<&sq>s description, right click them!"