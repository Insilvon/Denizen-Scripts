RandomPirateEgg:
    type: item
    material: egg
    display name: <&e>Random Pirate

EggController:
    type: world
    events:
        on player right clicks with RandomPirateEgg:
            - determine cancelled passively
            - define max:10
            - define value:<util.random.int[1].to[10]>
            - execute as_op "mm mobs spawn Pirate<[value]>"
            - take RandomPirateEgg