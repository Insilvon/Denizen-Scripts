SmokeEffect:
    type: task
    debug: false
    script:
        - define eyes:<player.eye_location.forward[0.3]>
        - define eyes2:<[eyes].above>
        - playeffect flame at:<[eyes]> quantity:1 offset:0
        - foreach <[eyes].points_between[<[eyes2]>].distance[0.1]> as:point:
            - playeffect smoke_normal at:<[point]> quantity:3 offset:0.1
            - wait 1t

SmokeEffect2:
    type: task
    debug: false
    script:
        - define eyes:<player.eye_location.forward[0.3]>
        - define eyes2:<[eyes].above>
        - playeffect flame at:<[eyes]> quantity:1 offset:0
        - foreach <[eyes].points_between[<[eyes2]>].distance[0.1]> as:point:
            - playeffect campfire_cosy_smoke at:<[point]> quantity:3 offset:0.1
            - wait 1t

SmokingController:
    type: world
    debug: false
    events:
        on player right clicks with cigar:
            - determine cancelled passively
            - inject SmokeEffect
        on player right clicks with CrimsonSunBurner:
            - determine cancelled passively
            - inject SmokeEffect2
            - define nbt:<player.item_in_hand.nbt[Uses]>
            - if <[nbt]> == 0:
                - take CrimsonSunBurner
            - else:
                - inventory adjust d:<player.inventory> s:<player.item_in_hand.slot> nbt:li@Uses/<[nbt].sub_int[1]>
        on player right clicks with LapidasLongLeaf:
            - determine cancelled passively
            - inject SmokeEffect
            - define nbt:<player.item_in_hand.nbt[Uses]>
            - if <[nbt]> == 0:
                - take LapidasLongleaf
            - else:
                - inventory adjust d:<player.inventory> s:<player.item_in_hand.slot> nbt:li@Uses/<[nbt].sub_int[1]>
            - inject SmokeEffect
        on player right clicks with BrewhavenBuffa:
            - determine cancelled passively
            - inject SmokeEffect2
            - define nbt:<player.item_in_hand.nbt[Uses]>
            - if <[nbt]> == 0:
                - take BrewhavenBuffa
            - else:
                - inventory adjust d:<player.inventory> s:<player.item_in_hand.slot> nbt:li@Uses/<[nbt].sub_int[1]>
            - inject SmokeEffect2
        on player right clicks with HoneyCigar:
            - determine cancelled passively
            - inject SmokeEffect
            - define nbt:<player.item_in_hand.nbt[Uses]>
            - if <[nbt]> == 0:
                - take HoneyCigar
            - else:
                - inventory adjust d:<player.inventory> s:<player.item_in_hand.slot> nbt:li@Uses/<[nbt].sub_int[1]>
            - inject SmokeEffect
        
# Cigar:
#     type: item
#     material: lever
#     display name: <&c>Cigar
#     lore:
#         - Sophistication.
#         - Masculinity.
#         - Film Noir Edginess.
# Cigar2:
#     type: item
#     material: lever
#     display name: <&c>Smoky Cigar
#     lore:
#         - Sophistication.
#         - Masculinity.
#         - Film Noir Edginess.

Tobacco:
    type: item
    material: wheat
    display name: <&c>Tobacco
EverlushTobacco:
    type: item
    material: wheat
    display name: <&2>Everlush Tobacco
    recipes:
        1:
            type: shapeless
            input: sugar|Tobacco

CrimsonSunBurner:
    type: item
    material: lever[nbt=li@Uses/3]
    display name: <&c>Crimson Sun Burner
    lore:
        - A hard, fast, and
        - spicy burning tobacco
        - named for the colony
        - itself.
    recipes:
        1:
            type: shaped
            input:
            - stick|redstone|stick
            - paper|Tobacco|paper
            - stick|redstone|stick

LapidasLongleaf:
    type: item
    material: lever[nbt=li@Uses/3]
    display name: <&2>Lapidas Longleaf
    lore:
        - This hearty
        - tobacco is named
        - for only the finest
        - in Lapidas.
    recipes:
        1:
            type: shaped
            input:
            - stick|paper|stick
            - stick|EverlushTobacco|stick
            - stick|paper|stick

BrewhavenBuffa:
    type: item
    material: lever[nbt=li@Uses/3]
    display name: <&6>Brewhaven Buffa
    lore:
        - This tobacco has to be
        - pollinated by only the
        - finest Brewhaven Bees!
    recipes:
        1:
            type: shaped
            input:
            - stick|paper|stick
            - BrewhavenHoney|Tobacco|BrewhavenHoney
            - stick|paper|stick

HoneyCigar:
    type: item
    material: lever[nbt=li@Uses/3]
    display name: <&6>Honey Cigar
    lore:
        - A small and flavorful
        - cigarette, scented and
        - injected with Brewhaven
        - Honey.
    recipes:
        1:
            type: shaped
            input:
            - stick|BrewhavenHoney|stick
            - BrewhavenHoney|Tobacco|BrewhavenHoney
            - stick|BrewhavenHoney|stick

BrewhavenHoney:
    type: item
    material: honeycomb
    display name: <&6>Brewhaven Honey
    lore:
        - A comb of raw
        - Brewhaven Honey.
        - Its sweetness is
        - unrivaled.
    recipes:
        1:
            type: shapeless
            input: honeycomb

BrewhavenHoneyBottle:
    type: item
    material: honey_bottle
    display name: <&6>Brewhaven Honey Bottle
    lore:
        - A small, yet powerfully
        - sweet and savory vial
        - of Brewhaven refined Honey.
    recipes:
        1:
            type: shapeless
            input: BrewhavenHoney|Glass_bottle

BrewhavenHoneyController:
    type: world
    events:
        on BrewhavenHoneyBottle recipe formed:
            - if <player.name> != Cpt_Myers:
                - determine cancelled
        on BrewhavenHoney recipe formed:
            - if <player.name> != Cpt_Myers:
                - determine cancelled
        on LapidasLongleaf recipe formed:
            - if <player.name> != Cpt_Myers:
                - determine cancelled
        on CrimsonSunBurner recipe formed:
            - if <player.name> != Cpt_Myers:
                - determine cancelled
        on HoneyCigar recipe formed:
            - if <player.name> != Cpt_Myers:
                - determine cancelled
        on EverlushTobacco recipe formed:
            - if <player.name> != Cpt_Myers:
                - determine cancelled