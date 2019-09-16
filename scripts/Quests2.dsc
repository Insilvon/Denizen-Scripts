# Radiant Quests REWRITE
# Made and designed for AETHERIA
# @author Insilvon
# @version 2.0.2
# Proof of Concept for Radiant/Dynamic Quests

# All things Radiant Quests
# TYPES: Fetch, Investigate, Deliver, Kill, Capture
#
SampleBook:
    type: item
    material: book_and_quill
    display name: TestQuest
    lore:
        - Test Quest!
AddTestQuest:
    type: task
    script:
        - flag player <player.name.display>_ActiveQuestItems:->:<player.item_in_hand>
AddTestQuests:
    type: task
    script:
        - repeat 44:
            - flag player <player.name.display>_ActiveQuestItems:->:SampleBook
AddTestQuest2:
    type: task
    script:
        - flag player <player.name.display>_CompletedQuestItems:<player.item_in_hand>

QuestLog:
    type: command
    name: questlog
    usage: /questlog
    script:
        - inject QuestLoginScript
        - define questType:ActiveQuest
        - inject LoadInventory
        #- inventory open d:in@<player.name.display>_ActiveQuestMenu
# Quest Controller script - manages item clicks
QuestController:
    type: world
    events:
        on player left clicks ActiveQuestItem in inventory:
            - define questType:ActiveQuest
            - inject QuestMenuHandler
            #- inventory open d:in@<player.name.display>_ActiveQuestMenu
        on player left clicks CompletedQuestItem in inventory:
            - define questType:CompletedQuest
            - inject QuestMenuHandler
            #- inventory open d:in@<player.name.display>_CompletedQuestMenu
        on player left clicks NextPageActiveQuestItem in inventory:
            - determine cancelled passively
            - define questType:ActiveQuest
            - define direction:next
            - inject QuestChangePage
        on player left clicks NextPageCompletedQuestItem in inventory:
            - determine cancelled passively
            - define questType:CompletedQuest
            - define direction:next
            - inject QuestChangePage
        on player left clicks LastPageActiveQuestItem in inventory:
            - determine cancelled passively
            - define questType:ActiveQuest
            - inject QuestChangePage
        on player left clicks LastPageCompletedQuestItem in inventory:
            - determine cancelled passively
            - define questType:CompletedQuest
            - inject QuestChangePage
        #TODO: ADD THIS TO SERVERTASKS
        on player logs in:
            - wait 1s
            - inject QuestLoginScript
QuestMenuHandler:
    type: task
    script:
        - determine cancelled passively
        - inventory close
        - flag player <player.name.display>_QuestJournalMenu:1
        - inject LoadInventory
QuestPageHandler:
    type: task
    script:
        - determine cancelled passively
        - define direction:next
# General script to run when player clicks "next page or back"
# Will change display items based on the current set of items to display
QuestChangePage:
    type: task
    script:
        - if <[direction]> == next:
            - flag player <player.name.display>_QuestJournalMenu:++
        - else:
            - flag player <player.name.display>_QuestJournalMenu:--
        - inject LoadInventory
LoadInventory:
    type: task
    script:
        - define character:<player.name.display>
        - define itemlist:<player.flag[<[character]>_<[questType]>Items].as_list>
        - define menu:<player.flag[<[character]>_QuestJournalMenu]>
        - define end:<[menu].as_int.mul_int[42]>
        - define start:<[end].as_int.sub_int[41]>
        #- narrate "<[itemlist].size> vs <[start]> to <[end]>"
        - if <[itemlist].size> < <[start]>:
           # - narrate "list less than start"
            - flag player <player.name.display>_QuestJournalMenu:--
            - stop
        #- narrate "list greater than start"
        - define display:<[itemlist].get[<[start]>].to[<[end]>]||null>
        #- narrate "<[display]>"
        - inventory clear d:in@<[character]>_<[questType]>Menu
        #- narrate "inventory cleared"
        - foreach <[display]> as:item:
            - inventory add d:in@<[character]>_<[questType]>Menu o:<[item]>
        - if <[questType]> == ActiveQuest:
            - inventory set d:in@<[character]>_<[questType]>Menu o:CompletedQuestItem slot:43
            - inventory set d:in@<[character]>_<[questType]>Menu o:LastPageActiveQuestItem slot:44
        - else:
            - inventory set d:in@<[character]>_<[questType]>Menu o:ActiveQuestItem slot:43
            - inventory set d:in@<[character]>_<[questType]>Menu o:LastPageCompletedQuestItem slot:44
        - inventory set d:in@<[character]>_<[questType]>Menu o:NextPage<[questType]>Item slot:45
        - inventory close
        - inventory open d:in@<[character]>_<[questType]>Menu
