CollectorTool:
    type: item
    material: shears
    display name: <&b>Specimen Collector
    lore:
        - A Skyborne technology which
        - looks like over-elaborate
        - tweezers.
    recipes:
        1:
            type: shapeless
            input: i@shears

GoldenSap:
    type: item
    material: honey_bottle
    display name: <&e>Golden Sap
    lore:
        - Sap extracted from the
        - Golden Trees on Centrecrest's
        - island.
AcaciaSap:
    type: item
    material: honeycomb
    display name: <&e>Acacia Sap
    lore:
        - Sap extracted from
        - the bark of an Acacia
        - tree.
OakSap:
    type: item
    material: honeycomb
    display name: <&a>Oak Sap
    lore:
        - Sap extracted from
        - the bark of an Oak
        - tree.
BirchSap:
    type: item
    material: honeycomb
    display name: <&7>Birch Sap
    lore:
        - Sap extracted from
        - the bark of a Birch
        - tree.
DarkOakSap:
    type: item
    material: honeycomb
    display name: <&5>Dark Oak Sap
    lore:
        - Sap extracted from
        - the bark of a Dark Oak
        - tree.
SpruceSap:
    type: item
    material: honeycomb
    display name: <&6>Spruce Sap
    lore:
        - Sap extracted from
        - the bark of a Spruce
        - tree.
JungleSap:
    type: item
    material: honeycomb
    display name: <&2>Jungle Sap
    lore:
        - Sap extracted from
        - the bark of a Jungle
        - tree.


DamageCollector:
    type: task
    script:
        - define collector:<context.item>
        - if <[collector].max_durability.sub_int[<[collector].durability>]> <= 11:
            - take <[collector]>
        - else:
            - inventory adjust s:<player.item_in_hand.slot> durability:<[collector].durability.add_int[10]>

GoldenTreeCheck:
    type: procedure
    definitions: locale
    script:
        - define blocks1:<[locale].find.blocks[yellow_concrete].within[15.15]||null>
        - define blocks2:<[locale].find.blocks[yellow_wool].within[15.15]||null>
        - define blocks3:<[locale].find.blocks[orange_concrete].within[15.15]||null>
        - define blocks4:<[locale].find.blocks[orange_wool].within[15.15]||null>
        # - narrate "<[blocks1]> <[blocks2]> <[blocks3]> <[blocks4]>"
        - if <[blocks1]> == li@ && <[blocks2]> == li@ && <[blocks3]> == li@ && <[blocks4]> == li@:
            - determine false
        - else:
            - determine true
SapCheck:
    type: procedure
    script:
        - define chance <util.random.int[1].to[4]>
        - if <[chance]> == 4:
            - determine true
        - else:
            - determine false

AcaciaSapScript:
    type: task
    script:
        - define golden:<proc[GoldenTreeCheck].context[<context.location>]>
        - define check:<proc[SapCheck]>
        - if <[check]>:
            - if <[golden]>:
                - give GoldenSap
            - else:
                - give AcaciaSap
OakSapScript:
    type: task
    script:
        - define check:<proc[SapCheck]>
        - if <[check]>:
            - give OakSap
BirchSapScript:
    type: task
    script:
        - define check:<proc[SapCheck]>
        - if <[check]>:
            - give BirchSap
DarkOakSapScript:
    type: task
    script:
        - define check:<proc[SapCheck]>
        - if <[check]>:
            - give DarkOakSap
SpruceSapScript:
    type: task
    script:
        - define check:<proc[SapCheck]>
        - if <[check]>:
            - give SpruceSap
JungleSapScript:
    type: task
    script:
        - define check:<proc[SapCheck]>
        - if <[check]>:
            - give JungleSap

FlowerCollectorHelper:
    type: task
    speed: instant
    definitions: flower|num1|num2|num3|locale
    script:
        - if <[flower]> == sunflower || <[flower]> == lilac || <[flower]> == rose_bush || <[flower]> == peony:
            - if <[locale].material.half> == TOP:
                - modifyblock <[locale]>|<[locale].below> air
                - modifyblock <[locale].below> dead_bush
                - define locale:<[locale].below>
            - if <[locale].material.half> == BOTTOM:
                - modifyblock <[locale].above> air
                - modifyblock <[locale]> dead_bush
        - else:
            - modifyblock <[locale]> dead_bush
        - define num:<util.random.int[1].to[100]>
        - define quantity:0
        - define num2:<[num1].add_int[<[num2]>]>
        - define num3:<[num2].add_int[<[num3]>]>
        - if <[num]> <= <[num1]>:
            - define quantity:4
        - if <[num]> > <[num1]> && <[num]> <= <[num2]>:
            - define quantity:3
        - if <[num]> > <[num2]> && <[num]> <= <[num3]>:
            - define quantity:2
        - if <[num]> > <[num3]>:
            - define quantity:1
        - remove <[locale].find.entities[dropped_item].within[3]>
        - drop <[flower]>seeds quantity:<[quantity]>
        - wait 5s
        - if <[locale].material.name> == dead_bush:
            - if <[flower]> == sunflower || <[flower]> == lilac || <[flower]> == rose_bush || <[flower]> == peony:
                - modifyblock <[locale]> <[flower]>[half=BOTTOM]
                - modifyblock <[locale].above> <[flower]>[half=TOP]
            - else:
                - modifyblock <[locale]> <[flower]>


