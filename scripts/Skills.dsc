# Main Quest Command Handler
Skills:
    type: command
    name: skills
    usage: /skills
    script:
        - flag player <proc[GetCharacterName].context[<player>]>_SkillMenu:1
        - inject LoadSkillInventory

# #everyone needs a dInventory to store their learned skills
SkillInventoryController:
    type: world
    events:
        on player clicks NextSkillPageItem in inventory:
            - run SkillMenuHandler def:next
            - determine cancelled
        on player clicks LastSkillPageItem in inventory:
            - run SkillMenuHandler def:last
            - determine cancelled
        on player drop clicks in inventory priority:1:
            - if <context.inventory> == in@<proc[GetCharacterName].context[<player>]>_Skills:
                - determine cancelled
        on player clicks in inventory priority:1:
            - define character:<proc[GetCharacterName].context[<player>]>
            #- narrate "<context.inventory>"
            - if <context.inventory> == in@<[character]>_Skills:
                - if <context.slot> > 45:
                    - define slot:<context.slot>
                    - narrate "You have selected a skillslot. Choose a skill to equip!."
                    - flag player <[character]>_Slot:<[slot]>
                - else:
                    #- narrate "You clicked below 45"
                    - if <player.has_flag[<[character]>_slot]>:
                        #- narrate "found flag, using <context.item>"
                        - inventory set d:in@<[character]>_skills o:<context.item> s:<player.flag[<[character]>_slot]>
                        - flag player <[character]>_ActiveSkills:->:<context.item>
                        - flag player <[character]>_slot:!x
                - determine cancelled

SkillMenuHandler:
    type: task
    speed: instant
    definitions: direction
    script:
        - determine cancelled passively
        - if <[direction]> == next:
            - flag player <proc[GetCharacterName].context[<player>]>_SkillMenu:++
        - else:
            - flag player <proc[GetCharacterName].context[<player>]>_SkillMenu:--
        - inject LoadSkillInventory

# Main Inventory Loader, used as Injection for QuestChangePage
LoadSkillInventory:
    type: task
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - define menu:<player.flag[<[character]>_SkillMenu]>
        - define end:<[menu].as_int.mul_int[42]>
        - define start:<[end].as_int.sub_int[41]>
        - define catch:li@
        - inventory clear d:in@<[character]>_Skills
        - if <player.flag[<[character]>_ActiveSkills]> != <[catch]> && <player.has_flag[<[character]>_ActiveSkills]>:
            - if <player.flag[<[character]>_ActiveSkills].size> < <[start]>:
                - flag player <[character]>_QuestJournalMenu:--
                - stop
            - define display:<player.flag[<[character]>_ActiveSkills].get[<[start]>].to[<[end]>]>
            #- narrate "<[display]>"
            - if <[display]> == <[catch]>:
                - flag player <[character]>_QuestJournalMenu:--
                - stop
            - foreach <[display]> as:item:
                - inventory add d:in@<[character]>_Skills o:<[item]>
        - inventory set d:in@<[Character]>_Skills o:i@NextSkillPageItem s:45
        - inventory set d:in@<[Character]>_Skills o:i@LastSkillPageItem s:44
        - define blocked:<player.flag[<[Character]>_BlockedSkills]>
        - repeat <[blocked]>:
            #- narrate "<element[55].sub_int[<[value]>]>"
            - inventory set d:in@<[Character]>_Skills o:i@InventoryBlockItem s:<element[55].sub_int[<[value]>]>
        - inventory close
        - inventory open d:in@<[character]>_Skills
AddLearnedSkill:
    type: task
    definitions: player|item
    script:
        - flag player <proc[GetCharacterName].context[<[player]>]>_ActiveSkills:->:<[item]>
        - title "title: <gold>*SKILLS*" "subtitle:<gold>You have learned a new skill."

AddTestSkills:
    type: task
    script:
        - repeat 55:
            - run AddLearnedSkill def:<player>|SpeedSkillBook
SpeedSkillBook:
    type: item
    material: diamond_sword
    display name: "Book of Speed"
    lore:
        - Use this to set speed book as active!

StrengthSkillBook:
    type: item
    material: book
    display name: "Book of Strength"
    lore:
        - Use this to set strength book as active!

WeaknessSkillBook:
    type: item
    material: book
    display name: "Book of Weakness"
    lore:
        - Use this to set weakness book as active!

InventoryBlockItem:
    type: item
    material: barrier
    display name: You haven<&sq>t unlocked this skill section yet!
    lore:
        - Additional slots can be unlocked
        - through interactions with the world.

# Item to show next Active Quest page
NextSkillPageItem:
    type: item
    material: player_head[skull_skin=23b3f9dc-f02c-4ea8-a949-dbd56b03602c|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNGVmMzU2YWQyYWE3YjE2NzhhZWNiODgyOTBlNWZhNWEzNDI3ZTVlNDU2ZmY0MmZiNTE1NjkwYzY3NTE3YjgifX19]
    display name: Next Page

# Item to show last Active Quest page
LastSkillPageItem:
    type: item
    material: player_head[skull_skin=1226610a-b7f8-47e5-a15d-126c4ef18635|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZjg0ZjU5NzEzMWJiZTI1ZGMwNThhZjg4OGNiMjk4MzFmNzk1OTliYzY3Yzk1YzgwMjkyNWNlNGFmYmEzMzJmYyJ9fX0=]
    display name: Back

SkillSetup:
    type: task
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - flag player <[Character]>_BlockedSkills:7
        - flag player <[Character]>_ActiveSkills:->:SpeedSkillBook
        - flag player <[Character]>_ActiveSkills:->:StrengthSkillBook
        - flag player <[Character]>_ActiveSkills:->:WeaknessSkillBook
        - flag player <[Character]>_LearnedSkills:Book|Book|Book|Book
        - flag player <[Character]>_SkillMenu:1
        - note in@InventoryTesting as:<[Character]>_Skills

SkillReset:
    type: task
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - flag player <[Character]>_BlockedSkills:!
        - flag player <[Character]>_ActiveSkills:!
        - flag player <[Character]>_LearnedSkills:!
        - flag player <[Character]>_SkillMenu:!
        - note remove as:<[Character]>_Skills


InvTest:
    type: task
    speed: instant
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - inventory clear d:in@<[Character]>_Skills
        - inventory open d:in@<[Character]>_Skills
        - define blocked:<player.flag[<[Character]>_BlockedSkills]>
        - define activeSkills:<player.flag[<[Character]>_ActiveSkills]>
        - define learnedSkills:<player.flag[<[Character]>_LearnedSkills]>
        # Load blocked slot
        - repeat <[blocked]>:
            #- narrate "<element[55].sub_int[<[value]>]>"
            - inventory set d:in@<[Character]>_Skills o:i@InventoryBlockItem s:<element[55].sub_int[<[value]>]>
        #- narrate <[activeskills]>
        - foreach <[activeskills]> as:skill:
            - inventory add d:in@<[Character]>_Skills o:<[skill]>
        - inventory set d:in@<[Character]>_Skills o:i@NextSkillPageItem s:45
        - inventory set d:in@<[Character]>_Skills o:i@LastSkillPageItem s:44

        

InventoryTesting:
    type: inventory
    title: Completed Quests
    size: 54
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
