# Radiant Quests
# Made and designed for AETHERIA
# @author Insilvon
# @version 1.0.0
# Proof of Concept for Radiant/Dynamic Quests

# All things Radiant Quests
# TYPES: Fetch, Investigate, Deliver, Kill, Capture
#
QuestController:
  type: world
  events:
    on player left clicks queststatsi in inventory:
      - inventory close
      - wait 3
      - inventory open d:in@<player>completedquests
      - queue clear
    on player left clicks completedquestsi in inventory:
      - inventory close
      - inventory open d:in@<player>completedquests
    on player left clicks completedquestsi2 in inventory:
      - inventory close
      - inventory open d:in@<player>completedquests2
    on player left clicks completedquestsi3 in inventory:
      - inventory close
      - inventory open d:in@<player>completedquests3
    on player left clicks activequestsi in inventory:
      - inventory close
      - inventory open d:in@<player>questjournal
    on player logs in:
      - if !<player.has_flag[questjournal]>:
        - note in@QuestJournalMenu as:<player>questjournal
        - note in@QuestCompleteMenu2 as:<player>completedquests2
        - note in@QuestCompleteMenu3 as:<player>completedquests3
        - note in@QuestCompleteMenu as:<player>completedquests
        - flag player questjournal
# Command Script to show the Quest Journal

questlog:
  type: command
  name: questlog
  usage: /questlog
  script:
    - if !<player.has_flag[questjournal]>:
        - note in@QuestJournalMenu as:<player>questjournal
        - note in@QuestCompleteMenu2 as:<player>completedquests2
        - note in@QuestCompleteMenu3 as:<player>completedquests3
        - note in@QuestCompleteMenu as:<player>completedquests
        - flag player questjournal
    - inventory open d:in@<player>questjournal

# Inventory Which displays the first round of completed quests

QuestCompleteMenu:
  type: inventory
  title: Completed Quests
  size: 45
  slots:
  - "[] [] [] [] [] [] [] [] []"
  - "[] [] [] [] [] [] [] [] []"
  - "[] [] [] [] [] [] [] [] []"
  - "[] [] [] [] [] [] [] [] []"
  - "[] [] [] [] [] [] [i@completedquestsi2] [i@queststatsi] [i@activequestsi]"

# Inventory which shows the second round of completed quests

QuestCompleteMenu2:
  type: inventory
  title: Completed Quests Page 2
  size: 45
  slots:
  - "[] [] [] [] [] [] [] [] []"
  - "[] [] [] [] [] [] [] [] []"
  - "[] [] [] [] [] [] [] [] []"
  - "[] [] [] [] [] [] [] [] []"
  - "[] [] [] [] [] [] [i@completedquestsi3] [i@queststatsi] [i@activequestsi]"

# Inventory which shows the third round of completed quests

QuestCompleteMenu3:
  type: inventory
  title: Completed Quests Page 3
  size: 45
  slots:
  - "[] [] [] [] [] [] [] [] []"
  - "[] [] [] [] [] [] [] [] []"
  - "[] [] [] [] [] [] [] [] []"
  - "[] [] [] [] [] [] [] [] []"
  - "[] [] [] [] [] [] [i@completedquestsi] [i@queststatsi] [i@activequestsi]"

# Inventory which shows currently active quests

QuestJournalMenu:
  type: inventory
  title: Active Quests
  size: 45
  slots:
  - "[] [] [] [] [] [] [] [] []"
  - "[] [] [] [] [] [] [] [] []"
  - "[] [] [] [] [] [] [] [] []"
  - "[] [] [] [] [] [] [] [] []"
  - "[] [] [] [] [] [] [] [] [i@completedquestsi]"

# Preview Item for Completed Quests 1
completedquestsi:
  type: item
  material: book
  display name: Quest Stats
  lore:
  - "Click here to view your completed quests."

# Preview Item for Quests Stats

queststatsi:
  type: item
  material: book
  display name: Quest Stats
  lore:
  - "Click here to view your quest stats."

# Preview Item for Active Quests

activequestsi:
  type: item
  material: book
  display name: Active Quests.
  lore:
  - "Click here to access information."
  - "about your active quests."

# Preview Item for Completed Quests Page 2

