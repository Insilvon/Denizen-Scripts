MinerTooltip:
    type: item
    material: player_head[skull_skin=945906b4-6fdc-4b99-9a26-30906befb63a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNjM4YzUzZTY2ZjI4Y2YyYzdmYjE1MjNjOWU1ZGUxYWUwY2Y0ZDdhMWZhZjU1M2U3NTI0OTRhOGQ2ZDJlMzIifX19]
    display name: <&a>Help Item
    lore:
        - Gain profession levels
        - by mining ores, discovering
        - custom ores, and using
        - your new skills!

MinerDice:
    type: item
    material: player_head[skull_skin=6c7a241b-4ef6-4c66-8cb8-958c6cb395a8|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYzZkNGEwMWRiNjEyNjYwMWRlZDE0MDZjZjYyMzhjZTJiNzAyNGVhY2U1ZWE2MDRmYmMyMDhhMmFmMjljOTdhZCJ9fX0=]
    display name: <&a>Miner Dice
    lore:
        - Roll based on your
        - profession's skill!

MinerSkills:
    type: yaml data
    1:
        skill: RareOreResearch1
    2:
        skill: RareOreResearch2
        requirements:
            - RareOreResearch1
    3:
        skill: RareOreResearch3
        requirements:
            - RareOreResearch2
    4:
        skill: RareOreResearch4
        requirements:
            - RareOreResearch3
    5:
        skill: RareOreResearch5
        requirements:
            - RareOreResearch4
    6:
        skill: Supercharge
        requirements:
            - RareOreResearch5
    7:
        skill: TravelToRegenMine
    8:
        skill: BypassOreMerchant


MinerController:
    type: world
    events:
        #= Smelting
        on item moves from hopper to blast_furnace:
            - define list:li@coal_ore|iron_ore|gold_ore|lapis_ore|redstone_ore|diamond_ore|nether_quartz_ore|darksteelore|skysteelore|copperore|tingrumore|silverlickore|prometheumore|kineticore|mithrilore
            - if <[list].contains[<context.item>]>:
                - determine cancelled
        on player opens blast_furnace:
            - if !<player.has_flag[Profession_Miner]>:
                - determine cancelled
        #= Ore Drops
        on player breaks coal_ore:
            # Prometheum Ore Chance
            - if <player.has_flag[Profession_RareOreResearch2]>:
                - define chance:<util.random.int[1].to[10]>
                - if <[chance]> == 2:
                    - drop prometheum_ore <player.location>
            - if <player.has_flag[Profession_Miner]>:
                - run ProfessionGiveEXP def:<player>|Miner|1
        on player breaks iron_ore:  
            - define character:<player.flag[CharacterSheet_CurrentCharacter]>
            # Darksteel Ore, Skysteel Ore Chance
            - if <player.has_flag[Profession_RareOreResearch1]>:
                - define chance:<util.random.int[1].to[10]>
                - if <[chance]> == 2 && <player.location.world> == Aetheria:
                    - drop darksteel_ore <player.location>
                - if <[chance]> == 3 && <player.location.world> == Skyworld_V2:
                    - drop skysteel_ore <player.location>
            - if <player.has_flag[Profession_Miner]>:
                - run ProfessionGiveEXP def:<player>|Miner|1
        on player breaks gold_ore:
            - define character:<player.flag[CharacterSheet_CurrentCharacter]>
            - if !<player.has_flag[Miner]>:
                - narrate "You shatter the ore."
                - determine air
            # Copper ore check
            - if <player.has_flag[Profession_RareOreResearch1]>:
                - define chance:<util.random.int[1].to[10]>
                - if <[chance]> == 2:
                    - drop copper_ore <player.location>
            - if <player.has_flag[Profession_Miner]>:
                - run ProfessionGiveEXP def:<player>|Miner|1
        on player breaks redstone_ore:
            - define character:<player.flag[CharacterSheet_CurrentCharacter]>
            - if !<player.has_flag[Miner]>:
                - narrate "You shatter the ore."
                - determine air
            # Tingrum Ore Check
            - if <player.has_flag[Profession_RareOreResearch1]>:
                - define chance:<util.random.int[1].to[10]>
                - if <[chance]> == 2:
                    - drop tingrum_ore <player.location>
            - if <player.has_flag[Profession_Miner]>:
                - run ProfessionGiveEXP def:<player>|Miner|1
        on player breaks diamond_ore:
            - define character:<player.flag[CharacterSheet_CurrentCharacter]>
            - if !<player.has_flag[Miner]>:
                - narrate "You shatter the ore."
                - determine air
            # Mithril Ore Check
            - if <player.has_flag[Profession_RareOreResearch4]>:
                - define chance:<util.random.int[1].to[10]>
                - if <[chance]> == 2:
                    - drop mithril_ore <player.location>
            - if <player.has_flag[Profession_Miner]>:
                - run ProfessionGiveEXP def:<player>|Miner|1
        on player breaks lapis_ore:
            - define character:<player.flag[CharacterSheet_CurrentCharacter]>
            - if !<player.has_flag[Miner]>:
                - narrate "You shatter the ore."
                - determine air
            # Silverlick Ore Check
            - if <player.has_flag[Profession_RareOreResearch2]>:
                - define chance:<util.random.int[1].to[10]>
                - if <[chance]> == 2:
                    - drop silverlick_ore <player.location>
            - if <player.has_flag[Profession_Miner]>:
                - run ProfessionGiveEXP def:<player>|Miner|1
        on player breaks emerald_ore:
            - define character:<player.flag[CharacterSheet_CurrentCharacter]>
            - if !<player.has_flag[Miner]>:
                - narrate "You shatter the ore."
                - determine air
            # kinetic ore
            - if <player.has_flag[Profession_RareOreResearch3]>:
                - define chance:<util.random.int[1].to[10]>
                - if <[chance]> == 2:
                    - drop kinetic_ore <player.location>
            - if <player.has_flag[Profession_Miner]>:
                - run ProfessionGiveEXP def:<player>|Miner|1



