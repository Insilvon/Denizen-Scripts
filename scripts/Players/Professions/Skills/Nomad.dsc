NomadTooltip:
    type: item
    material: player_head[skull_skin=945906b4-6fdc-4b99-9a26-30906befb63a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNjM4YzUzZTY2ZjI4Y2YyYzdmYjE1MjNjOWU1ZGUxYWUwY2Y0ZDdhMWZhZjU1M2U3NTI0OTRhOGQ2ZDJlMzIifX19]
    display name: <&a>Help Item
    lore:
        - Gain profession levels
        - by exploring the world, scavenging
        - and getting materials from
        - animals!

NomadDice:
    type: item
    material: player_head[skull_skin=2201f095-0c4a-46c1-806c-b9f338c42232|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMmNlYjcxM2NkOWNmOTE5MjY0YjYzMWU3MGY1MjhiZDIwYzQzZTc5MjQxNjk1ZDZiZmM5Y2ZjN2RjZDYzZCJ9fX0=]
    display name: <&a>Nomad Dice
    lore:
        - Roll based on your
        - profession's skill!

NomadSkills:
    type: yaml data
    1:
        skill: SetMobTrap
    2:
        skill: SetFishTrap
    3:
        skill: SetRabbitTrap
    4:
        skill: NightEyes
    5:
        skill: Scavenge
    6:
        skill: WanderersLuck
    7:
        skill: CarvingKnife
    8:
        skill: WildKnowledge1
    9:
        skill: WildKnowledge2
        requirements:
            - WildKnowledge1
    10:
        skill: WildKnowledge3
        requirements:
            - WildKnowledge2
    11:
        skill: ImpromptuCampfire

#========================SKILLS
#==========================
SetMobTrap:
    type: item
    material: map
    display name: <&7>SetMobTrap
    lore:
SetMobTrapLearned:
    type: item
    material: filled_map
    display name: <&a>SetMobTrap
    lore:
SetMobTrapCast:
    type: task
    definitions: target
    script:
        - define character <player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "Issue with character! Error!"
            - stop

#==========================
SetFishTrap:
    type: item
    material: map
    display name: <&7>SetFishTrap
    lore:
SetFishTrapLearned:
    type: item
    material: filled_map
    display name: <&a>SetFishTrap
    lore:
SetFishTrapCast:
    type: task
    definitions: target
    script:
        - define character <player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "Issue with character! Error!"
            - stop

#==========================
SetRabbitTrap:
    type: item
    material: map
    display name: <&7>SetRabbitTrap
    lore:
SetRabbitTrapLearned:
    type: item
    material: filled_map
    display name: <&a>SetRabbitTrap
    lore:
SetRabbitTrapCast:
    type: task
    definitions: target
    script:
        - define character <player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "Issue with character! Error!"
            - stop

#==========================
NightEyes:   
    type: item
    material: map
    display name: <&7>NightEyes
    lore:
NightEyesLearned:
    type: item
    material: filled_map
    display name: <&a>NightEyes
    lore:
NightEyesCast:
    type: task
    definitions: target
    script:
        - define character <player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "Issue with character! Error!"
            - stop

#==========================
Scavenge:    
    type: item
    material: map
    display name: <&7>Scavenge
    lore:
ScavengeLearned:
    type: item
    material: filled_map
    display name: <&a>Scavenge
    lore:
ScavengeCast:
    type: task
    definitions: target
    script:
        - define character <player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "Issue with character! Error!"
            - stop

#==========================
WanderersLuck:   
    type: item
    material: map
    display name: <&7>WanderersLuck
    lore:
WanderersLuckLearned:
    type: item
    material: filled_map
    display name: <&a>WanderersLuck
    lore:
WanderersLuckCast:
    type: task
    definitions: target
    script:
        - define character <player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "Issue with character! Error!"
            - stop

#==========================
CarvingKnife:    
    type: item
    material: map
    display name: <&7>CarvingKnife
    lore:
CarvingKnifeLearned:
    type: item
    material: filled_map
    display name: <&a>CarvingKnife
    lore:
CarvingKnifeCast:
    type: task
    definitions: target
    script:
        - define character <player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "Issue with character! Error!"
            - stop

#==========================
WildKnowledge1:    
    type: item
    material: map
    display name: <&7>WildKnowledge1
    lore:
WildKnowledge1Learned:
    type: item
    material: filled_map
    display name: <&a>WildKnowledge1
    lore:
WildKnowledge1Cast:
    type: task
    definitions: target
    script:
        - define character <player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "Issue with character! Error!"
            - stop

#==========================
WildKnowledge2:    
    type: item
    material: map
    display name: <&7>WildKnowledge2
    lore:
WildKnowledge2Learned:
    type: item
    material: filled_map
    display name: <&a>WildKnowledge2
    lore:
WildKnowledge2Cast:
    type: task
    definitions: target
    script:
        - define character <player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "Issue with character! Error!"
            - stop

#==========================
WildKnowledge3:    
    type: item
    material: map
    display name: <&7>WildKnowledge3
    lore:
WildKnowledge3Learned:
    type: item
    material: filled_map
    display name: <&a>WildKnowledge3
    lore:
WildKnowledge3Cast:
    type: task
    definitions: target
    script:
        - define character <player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "Issue with character! Error!"
            - stop

#==========================
ImpromptuCampfire:
    type: item
    material: map
    display name: <&7>ImpromptuCampfire
    lore:
ImpromptuCampfireLearned:
    type: item
    material: filled_map
    display name: <&a>ImpromptuCampfire
    lore:
ImpromptuCampfireCast:
    type: task
    definitions: target
    script:
        - define character <player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "Issue with character! Error!"
            - stop
