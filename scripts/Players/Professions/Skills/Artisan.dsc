ArtisanTooltip:
    type: item
    material: player_head[skull_skin=945906b4-6fdc-4b99-9a26-30906befb63a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNjM4YzUzZTY2ZjI4Y2YyYzdmYjE1MjNjOWU1ZGUxYWUwY2Y0ZDdhMWZhZjU1M2U3NTI0OTRhOGQ2ZDJlMzIifX19]
    display name: <&a>Help Item
    lore:
        - Gain profession levels
        - by bartering, trading,
        - and making bank.

ArtisanDice:
    type: item
    material: player_head[skull_skin=2c932936-26ba-4d3d-9c7b-4c9392c6717c|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZjg4ZmE5NzNlYTQ0NGNjODA4NzY4ZWE0OGJmMjY1N2FlOWE1NmMwYWY2MDI3NWU4NDQ2M2IxOTU2MjliY2UifX19]
    display name: <&a>Artisan Dice
    lore:
        - Roll based on your
        - profession's skill!

ArtisanSkills:
    type: yaml data
    1:
        skill: Bartering1
    2:
        skill: Bartering2
        requirements:
            - Bartering1
    3:
        skill: Bartering3
        requirements:
            - Bartering2
    4:
        skill: Bartering4
        requirements:
            - Bartering3
    5:
        skill: Bartering5
        requirements:
            - Bartering4
    6:
        skill: HireAFriend
    7:
        skill: DenseCargo
ArtisanLevels:
    type: yaml data
    1:
        exp: 5
    2:
        exp: 10
    3:
        exp: 20
    4:
        exp: 25
#=========================SKILLS
#==============
Bartering1:
    type: item
    material: map
    display name: <&7>Bartering1
    lore:
        - Cost: 1
        - Increase the
        - amount of money npc
        - merchants can trade with.
Bartering1Learned:
    type: item
    material: filled_map
    display name: <&a>Bartering1
    lore:
        - Increase the
        - amount of money npc
        - merchants can trade with.
Bartering1Cast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
#==============
Bartering2:
    type: item
    material: map
    display name: <&7>Bartering2
    lore:
        - Cost: 1
        - Further increase the
        - amount of money npc
        - merchants can trade with.
Bartering2Learned:
    type: item
    material: filled_map
    display name: <&a>Bartering2
    lore:
        - Further increase the
        - amount of money npc
        - merchants can trade with.
Bartering2Cast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
#==============
Bartering3:
    type: item
    material: map
    display name: <&7>Bartering3
    lore:
        - Cost: 1
        - Max out the amount of
        - money npc merchants can
        - trade with.
Bartering3Learned:
    type: item
    material: filled_map
    display name: <&a>Bartering3
    lore:
        - Max out the amount of
        - money npc merchants can
        - trade with.
Bartering3Cast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
#==============
Bartering4:
    type: item
    material: map
    display name: <&7>Bartering 4
    lore:
        - Cost: 1
        - Max out the amount of
        - money npc merchants can
        - trade with.
Bartering4Learned:
    type: item
    material: filled_map
    display name: <&a>Bartering 4
    lore:
        - Max out the amount of
        - money npc merchants can
        - trade with.
Bartering4Cast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
#==============
Bartering5:
    type: item
    material: map
    display name: <&7>Bartering5
    lore:
        - Cost: 1
        - Max out the amount of
        - money npc merchants can
        - trade with.
Bartering5Learned:
    type: item
    material: filled_map
    display name: <&a>Bartering5
    lore:
        - Max out the amount of
        - money npc merchants can
        - trade with.
Bartering5Cast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
#==============
HireAFriend:
    type: item
    material: map
    display name: <&7>HireAFriend
    lore:
        - Cost: 1
        - Hire an NPC to sell
        - Goods you've made.
HireAFriendLearned:
    type: item
    material: filled_map
    display name: <&a>HireAFriend
    lore:
        - Hire an NPC to sell
        - Goods you've made.
HireAFriendCast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
#==============
DenseCargo:
    type: item
    material: map
    display name: <&7>DenseCargo
    lore:
        - Cost: 1
        - Access a backpack style
        - inventory to help carry
        - your cargo.
DenseCargoLearned:
    type: item
    material: filled_map
    display name: <&a>DenseCargo
    lore:
        - Access a backpack style
        - inventory to help carry
        - your cargo.
DenseCargoCast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