# TestItem99:
#     type: item
#     material: diamond_sword[nbt=li@Castable/MinerSkill1Cast|Profession/Miner]

#============================SKILLS
#=============
RareOreResearch1:
    type: item
    material: map
    display name: <&7>Rare Ore Research I
    lore:
        - Cost: 1
        - Learn this skill to
        - uncover information about
        - rare ores.
RareOreResearch1Learned:
    type: item
    material: filled_map
    display name: <&6>Rare Ore Research I
    lore:
        - A passive skill which
        - allows for the mining
        - of darksteel and skysteelsteel
        - ores.
RareOreResearch1Cast:
    type: task
    definitions: target
    script:
        - define character <player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "Issue with character! Error!"
            - stop
        - flag <[target]> Profession_RareOreResearch1
#=============
RareOreResearch2:
    type: item
    material: map
    display name: <&7>Rare Ore Research II
    lore:
        - Cost: 1
        - Learn this skill to
        - uncover information about
        - rare ores.
RareOreResearch2Learned:
    type: item
    material: filled_map
    display name: <&6>Rare Ore Research II
    lore:
        - A passive skill which
        - allows for the mining
        - of prometheum and silverlick
        - ores.
RareOreResearch2Cast:
    type: task
    definitions: target
    script:
        - define character <player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "Issue with character! Error!"
            - stop
        - flag <[target]> Profession_RareOreResearch2
#=============
RareOreResearch3:
    type: item
    material: map
    display name: <&7>Rare Ore Research III
    lore:
        - Cost: 1
        - Learn this skill to
        - uncover information about
        - rare ores.
RareOreResearch3Learned:
    type: item
    material: filled_map
    display name: <&6>Rare Ore Research III
    lore:
        - A passive skill which
        - allows for the mining
        - of kinetic
        - ores.
RareOreResearch3Cast:
    type: task
    definitions: target
    script:
        - define character <player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "Issue with character! Error!"
            - stop
        - flag <[target]> Profession_RareOreResearch3
#=============
RareOreResearch4:
    type: item
    material: map
    display name: <&7>Rare Ore Research IV
    lore:
        - Cost: 1
        - Learn this skill to
        - uncover information about
        - rare ores.
RareOreResearch4Learned:
    type: item
    material: filled_map
    display name: <&6>Rare Ore Research IV
    lore:
        - A passive skill which
        - allows for the mining
        - of mithril
        - ores.
RareOreResearch4Cast:
    type: task
    definitions: target
    script:
        - define character <player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "Issue with character! Error!"
            - stop
        - flag <[target]> Profession_RareOreResearch4
#=============
RareOreResearch5:
    type: item
    material: map
    display name: <&7>Rare Ore Research V
    lore:
        - Cost: 1
        - Learn this skill to
        - uncover information about
        - rare ores.
RareOreResearch5Learned:
    type: item
    material: filled_map
    display name: <&6>Rare Ore Research V
    lore:
        - A passive skill which
        - allows for the mining
        - of darksteel and cloudsteel
        - ores.
RareOreResearch5Cast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "Issue with character! Error!"
            - stop
        - flag <[target]> Profession_RareOreResearch5
#=============
Supercharge:
    type: item
    material: map
    display name: <&7>Supercharge
    lore:
        - Cost: 1
        - Learn this skill to
        - supercharge your pickaxe
        - for a brief time.
SuperchargeLearned:
    type: item
    material: gold_pickaxe
    display name: <&6>Supercharge
    lore:
        - Supercharge your
        - pickaxe mining
        - for a brief time.
SuperchargeCast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>:
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - cast FAST_DIGGING duration:5s power:10 <[target]>
#===============
TravelToRegenMine:
    type: item
    material: map
    display name: <&7>Travel to the Mines
    lore:
        - Cost: 2
        - Learn this skill to
        - gain access to the miner's 
        - union mine.
TravelToRegenMineLearned:
    type: item
    material: feather
    display name: <&6>Travel To The Mines
    lore:
        - Gain access to the miner's
        - union mine for a brief time.
TravelToRegenMineCast:
    type: task
    definitions: target
    script:
        - narrate "TravelToRegenMine text!"
#===============
BypassOreMerchant:
    type: item
    material: map
    display name: <&7>BypassOreMerchant
    lore:
        - Cost: 2
        - Learn this skill to
        - sell ores at no penalty.
BypassOreMerchantLearned:
    type: item
    material: feather
    display name: <&6>BypassOreMerchant
    lore:
        - Cast this to sell ores
        - at no penalty for a brief
        - time.
BypassOreMerchantCast:
    type: task
    definitions: target
    script:
        - narrate "BypassOreMerchant text!"