# Relies on General World Event, so written as own task
QuestLoginScript:
    type: task
    script:
        - define character:<player.name.display>
        - if !<player.has_flag[<[character]>_QuestJournal]>:
            - note in@QuestJournalActiveQuests as:<[character]>_ActiveQuestMenu
            - note in@QuestJournalCompletedQuests as:<[character]>_CompletedQuestMenu
            - flag player <[character]>_QuestJournal
            - flag player <[character]>_ActiveQuestItems:null
            - flag player <[character]>_CompletedQuestItems:null
        - flag player <[character]>_QuestJournalMenu:1

# Item in inventory to load Active Quest Menu
ActiveQuestItem:
    type: item
    material: book
    display name: Active Quests
    lore:
        - "Show Active Quests"
# Item to show next Active Quest page
NextPageActiveQuestItem:
    type: item
    material: player_head[skull_skin=23b3f9dc-f02c-4ea8-a949-dbd56b03602c|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNGVmMzU2YWQyYWE3YjE2NzhhZWNiODgyOTBlNWZhNWEzNDI3ZTVlNDU2ZmY0MmZiNTE1NjkwYzY3NTE3YjgifX19]
    display name: Next Page
LastPageActiveQuestItem:
    type: item
    material: player_head[skull_skin=1226610a-b7f8-47e5-a15d-126c4ef18635|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZjg0ZjU5NzEzMWJiZTI1ZGMwNThhZjg4OGNiMjk4MzFmNzk1OTliYzY3Yzk1YzgwMjkyNWNlNGFmYmEzMzJmYyJ9fX0=]
    display name: Back
# Item to show next Completed Quest page
NextPageCompletedQuestItem:
    type: item
    material: player_head[skull_skin=23b3f9dc-f02c-4ea8-a949-dbd56b03602c|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNGVmMzU2YWQyYWE3YjE2NzhhZWNiODgyOTBlNWZhNWEzNDI3ZTVlNDU2ZmY0MmZiNTE1NjkwYzY3NTE3YjgifX19]
    display name: Next Page
LastPageCompletedQuestItem:
    type: item
    material: player_head[skull_skin=1226610a-b7f8-47e5-a15d-126c4ef18635|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZjg0ZjU5NzEzMWJiZTI1ZGMwNThhZjg4OGNiMjk4MzFmNzk1OTliYzY3Yzk1YzgwMjkyNWNlNGFmYmEzMzJmYyJ9fX0=]
    display name: Back
# Item in inventory to load Completed Quest Menu
CompletedQuestItem:
    type: item
    material: book
    display name: Completed Quests
    lore:
        - "Show Completed Quests"
# Menu template which shows active quests
QuestJournalActiveQuests:
    type: inventory
    title: Active Quests
    size: 45
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [i@CompletedQuestItem] [i@LastPageActiveQuestItem] [i@NextPageActiveQuestItem]"
# Menu template which shows compelted quests
QuestJournalCompletedQuests:
    type: inventory
    title: Completed Quests
    size: 45
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [i@ActiveQuestItem] [i@LastPageCompletedQuestItem] [i@NextPageCompletedQuestItem]"