# #opening plate area to choose your charm

# #everyone needs a dInventory to store their learned skills
SkillInventoryController:
    type: world
    events:
        on player clicks in inventory:
            - narrate "<context.slot>"

SpeedSkillBook:
    type: item
    material: book
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
NextPageItem:
    type: item
    material: player_head[skull_skin=23b3f9dc-f02c-4ea8-a949-dbd56b03602c|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNGVmMzU2YWQyYWE3YjE2NzhhZWNiODgyOTBlNWZhNWEzNDI3ZTVlNDU2ZmY0MmZiNTE1NjkwYzY3NTE3YjgifX19]
    display name: Next Page

# Item to show last Active Quest page
LastPageItem:
    type: item
    material: player_head[skull_skin=1226610a-b7f8-47e5-a15d-126c4ef18635|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZjg0ZjU5NzEzMWJiZTI1ZGMwNThhZjg4OGNiMjk4MzFmNzk1OTliYzY3Yzk1YzgwMjkyNWNlNGFmYmEzMzJmYyJ9fX0=]
    display name: Back

SkillSetup:
    type: task
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - flag player <[Character]>_Blocked_Skills:7
        - flag player <[Character]>_Active_Skills:->:SpeedSkillBook
        - flag player <[Character]>_Active_Skills:->:StrengthSkillBook
        - flag player <[Character]>_Active_Skills:->:WeaknessSkillBook
        - flag player <[Character]>_Learned_Skills:Book|Book|Book|Book
        - note in@InventoryTesting as:<[Character]>_Skills
SkillReset:
    type: task
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - flag player <[Character]>_Blocked_Skills:!
        - flag player <[Character]>_Active_Skills:!
        - flag player <[Character]>_Learned_Skills:!
        - note remove as:<[Character]>_Skills


InvTest:
    type: task
    speed: instant
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - inventory clear d:in@<[Character]>_Skills
        - inventory open d:in@<[Character]>_Skills
        - define blocked:<player.flag[<[Character]>_Blocked_Skills]>
        - define activeSkills:<player.flag[<[Character]>_Active_Skills]>
        - define learnedSkills:<player.flag[<[Character]>_Learned_Skills]>
        # Load blocked slot
        - repeat <[blocked]>:
            - narrate "<element[55].sub_int[<[value]>]>"
            - inventory set d:in@<[Character]>_Skills o:i@InventoryBlockItem s:<element[55].sub_int[<[value]>]>
        - narrate <[activeskills]>
        - foreach <[activeskills]> as:skill:
            - inventory add d:in@<[Character]>_Skills o:<[skill]>
        - inventory set d:in@<[Character]>_Skills o:i@NextPageItem s:45
        - inventory set d:in@<[Character]>_Skills o:i@LastPageItem s:44

        

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
