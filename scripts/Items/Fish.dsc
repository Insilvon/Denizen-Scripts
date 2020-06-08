FishingController:
    type: world
    events:
        on player fishes item:
            - define acceptable:li@pufferfish|tropical_fish|cod|salmon
            - if !<[acceptable].contains[<context.item.material.name>]>:
                - determine "CAUGHT:<proc[GetRandomFishingReward]>"
            - else:
                - random:
                    - determine "CAUGHT:<proc[GetRandomFishingReward]>"
                    - determine "CAUGHT:<context.item>"

Tuna:
    type: item
    material: cod
    display name: <&3>Tuna
    lore:
        - The chicken of the sea!

Eel:
    type: item
    material: cod
    display name: <&a>Eel
    lore:
        - The longest
        - of the marine
        - boys.

Seaweed:
    type: item
    material: kelp
    display name: <&a>Seaweed
    lore:
        - Long, leafy,
        - and uncomfortably
        - moist.

OldBoot:
    type: item
    material: leather_boots
    display name:
    lore:
        - Who left this here?

OldFishingRod:
    type: item
    material: fishing_rod
    display name:
    lore:
        - A weathered, worn
        - and beaten fishing rod
        - lost to a sailor in the
        - sky. It is emblazoned
        - with a faded gold oak
        - leaf.
Bass:
    type: item
    material: salmon
    display name: <&a>Bass
    lore:
        - Don<&sq>t drop it.

Catfish:
    type: item
    material: salmon
    display name: <&3>Catfish
    lore:
        - Tastes 100% better
        - without the whiskers.

Fugu:
    type: item
    material: pufferfish
    display name: <&a>Fugu
    lore:
        - Extremely dangerous,
        - extremely worth it.

Trout:
    type: item
    material: cod
    display name: <&3>Trout
    lore:
        - Don't get caught
        - with your Trout down!


#--------------------------
CookedTuna:
    type: item
    material: cooked_cod
    display name: <&3>Cooked Tuna
    lore:
        - The chicken of the sea!
        - A cooked variant.
    recipes:
        1:
            type: furnace
            input: Tuna
        2:
            type: smoker
            input: Tuna

CookedEel:
    type: item
    material: cooked_cod
    display name: <&a>Cooked Eel
    lore:
        - The longest
        - of the marine
        - boys.
        - A cooked variant.
    recipes:
        1:
            type: furnace
            input: Eel
        2:
            type: smoker
            input: Eel

CookedSeaweed:
    type: item
    material: kelp
    display name: <&a>Cooked Seaweed
    lore:
        - Long, leafy,
        - and uncomfortably
        - moist.
        - Toasty and crisp!
    recipes:
        1:
            type: furnace
            input: Seaweed
        2:
            type: smoker
            input: Seaweed

CookedBass:
    type: item
    material: cooked_salmon
    display name: <&a>Cooked Bass
    lore:
        - Don<&sq>t drop it.
        - A cooked variant.
    recipes:
        1:
            type: furnace
            input: Bass
        2:
            type: smoker
            input: Bass

CookedCatfish:
    type: item
    material: cooked_salmon
    display name: <&3>Cooked Catfish
    lore:
        - Tastes 100% better
        - without the whiskers.
        - A cooked variant.
    recipes:
        1:
            type: furnace
            input: Catfish
        2:
            type: smoker
            input: Catfish

CookedFugu:
    type: item
    material: pufferfish
    display name: <&a>Cooked Fugu
    lore:
        - Extremely dangerous,
        - extremely worth it.
        - A cooked variant.
    recipes:
        1:
            type: furnace
            input: Fugu
        2:
            type: smoker
            input: Fugu
CookedTrout:
    type: item
    material: cooked_cod
    display name: <&3>Cooked Trout
    lore:
        - Don't get caught
        - with your Trout down!
        - A cooked variant.
    recipes:
        1:
            type: furnace
            input: Trout
        2:
            type: smoker
            input: Trout

GetRandomFishingReward:
    type: procedure
    script:
        - random:
            - determine Trout
            - determine Fugu
            - determine Catfish
            - determine Bass
            - determine OldBoot
            - determine OldFishingRod
            - determine Seaweed
            - determine Eel
            - determine Tuna