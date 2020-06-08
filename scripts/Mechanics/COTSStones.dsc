COTSSkyStone:
    type: item
    material: prismarine_shard
    display name: <&a>Air Skystone
    lore:
    - Use to give yourself a short boost.
    - 5
    - charges remaining.
COTSSkyStoneBroken:
    type: item
    material: prismarine_crystals
    display name: <&a>Shattered Skystone
    lore:
    - A broken air skystone.
    - Needs to be recharged.
COTSFireStone:
    type: item
    material: red_dye
    display name: <&c>Flame Skystone
    lore:
    - Use to launch a fireball.
    - 5
    - charges remaining.
COTSFireStoneBroken:
    type: item
    material: prismarine_crystals
    display name: <&c>Shattered Skystone
    lore:
    - A broken fire skystone.
    - Needs to be recharged.
COTSEarthStone:
    type: item
    material: green_dye
    display name: <&6>Earth Skystone
    lore:
    - Use to summon a pillar of earth.
    - 10
    - charges remaining.
COTSEarthStoneBroken:
    type: item
    material: prismarine_crystals
    display name: <&6>Shattered Skystone
    lore:
    - A broken earth skystone.
    - Needs to be recharged.
COTSWaterStone:
    type: item
    material: light_blue_dye
    display name: <&3>Water Skystone
    lore:
    - Use to protect yourself with water.
    - 5
    - charges remaining.
COTSWaterStoneBroken:
    type: item
    material: prismarine_crystals
    display name: <&3>Shattered Skystone
    lore:
    - A broken water skystone.
    - Needs to be recharged.
OutsiderRunecube:
    type: item
    material: player_head[skull_skin=cdde0eb0-680d-4b55-824c-9a0d35838049|eyJ0aW1lc3RhbXAiOjE1NjM2NDc0MDg5MjEsInByb2ZpbGVJZCI6IjkxZjA0ZmU5MGYzNjQzYjU4ZjIwZTMzNzVmODZkMzllIiwicHJvZmlsZU5hbWUiOiJTdG9ybVN0b3JteSIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNTJkYjlmOWEzNjRmZTQzOGMwZGU1ZjQ5ODQwN2E5ODc2ZDRiOGIxM2ViM2E1YTQwNWZhZTJiNDI1YzRkNWMwMiJ9fX0=]
    display name: <&e>Mysterious Gem
    lore:
    - A strange gemstone with foreign runes
    - engraved on all sides.
    - 50
    - charges remaining.
