CustomBirchTree:
    type: item
    material: birch_sapling
    display name: <&a>Birch Sapling
    lore:
    - ((This is a sapling for
    - a custom tree. Place it and
    - wait to grow it!))
            
OnPlayerPlacesCustomTree:
    type: task
    script:
        - if <context.item_in_hand.script.name||null> == CustomBirchTree:
            - repeat 300:
                - playeffect effect:FIREWORKS_SPARK at:<context.location.above> visibility:25 quantity:5 data:0 offset:0.6
                - wait 10s
            - schematic load name:CustomBirch
            - schematic paste name:CustomBirch <context.location.above> noair