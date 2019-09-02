YAMLScript:
  type: world
  events:
    on player logs in:
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