# OutsiderRunecube2:
#     type: item
#     material: ghast_tear
#     display name: <&3>TestBattery
#     lore:
#     - A cube with mysterious uses.
#     - 50
#     - charges remaining.
COTSStonecontroller:
    type: world
    events:
        on player places OutsiderRunecube priority:100:
            - narrate "I see you!"
            - determine cancelled passively
            - inject CustomItemPlaced
        on player right clicks with OutsiderRunecube:
            - determine cancelled passively
            - define slot:<player.item_in_hand.slot>
            - define uses:<context.item.lore.get[3]||null>
            - if <[uses]> == null:
                - narrate "Contact Insilvon to have this old item swapped out."
                - stop
            - if <player.location.cuboids.contains_text[CrystalOfAether]>:
                - if <player.has_flag[CrystalCooldown]>:
                    - narrate "You must wait <player.flag[CrystalCooldown].expiration> before recharging."
                    - stop
                - else:
                    - inventory adjust s:<[slot]> "lore:A strange gemstone with foreign runes|engraved on all sides.|51|charges remaining."
                    - define uses:51
                    - narrate "The presence of the Crystal fills the Runecube with energy."
                    - flag player CrystalCooldown d:78h
            - if <[uses]> == 1:
                - narrate "<&a>The cube has dimmed."
                - stop
            - else:
                - inventory adjust s:<[slot]> "lore:A strange gemstone with foreign runes|engraved on all sides.|<[uses].sub_int[1]>|charges remaining."
                - define airstone:<player.inventory.quantity.scriptname[COTSSkyStoneBroken]>
                - define firestone:<player.inventory.quantity.scriptname[COTSFireStoneBroken]>
                - define earthstone:<player.inventory.quantity.scriptname[COTSEarthStoneBroken]>
                - define waterstone:<player.inventory.quantity.scriptname[COTSWaterStoneBroken]>
                - if <[airstone]> >= 1:
                    - take COTSSkyStoneBroken quantity:<[airstone]>
                    - give COTSSkyStone quantity:<[airstone]>
                - if <[firestone]> >= 1:
                    - take COTSFireStoneBroken quantity:<[firestone]>
                    - give COTSFireStone quantity:<[firestone]>
                - if <[earthstone]> >= 1:
                    - take COTSEarthStoneBroken quantity:<[earthstone]>
                    - give COTSEarthStone quantity:<[earthstone]>
                - if <[waterstone]> >= 1:
                    - take COTSWaterStoneBroken quantity:<[waterstone]>
                    - give COTSWaterStone quantity:<[waterstone]>
        on player right clicks with COTSSkyStone:
            - if <player.equipment.contains_text[elytra]>:
                - define slot:<player.item_in_hand.slot>
                - define uses:<context.item.lore.get[2]||null>
                - if <[uses]> == 1:
                    - narrate "<&a>Your stone has broke!"
                    - take <player.item_in_hand>
                    - give COTSSkyStoneBroken
                - else:
                    - narrate "<&a>Your skystone has <[uses].sub_int[1]> charges left."
                    - inventory adjust s:<[slot]> "lore:Use to give yourself a short boost|<[uses].sub_int[1]>|charges remaining."
                - playeffect campfire_cosy_smoke at:<player.location> quantity:20
                - shoot <player> origin:<player> speed:2
        on player right clicks with COTSFireStone:
            - define slot:<player.item_in_hand.slot>
            - define uses:<context.item.lore.get[2]||null>
            - if <[uses]> == 1:
                - narrate "<&a>Your stone has broke!"
                - take <player.item_in_hand>
                - give COTSFireStoneBroken
            - else:
                - narrate "<&a>Your firestone has <[uses].sub_int[1]> charges left."
                - inventory adjust s:<[slot]> "lore:Use to launch a fireball.|<[uses].sub_int[1]>|charges remaining."
            - define origin:<player.eye_location>
            - playeffect lava at:<[origin].points_between[<player.location.cursor_on>].distance[5]> offset:0.0 quantity:1
            - playeffect drip_lava at:<[origin].points_between[<player.location.cursor_on>].distance[0.1]> offset:0.1 quantity:15
            - shoot dropped_item[item=fire_charge] origin:<[origin].forward.forward> destination:<player.location.cursor_on> script:GunScript def:<[origin]> speed:3
            - shoot arrow origin:<[origin]> destination:<player.eye_location.precise_cursor_on> script:GunScript def:<[origin]> speed:3 save:theammo no_rotate
            - flag <entry[theammo].shot_entity> gun:cotsstone
            - flag player gun_cooldown d:6s
        on player right clicks block with COTSEarthStone:
            - define slot:<player.item_in_hand.slot>
            - define uses:<context.item.lore.get[2]||null>
            - if <[uses]> == 1:
                - narrate "<&a>Your stone has broke!"
                - take <player.item_in_hand>
                - give COTSEarthStoneBroken
            - else:
                - narrate "<&a>Your earthstone has <[uses].sub_int[1]> charges left."
                - inventory adjust s:<[slot]> "lore:Use to summon a pillar of earth.|<[uses].sub_int[1]>|charges remaining."
            - define id:<util.random.uuid>
            - define target:<player.cursor_on>
            - if <player.location.distance[<[target]>]> > 20:
                - stop
            - note ellipsoid@<player.cursor_on.xyz>,<player.location.world>,2,5,2 as:cotsearth_<[id]>
            - define ellipse:ellipsoid@cotsearth_<[id]>
            - playeffect item_crack at:<[target]> special_data:grass_block quantity:100 offset:3
            - modifyblock <[ellipse].blocks[air]> oak_leaves
            - wait 10s
            - modifyblock <[ellipse].blocks[oak_leaves]> air
            - note remove as:<[ellipse]>
        on player right clicks with COTSWaterStone:
            - define slot:<player.item_in_hand.slot>
            - define uses:<context.item.lore.get[2]||null>
            - if <[uses]> == 1:
                - narrate "<&a>Your stone has broke!"
                - take <player.item_in_hand>
                - give COTSWaterStoneBroken
            - else:
                - narrate "<&a>Your waterstone has <[uses].sub_int[1]> charges left."
                - inventory adjust s:<[slot]> "lore:Use to protect yourself with water.|<[uses].sub_int[1]>|charges remaining."
            - playeffect crit_magic at:<player.location>|<player.location.above> quantity:20
            - adjust <player> absorption_health:5