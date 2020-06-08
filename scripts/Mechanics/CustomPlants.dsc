HopSeeds:
    type: item
    material: wheat_seeds
    display name: Hops Seeds
    lore:
        - WIP
Hops:
    type: item
    material: wheat
    display name: <&a>Hops
    lore:
        - WIP
TobaccoSeeds:
    type: item
    material: wheat_seeds
    display name: Tobacco Seeds

SunflowerSeeds:
    type: item
    material: wheat_seeds
    display name: <&e>Sunflower Seeds

DandelionSeeds:
    type: item
    material: wheat_seeds
    display name: <&e>Dandelion Seeds

# PoppySeeds:
#     type: item
#     material: wheat_seeds
#     display name: <&c>Poppy Seeds

Blue_OrchidSeeds:
    type: item
    material: wheat_seeds
    display name: <&b>Blue Orchid Seeds

AlliumSeeds:
    type: item
    material: wheat_seeds
    display name: <&d>Allium Seeds

Azure_BluetSeeds:
    type: item
    material: wheat_seeds
    display name: <&7>Azure Bluet Seeds

Red_TulipSeeds:
    type: item
    material: wheat_seeds
    display name: <&c>Red Tulip Seeds

Orange_TulipSeeds:
    type: item
    material: wheat_seeds
    display name: <&6>Orange Tulip Seeds

White_TulipSeeds:
    type: item
    material: wheat_seeds
    display name: <&7>White Tulip Seeds

Pink_TulipSeeds:
    type: item
    material: wheat_seeds
    display name: <&c>Pink Tulip Seeds

Oxeye_DaisySeeds:
    type: item
    material: wheat_seeds
    display name: <&e>Oxeye Daisy Seeds

CornflowerSeeds:
    type: item
    material: wheat_seeds
    display name: <&3>Cornflower Seeds

Lily_Of_The_ValleySeeds:
    type: item
    material: wheat_seeds
    display name: <&7>Lily Of The Valley Seeds

Wither_RoseSeeds:
    type: item
    material: wheat_seeds
    display name: <&8>Wither Rose Seeds

rose_bushSeeds:
    type: item
    material: wheat_seeds
    display name: <&c>Rose Bush Seeds

LilacSeeds:
    type: item
    material: wheat_seeds
    display name: <&d>Lilac Seeds

PeonySeeds:
    type: item
    material: wheat_seeds
    display name: <&d>Peony Seeds

CheckIfPlant:
    type: task
    debug: false
    script:
        - choose <[itemDrop]>:
            - case HopSeeds:
                - if <context.material> == m@wheat[age=7]:
                    - determine Hops[quantity=5]
                - else:
                    - determine Hops
            - case TobaccoSeeds:
                - if <context.material> == m@wheat[age=7]:
                    - determine Tobacco[quantity=5]
                - else:
                    - determine Tobacco
FlowerController:
    type: world
    events:
        on player places SunflowerSeeds:
            - define itemdrop:sunflowerseeds
            - wait 14m
            - inject FlowerPower
        on player places DandelionSeeds:
            - define itemdrop:dandelionseeds
            - wait 19m
            - inject FlowerPower
        on player places PoppySeeds:
            - define itemdrop:poppyseeds
            - wait 6m
            - inject FlowerPower
        on player places Blue_Orchidseeds:
            - define itemdrop:blue_orchidseeds
            - wait 9m
            - inject FlowerPower
        on player places AlliumSeeds:
            - define itemdrop:alliumseeds
            - wait 16m
            - inject FlowerPower
        on player places Azure_BluetSeeds:
            - define itemdrop:azure_bluetseeds
            - wait 8m
            - inject FlowerPower
        on player places Red_TulipSeeds:
            - define itemdrop:red_tulipseeds
            - wait 11m
            - inject FlowerPower
        on player places Orange_TulipSeeds:
            - define itemdrop:orange_tulipseeds
            - wait 14m
            - inject FlowerPower
        on player places White_TulipSeeds:
            - define itemdrop:white_tulipseeds
            - wait 17m
            - inject FlowerPower
        on player places Pink_Tulipseeds:
            - define itemdrop:pink_tulipseeds
            - wait 15m
            - inject FlowerPower
        on player places Oxeye_daisyseeds:
            - define itemdrop:oxeye_daisyseeds
            - wait 6m
            - inject FlowerPower
        on player places CornflowerSeeds:
            - define itemdrop:cornflowerseeds
            - wait 5m
            - inject FlowerPower
        on player places Lily_Of_The_ValleySeeds:
            - define itemdrop:lily_of_the_valleyseeds
            - wait 13m
            - inject FlowerPower
        on player places Wither_RoseSeeds:
            - define itemdrop:wither_roseseeds
            - wait 12m
            - inject FlowerPower
        on player places Rose_bushSeeds:
            - define itemdrop:rose_bushseeds
            - wait 11m
            - inject FlowerPower
        on player places LilacSeeds:
            - define itemdrop:lilacseeds
            - wait 15m
            - inject FlowerPower
        on player places PeonySeeds:
            - define itemdrop:peonyseeds
            - wait 9m
            - inject FlowerPower

FlowerPower:
    type: task
    script:
        - choose <[itemdrop]>:
            - case sunflowerseeds:
                - modifyblock <context.location> sunflower[half=BOTTOM]
                - modifyblock <context.location.above> sunflower[half=TOP]
                - modifyblock <context.location.below> grass_block
            - case dandelionseeds:
                - modifyblock <context.location> dandelion
                - modifyblock <context.location.below> grass_block
            - case poppyseeds:
                - modifyblock <context.location.below> grass_block
                - modifyblock <context.location> poppy
            - case blue_orchidseeds:
                - modifyblock <context.location.below> grass_block
                - modifyblock <context.location> blue_orchid
            - case alliumseeds:
                - modifyblock <context.location.below> grass_block
                - modifyblock <context.location> allium
            - case azure_bluetseeds:
                - modifyblock <context.location.below> grass_block
                - modifyblock <context.location> azure_bluet
            - case red_tulipseeds:
                - modifyblock <context.location.below> grass_block
                - modifyblock <context.location> red_tulip
            - case orange_tulipseeds:
                - modifyblock <context.location.below> grass_block
                - modifyblock <context.location> orange_tulip
            - case white_tulipseeds:
                - modifyblock <context.location.below> grass_block
                - modifyblock <context.location> white_tulip
            - case pink_tulipseeds:
                - modifyblock <context.location.below> grass_block
                - modifyblock <context.location> pink_tulip
            - case oxeye_daisyseeds:
                - modifyblock <context.location.below> grass_block
                - modifyblock <context.location> oxeye_daisy
            - case cornflowerseeds:
                - modifyblock <context.location.below> grass_block
                - modifyblock <context.location> cornflower
            - case lily_of_the_valleyseeds:
                - modifyblock <context.location.below> grass_block
                - modifyblock <context.location> lily_of_the_valley
            - case wither_roseseeds:
                - modifyblock <context.location.below> grass_block
                - modifyblock <context.location> wither_rose
            - case rose_bushseeds:
                - modifyblock <context.location.below> grass_block
                - modifyblock <context.location> rose_bush[half=BOTTOM]
                - modifyblock <context.location.above> rose_bush[half=TOP]
            - case lilacseeds:
                - modifyblock <context.location.below> grass_block
                - modifyblock <context.location> lilac[half=BOTTOM]
                - modifyblock <context.location.above> lilac[half=TOP]
            - case peonyseeds:
                - modifyblock <context.location.below> grass_block
                - modifyblock <context.location> peony[half=BOTTOM]
                - modifyblock <context.location.above> peony[half=TOP]