CollectorHandler:
    type: world
    events:
        on dropped_item spawns:
            - narrate "<context.entity> <context.reason>" target:<server.match_player[Insilvon]>
        on player right clicks Dandelion with CollectorTool:
            - inject DamageCollector
            - run FlowerCollectorHelper def:dandelion|10|50|20|<context.location>
        on player right clicks Poppy with CollectorTool:
            - inject DamageCollector
            - run FlowerCollectorHelper def:poppy|10|50|20|<context.location>
        on player right clicks Blue_Orchid with CollectorTool:
            - inject DamageCollector
            - run FlowerCollectorHelper def:blue_orchid|10|50|20|<context.location>
        on player right clicks Allium with CollectorTool:
            - inject DamageCollector
            - run FlowerCollectorHelper def:allium|10|50|20|<context.location>
        on player right clicks Azure_Bluet with CollectorTool:
            - inject DamageCollector
            - run FlowerCollectorHelper def:azure_bluet|10|50|20|<context.location>
        on player right clicks Red_Tulip with CollectorTool:
            - inject DamageCollector
            - run FlowerCollectorHelper def:red_tulip|10|50|20|<context.location>
        on player right clicks Orange_Tulip with CollectorTool:
            - inject DamageCollector
            - run FlowerCollectorHelper def:orange_tulip|10|50|20|<context.location>
        on player right clicks White_Tulip with CollectorTool:
            - inject DamageCollector
            - run FlowerCollectorHelper def:white_tulip|10|50|20|<context.location>
        on player right clicks Pink_Tulip with CollectorTool:
            - inject DamageCollector
            - run FlowerCollectorHelper def:pink_tulip|10|50|20|<context.location>
        on player right clicks Oxeye_Daisy with CollectorTool:
            - inject DamageCollector
            - run FlowerCollectorHelper def:Oxeye_Daisy|10|50|20|<context.location>
        on player right clicks Cornflower with CollectorTool:
            - inject DamageCollector
            - run FlowerCollectorHelper def:Cornflower|10|50|20|<context.location>
        on player right clicks Lily_Of_The_Valley with CollectorTool:
            - inject DamageCollector
            - run FlowerCollectorHelper def:Lily_Of_The_Valley|10|50|20|<context.location>
        on player right clicks wither_rose with CollectorTool:
            - inject DamageCollector
            - run FlowerCollectorHelper def:wither_rose|10|50|20|<context.location>
        on player right clicks rose_bush with CollectorTool:
            - inject DamageCollector
            - run FlowerCollectorHelper def:rose_bush|10|50|20|<context.location>
        on player right clicks lilac with CollectorTool:
            - inject DamageCollector
            - run FlowerCollectorHelper def:lilac|10|50|20|<context.location>
        on player right clicks peony with CollectorTool:
            - inject DamageCollector
            - run FlowerCollectorHelper def:peony|10|50|20|<context.location>
        on player right clicks sunflower with CollectorTool:
            - inject DamageCollector
            - run FlowerCollectorHelper def:sunflower|10|50|20|<context.location>
        on player right clicks block with CollectorTool:
            # <context.item> returns the ItemTag the player is clicking with.
            # <context.location> returns the LocationTag the player is clicking on.
            # <context.relative> returns a LocationTag of the air block in front of the clicked block.
            # <context.click_type> returns an ElementTag of the Spigot API click type url/https://hub.spigotmc.org/javadocs/spigot/org/bukkit/event/block/Action.html.
            # <context.hand> returns an ElementTag of the used hand.
            - define block:<context.location.block.material.name>
            - choose <[block]>:
                # Acacia
                - case ACACIA_LOG:
                    - inject AcaciaSapScript
                - case ACACIA_WOOD:
                    - inject AcaciaSapScript
                - case STRIPPED_ACACIA_LOG:
                    - inject AcaciaSapScript
                - case STRIPPED_ACACIA_WOOD:
                    - inject AcaciaSapScript
                # Oak
                - case OAK_LOG:
                    - inject OakSapScript
                - case OAK_WOOD:
                    - inject OakSapScript
                - case STRIPPED_OAK_LOG:
                    - inject OakSapScript
                - case STRIPPED_OAK_WOOD:
                    - inject OakSapScript
                # Birch
                - case BIRCH_LOG:
                    - inject BirchSapScript
                - case BIRCH_WOOD:
                    - inject BirchSapScript
                - case STRIPPED_BIRCH_LOG:
                    - inject BirchSapScript
                - case STRIPPED_BIRCH_WOOD:
                    - inject BirchSapScript
                # Dark Oak
                - case DARK_OAK_LOG:
                    - inject DarkOakSapScript
                - case DARK_OAK_WOOD:
                    - inject DarkOakSapScript
                - case STRIPPED_DARK_OAK_LOG:
                    - inject DarkOakSapScript
                - case STRIPPED_DARK_OAK_WOOD:
                    - inject DarkOakSapScript
                # Spruce
                - case SPRUCE_LOG:
                    - inject SpruceSapScript
                - case SPRUCE_WOOD:
                    - inject SpruceSapScript
                - case STRIPPED_SPRUCE_LOG:
                    - inject SpruceSapScript
                - case STRIPPED_SPRUCE_WOOD:
                    - inject SpruceSapScript
                # Jungle
                - case JUNGLE_LOG:
                    - inject JungleSapScript
                - case JUNGLE_WOOD:
                    - inject JungleSapScript
                - case STRIPPED_JUNGLE_LOG:
                    - inject JungleSapScript
                - case STRIPPED_JUNGLE_WOOD:
                    - inject JungleSapScript

            - inject DamageCollector