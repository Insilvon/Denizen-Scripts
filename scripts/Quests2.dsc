# Radiant Quests REWRITE
# Made and designed for AETHERIA
# @author Insilvon
# @version 2.0.1
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
            - determine cancelled passively
            - inventory close
            - flag player <player.name.display>_QuestJournalMenu:1
            - define questType:ActiveQuest
            - inject LoadInventory
            #- inventory open d:in@<player.name.display>_ActiveQuestMenu
        on player left clicks CompletedQuestItem in inventory:
            - determine cancelled passively
            - inventory close
            - flag player <player.name.display>_QuestJournalMenu:1
            - define questType:CompletedQuest
            - inject LoadInventory
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
        - define end:<[menu].as_int.mul_int[43]>
        - define start:<[end].as_int.sub_int[42]>
        - narrate "<[itemlist].size> vs <[start]> to <[end]>"
        - if <[itemlist].size> < <[start]>:
            - narrate "list less than start"
            - flag player <player.name.display>_QuestJournalMenu:--
            - stop
        - narrate "list greater than start"
        - define display:<[itemlist].get[<[start]>].to[<[end]>]||null>
        - narrate "<[display]>"
        - inventory clear d:in@<[character]>_<[questType]>Menu
        - narrate "inventory cleared"
        - foreach <[display]> as:item:
            - inventory add d:in@<[character]>_<[questType]>Menu o:<[item]>
        - if <[questType]> == ActiveQuest:
            - inventory set d:in@<[character]>_<[questType]>Menu o:CompletedQuestItem slot:44
        - else:
            - inventory set d:in@<[character]>_<[questType]>Menu o:ActiveQuestItem slot:44
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
    material: book
    display name: Next Page
LastPageActiveQuestItem:
    type: item
    material: book
    display name: Back
# Item to show next Completed Quest page
NextPageCompletedQuestItem:
    type: item
    material: book
    display name: Next Page
LastPageCompletedQuestItem:
    type: item
    material: book
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
    - "[] [] [] [] [] [] [] [i@CompletedQuestItem] [i@NextPageActiveQuestItem]"
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
    - "[] [] [] [] [] [] [] [i@ActiveQuestItem] [i@NextPageCompletedQuestItem]"