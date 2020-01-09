# Radiant Quests REWRITE 2
# Made and designed for AETHERIA
# @author Insilvon
# @version 3.0.5
# Proof of Concept for Radiant/Dynamic Quests

# All things Radiant Quests
# TYPES: Fetch, Investigate, Deliver, Kill, Capture

# =================================================================================
# ================================= Main Commands =================================
# =================================================================================

# Main Quest Command Handler
QuestLog:
    type: command
    name: questlog
    usage: /questlog
    script:
        - inject QuestLoginScript
        - define questType:ActiveQuest
        - inject LoadInventory

# Player Clicks in inventory event
QuestOnPlayerClicksInInventory:
    type: task
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - if <context.inventory> == in@<[character]>_CompletedQuestMenu:
            - if <context.click> == RIGHT:
                - if <player.has_flag[QuestBookReceived]>:
                    - narrate "You must wait <player.flag[QuestBookReceived].expiration.formatted> before getting another physical copy."
                    - determine cancelled
                - else:
                    - flag player QuestBookReceived d:20h
                    - give <context.item>
                    - determine cancelled
            - else:
                - adjust <player> show_book:<context.item>
                - determine cancelled
        - if <context.inventory> == in@<[character]>_ActiveQuestMenu:
            - if <context.click> == LEFT:
                - adjust <player> show_book:<context.item>
                - determine cancelled
            - else:
                - determine cancelled
# Drop Clicks event
QuestOnPlayerDropClicksInInventory:
    type: task
    script:
        - if <context.inventory> == in@<[character]>_ActiveQuestMenu || <context.inventory> == in@<[character]>_CompletedQuestMenu:
            - determine cancelled

# Control Click
QuestOnPlayerControlClicksInInventory:
    type: task
    script:
        - if <context.inventory> == in@<[character]>_ActiveQuestMenu || <context.inventory> == in@<[character]>_CompletedQuestMenu:
            - determine cancelled

QuestOnPlayerLogin:
    type: task
    script:
        - wait 1s
        - inject QuestLoginScript

# =================================================================================
# ============================== Manager Scripts ==================================
# =================================================================================

# Will remove the given item from the Character's Active Quest Menu
RemoveActiveQuest:
    type: task
    definitions: player|item
    script:
        - define character:<proc[GetCharacterName].context[<[player]>]>
        - if <player.flag[<[character]>_ActiveQuestItems].size> == 1:
            - if <player.flag[<[character]>_ActiveQuestItems]> == <[item]>:
                - flag player <[character]>_ActiveQuestItems:!
            - else:
                - stop
        - else:
            - flag <[player]> <[character]>_ActiveQuestItems:<player.flag[<[character]>_ActiveQuestItems].exclude[<[item]>]>

# Will add the specified item to the character's active quest menu
AddActiveQuest:
    type: task
    definitions: player|item
    script:
        - flag player <proc[GetCharacterName].context[<[player]>]>_ActiveQuestItems:->:<[item]>
        - title "title: <gold>*QUESTS*" "subtitle:<gold>Your questlog has been updated."

# Will add the specified item to the character's completed quest menu
AddCompletedQuest:
    type: task
    definitions: player|item
    script:
        - flag player <proc[GetCharacterName].context[<[player]>]>_CompletedQuestItems:->:<[item]>
        - title "title: <gold>*QUESTS*" "subtitle:<gold>Your questlog has been updated."
# =================================================================================
# ================================ Helper Scripts =================================
# =================================================================================
        
# Will reset all flags associated with this character's base quest structure
QuestReset:
    type: task
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - narrate "<&e>[Quests] - Removing data for character <[character]>"
        - flag player <[character]>_QuestJournal:!
        - note remove as:<[character]>_ActiveQuestMenu
        - note remove as:<[character]>_CompletedQuestMenu
        - flag player <[character]>_QuestJournal:!
        - flag player <[character]>_ActiveQuestItems:!
        - flag player <[character]>_CompletedQuestItems:!
        - flag player <[character]>_QuestJournalMenu:!

# Helper script - sets up menu switching
QuestMenuHandler:
    type: task
    definitions: questType
    script:
        - determine cancelled passively
        - inventory close
        - flag player <proc[GetCharacterName].context[<player>]>_QuestJournalMenu:1
        - inject LoadInventory

# Helper script - sets up next page
QuestPageHandler:
    type: task
    definitions: questType|direction
    script:
        - determine cancelled passively
        - inject QuestChangePage

# General script to run when player clicks "next page or back"
# Will change display items based on the current set of items to display
QuestChangePage:
    type: task
    script:
        - if <[direction]> == next:
            - flag player <proc[GetCharacterName].context[<player>]>_QuestJournalMenu:++
        - else:
            - flag player <proc[GetCharacterName].context[<player>]>_QuestJournalMenu:--
        - inject LoadInventory

# Main Inventory Loader, used as Injection for QuestChangePage
LoadInventory:
    type: task
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - define menu:<player.flag[<[character]>_QuestJournalMenu]>
        - define end:<[menu].as_int.mul_int[42]>
        - define start:<[end].as_int.sub_int[41]>
        - define catch:li@
        - inventory clear d:in@<[character]>_<[questType]>Menu
        - if <player.flag[<[character]>_<[questType]>Items]> != <[catch]> && <player.has_flag[<[character]>_<[questType]>Items]>:
            - if <player.flag[<[character]>_<[questType]>Items].size> < <[start]>:
                - flag player <proc[GetCharacterName].context[<player>]>_QuestJournalMenu:--
                - stop
            - define display:<player.flag[<[character]>_<[questType]>Items].get[<[start]>].to[<[end]>]>
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
        - define character:<proc[GetCharacterName].context[<player>]||null>
        - if <[character]> == null:
            - narrate "You need a character for this"
            - stop
        - if !<player.has_flag[<[character]>_QuestJournal]>:
            - note in@QuestJournalActiveQuests as:<[character]>_ActiveQuestMenu
            - note in@QuestJournalCompletedQuests as:<[character]>_CompletedQuestMenu
            - flag player <[character]>_QuestJournal
        - flag player <[character]>_QuestJournalMenu:1

# =================================================================================
# =============================== Items/Inventories ===============================
# =================================================================================
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

# Item to show last Active Quest page
LastPageActiveQuestItem:
    type: item
    material: player_head[skull_skin=1226610a-b7f8-47e5-a15d-126c4ef18635|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZjg0ZjU5NzEzMWJiZTI1ZGMwNThhZjg4OGNiMjk4MzFmNzk1OTliYzY3Yzk1YzgwMjkyNWNlNGFmYmEzMzJmYyJ9fX0=]
    display name: Back

# Item to show next Completed Quest page
NextPageCompletedQuestItem:
    type: item
    material: player_head[skull_skin=23b3f9dc-f02c-4ea8-a949-dbd56b03602c|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNGVmMzU2YWQyYWE3YjE2NzhhZWNiODgyOTBlNWZhNWEzNDI3ZTVlNDU2ZmY0MmZiNTE1NjkwYzY3NTE3YjgifX19]
    display name: Next Page

# Item to show last Active Quest page
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