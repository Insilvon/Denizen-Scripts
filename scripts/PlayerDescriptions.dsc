# Player Descriptions
# Made and designed for AETHERIA
# @author Insilvon
# @version 1.0.1
# Allows players to create and save descriptions of their character for others to view

# You should only run this when the player creates a new character
CharacterSheetFolderSetup:
  type: task
  script:
    - if !<server.has_file[/CharacterSheets/<player.uuid>/<player.name.display>.yml]>:
      - define id:<player.name.display>
      - yaml create id:<[id]>
      - yaml "savefile:/CharacterSheets/<[id]>.yml" id:<[id]>
      - yaml "load:/CharacterSheets/<[id]>.yml" id:<[id]>
      # Script Info
      - yaml id:<[id]> set Script.Version:0.0.2
      # Info
      - yaml id:<[id]> set Info.Name:<[id]>
      # SkillAPI
      # Description
      - yaml id:<[id]> set Description.text:""
      # Faction
      - yaml id:<[id]> set Faction.Name
      # Renown
      - yaml id:<[id]> set Renown.ChildrenOfTheSun:0
      - yaml id:<[id]> set Renown.Skyborne:0
      - yaml id:<[id]> set Renown.Outsiders:0
      # Flags
      - foreach <player.list_flags> as:flag:
        - yaml id:<[id]> set Flags.<[flag]>:<player.flag[<[flag]>]>
      # Bounties ?
      # Town
      # Wayshrine ?
      # Titles ?
      # Achievements ?
      - yaml "savefile:/CharacterSheets/<player.uuid>/<[id]>.yml" id:<[id]>
      - yaml unload id:<[id]>
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
    # on player joins:
    #   - wait 0.1s
    #   - execute as_server "broadcast <player.name.display>"
    #   - if !<server.has_file[/CharacterSheets/<player.uuid>.yml]>:
    #     - yaml create id:<player.uuid>
    #     - yaml "savefile:/CharacterSheets/<player.uuid>.yml" id:<player.uuid>
    #     - yaml "load:/CharacterSheets/<player.uuid>.yml" id:<player.uuid>
    #     - yaml id:<player.uuid> set script.version:0.0.1
    #     - yaml id:<player.uuid> set info.username:<player.name>
    #     - yaml id:<player.uuid> set info.uuid:<player.uuid>
    #     - yaml id:<player.uuid> set info.character_name:<player.name.display>
    #     - yaml id:<player.uuid> set info.description:""
    #     - yaml id:<player.uuid> set title.current_title:"Newcomer"
    #     - yaml id:<player.uuid> set title.earned:""
    #     - yaml id:<player.uuid> set reputation.faction1:""
    #     - yaml id:<player.uuid> set reputation.faction2:""
    #     - yaml id:<player.uuid> set reputation.faction3:""
    #     - yaml id:<player.uuid> set flags.list:""
    #     - yaml id:<player.uuid> set achievements.last_wayshrine:""
    #     - yaml id:<player.uuid> set quests.completedquests:0
    #     - yaml "savefile:/CharacterSheets/<player.uuid>.yml" id:<player.uuid>
    #     - yaml unload id:<player.uuid>
    #   - else:
    #     - yaml "load:/CharacterSheets/<player.uuid>.yml" id:<player.uuid>
    #     - flag player faction1:
    #     - flag player faction2:
    #     - flag player faction3:
    on player right clicks player:
    - yaml "load:/CharacterSheets/<context.entity.uuid>.yml" id:<context.entity.uuid>
    - narrate "<yaml[<context.entity.uuid>].read[description.text]>"
    - yaml unload id:<context.entity.uuid>

# When a player saves their game at a wayshrine, Denizen will save the location in the event that
# Regular Respawning doesn't work
WayshrineSave:
  type: task
  script:
    - yaml "load:/CharacterSheets/<player.uuid>.yml" id:<player.uuid>
    - yaml id:<player.uuid> set achievements.last_wayshrine:<player.location>
    - yaml "savefile:/CharacterSheets/<player.uuid>.yml" id:<player.uuid>
    - yaml unload id:<player.uuid>

# Description Related Commands
DescHelp:
  type: command
  name: deschelp
  description: How to use Descriptions.
  usage: /deschelp
  aliases:
  - dhelp
  - DescHelp
  script:
  - narrate "<&a>Use /dset <Your Description Here> to set your description."
  - narrate "<&a>Use /dread to see your current description."
  - narrate "<&a>Right click another player to see their description."
DescriptionSet:
  type: command
  name: descset
  description: Sets your description.
  usage: /descset <&lt>myArg1<&gt>
  aliases:
  - dset
  - DescSet
  - descset
  script:
  - yaml "load:/CharacterSheets/<player.uuid>.yml" id:<player.uuid>
  - yaml id:<player.uuid> set description.text:<context.raw_args>
  - yaml "savefile:/CharacterSheets/<player.uuid>.yml" id:<player.uuid>
  - yaml unload id:<player.uuid>
DescriptionRead:
  type: command
  name: descread
  description: Reads your current description.
  usage: /descread
  aliases:
  - dread
  - descread
  - DescRead
  script:
  - yaml "load:/CharacterSheets/<player.uuid>.yml" id:<player.uuid>
  - narrate "<yaml[<player.uuid>].read[description.text]>"
  - yaml unload id:<player.uuid>