completedquestsi2:
  type: item
  material: book
  display name: Completed Quests 2
  lore:
    - "Page 2"

# Preview Item for Completed Quests Page 3

completedquestsi3:
  type: item
  material: book
  display name: Completed Quests 3
  lore:
    - "Page 3"

# Script Which Increments the Character Sheet Statistics for Completed Quests

IncCompletedQuest:
  type: task
  script:
  - yaml "load:/CharacterSheets/<player.uuid>.yml" id:<player.uuid>
  - yaml id:<player.uuid> set quests.compeltedquests:+:1
  - yaml "savefile:/CharacterSheets/<player.uuid>.yml" id:<player.uuid>
  - yaml unload id:<player.uuid>

# Example walkthrough
QuestsExWorld:
  type: world
  events:
    on player clicks QuestsExampleMenuItem in inventory:
      - adjust <player> show_book:i@QuestsExampleBook
#      - inventory close
#      - adjust <player> show_book:QuestsExampleBook
#      - define held <player.item_in_hand>
#      - adjust <player> item_in_hand:QuestsExampleBook
#      - wait 0.1s
#      - adjust <player> open_book
 #     - adjust <player> item_in_hand:<def[held]>
 #     - queue clear
QuestsExAssignment:
  type: assignment
  on assignment:
    - chat "Assignment Set!"
  interact scripts:
  - 1 QuestsExInteract
QuestsExInteract:
  type: interact
  steps:
    1:
      chat trigger:
        1:
          trigger: /Regex:Start/
          script:
            - chat "Quest Started!"
            - inventory add d:in@<player>questjournal o:QuestsExampleMenuItem
        2:
          trigger: /Regex:Stop/
          script:
            - chat "You finished my quest!"
            - if !<in@<player>completedquests.can_fit[QuestsExampleMenuItem]>:
              - if !<in@<player>completedquests2.can_fit[QuestsExampleMenuItem]>:
                - if !<in@<player>completedquests3.can_fit[QuestsExampleMenuItem]>:
                  - narrate "[OOC:] Out of capacity! Please inform an admin that the QuestLog limit needs to be increased."
                - else:
                  - inventory add d:in@<player>completedquests3 o:QuestsExampleMenuItem
                  - inventory remove d:in@<player>questjournal o:QuestsExampleMenuItem
                  - run IncCompletedQuest
              - else:
                - inventory add d:in@<player>completedquests2 o:QuestsExampleMenuItem
                - inventory remove d:in@<player>questjournal o:QuestsExampleMenuItem
                - run IncCompletedQuest
            - else:
              - inventory add d:in@<player>completedquests o:QuestsExampleMenuItem
              - inventory remove d:in@<player>questjournal o:QuestsExampleMenuItem
              - run IncCompletedQuest

QuestsExampleBook:
  type: book
  author: Active Quest
  title: Do The things
  signed: yes
  text:
  - "Go do the thing"
QuestsExampleMenuItem:
  type: item
  material: book
  display name: Come Click Me
  lore:
    - "Click to see information"
AlchemyGuide:
  type: book
  title: "The Alchemist Guide"
  author: Kristoff Karma
  signed: true
  text:
  - <&9>The Novice Guide to Alchemical Transactions
  - To my Pupil... 
GetNewPlayerBook:
    type: command
    name: newplayerguide
    description: View the New Player Guide.
    usage: /newplayerguide
    script:
    - adjust <player> show_book:i@NewPlayerBook
NewPlayerBook:
    type: book
    title: New Player Guide
    author: Wahrheit
    signed: true
    text:
    - "Welcome to Summa Crossroads! We're glad to have you here.<p>This is a survival server with tons of custom content. Instead of trying to turn Minecraft into a different game, we've built on top of it."
    - "There are more monsters to fight, there's plenty of loot to find, and there are big, wide worlds for you to explore.<p>You'll notice the Swabby in front of you has a Quest you can pick up!"
    - "You can start out by following the main quest line, which will give you some gear to help you out, or you can just leave spawn right away.<p>When you're ready to leave, grab a boat from the docks near the spawn point and sail down the river."
    - "You can use /map to figure out where you want to go, and don't forget to /sethome frequently until you get your base started - you can use /home to warp to where you last set it."