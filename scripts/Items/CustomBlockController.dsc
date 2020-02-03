# Helper script which will identify a cuboid and remove it from the Chunk File
# Last Change: Moved Telegraph Scripts to file
# TODO:// Move general tasks to their respective Files instead, make this only handle general events
CustomBlockControllerHelper:
    type: task
    definitions: triggerText|cuboids
    script:
        # - narrate "Looking for <[triggerText]>"
        # - narrate <[cuboids].filter[notable_name.starts_with[<[triggerText]>]].get[1]||null>
        - define theThing:<[cuboids].filter[notable_name.starts_with[<[triggerText]>]].get[1]||null>
        - note remove as:<[theThing].notable_name>
        - execute as_server "denizen save"

# Controller Script which manages Custom Item block breaks and plaing.
CustomBlocksController:
    type: world
    events:
        on player breaks flower_pot:
            - if <player.is_sneaking>:
                - determine cancelled passively
        on player breaks block:
            # Check to see if it's a custom item
            - define chunkID:<context.location.chunk>
            - define locale:<context.location.block>
            - define itemDrop:<proc[CustomItemCheck].context[<[chunkID]>|<[locale]>]>

            # Check if it has a custom region
            - inject CustomRegionOnPlayerBreaksBlock

            # Check to see if it's in a Machine
            - inject MachineOnPlayerBreaksBlock

            # Check to see if it is a telegraph
            - inject TelegraphOnPlayerBreaksBlock

            # Candle Handler
            - inject CandleOnPlayerBreaksBlock
            
            # Determine Drops
            - if <[itemDrop]> != null:
                - determine <[itemDrop]>
            # Candle Handler
        on player left clicks player_head:
            - define chunkID:<context.location.chunk>
            - define locale:<context.location.block>
            - define customItem:<proc[CustomItemRead].context[<[chunkID]>|<[locale]>]>
            # Telegraph Check
            - inject TelegraphOnPlayerLeftClicksPlayer_Head
        on player right clicks player_head:
        # What type of player head is it
            - define chunkID:<context.location.chunk>
            - define locale:<context.location.block>
            - define customItem:<proc[CustomItemRead].context[<[chunkID]>|<[locale]>]>
        # Is it a candle?
            - inject CandleOnPlayerRightClicksPlayer_Head
        # Is it a telegraph?
            - inject TelegraphOnPlayerRightClicksPlayer_Head
        # Custom Head Retention
        # Lootbags
        on player places CyanLootbag|BrownLootbag|PinkLootbag|PurpleLootbag|EggLootbag|GoldenLootbag|BlueLootbag|OrangeLootbag|RedLootbag|WhiteLootbag|LimestoneDinosaurSkullFossil|LimestoneDinosaurTrackFossil|LimestonePalmLeafFossil|LimestoneTrilobyteFossil|LimestoneShellFossil|LimestoneFishFossil|ShaleFishFossil|ShaleShellFossil|ShaleTrilobyteFossil|ShalePalmLeafFossil|ShaleDinosaurTrackFossil|ShaleDinosaurSkullFossil|SandstoneFishFossil|SandstoneShellFossil|SandstoneTrilobyteFossil|SandstonePalmLeafFossil|SandstoneDinosaurTrackFossil|SandstoneDinosaurSkullFossil|PoisonOil|LavenderOil|LemongrassOil|OrangeOil|PeppermintOil|PufferfishPoisonOil|EucalyptusOil|LightGreenStar|YellowStar|RedStar|PurpleStar|LightBlueStar|WhiteStar|PinkStar|OrangeStar|MagentaStar|LimeStar|LightGrayStar|SkyBlueStar|GreenStar|GrayStar|CyanStar|BrownStar|BlackStar|SapphireGeode|RoseQuartzGeode|NetherQuartzGeode|EmeraldGeode|AmethystGeode|QuartzGeode|RopeCoilAnchor|YellowCore|DumbCobblestone|DumbStone:
            - inject CustomItemPlaced
        # Candles
        on player places FreshLinenCandle|CherryBlossomCandle|BonfireCandle|OceanBreezeCandle|VanillaCandle|GingerbreadCandle|PumpkinSpiceCandle|PineCandle|AppleCinnamonCandle|ChocolateChipCookieCandle|LavenderCandle|LemongrassCandle|HoneydewCandle|GardeniaCandle|SugarCookieCandle|RedwoodCandle|PeachCandle|HoneysuckleCandle|WheatCandle:
            - inject CustomItemPlaced
        on player places SweetCandle|FoulCandle:
            - inject CustomItemPlaced
        on player places ClockworkBag:
            - inject CustomItemPlaced
        on player places Sphteven:
            - modifyblock <context.location> potted_birch_sapling
            - inject CustomItemPlaced

# Helper script - used for injection only
CustomItemPlaced:
    type: task
    script:
        - define theItem:<player.item_in_hand.scriptname>
        - flag server <[theItem]>_<context.location.simple>:snuffed
        - define chunkID:<context.location.chunk>
        - define locale:<context.location.block>
        - if <server.has_file[/ChunkData/<[chunkID]>.yml]>:
            - run AddToChunkFile def:<[chunkID]>|<[locale]>|<[theItem]>
        - else:
            - run CreateChunkFile def:<[chunkID]>|<[locale]>|<[theItem]>
MachineCheck:
    type: task
    definitions: cubes|theCuboid
    script:
        # - narrate "<&c>[Machines]<&co> Current Cuboids include <[cubes]>"
        - if <[cubes].contains_text[testmachine]>:
            # - narrate "<&c>[Machines]<&co> Found Cuboid - <[theCuboid]>"
            # - narrate "<&c>[Machines]<&co> Cuboid Name - <[theCuboid].notable_name>"
            - note remove as:<[theCuboid].notable_name>
            - narrate "<&c>[Machines]<&co> Removing cuboid!"
            - execute as_server "denizen save"
#TODO:// Rename this to Custom Item Return
# Script which will return AND REMOVE the custom item from the chunk file
CustomItemCheck:
    type: procedure
    definitions: chunkID|locale
    script:
        - if <server.has_file[/ChunkData/<[chunkID]>.yml]>:
            - yaml "load:/ChunkData/<[chunkID]>.yml" id:<[chunkID]>
            - define newItem:<yaml[<[chunkID]>].read[info.<[locale]>]>
            - yaml id:<[chunkID]> set info.<[locale]>:!
            - yaml "savefile:/ChunkData/<[chunkID]>.yml" id:<[chunkID]>
            - yaml unload id:<[chunkID]>
            - determine <[newItem]>
        - determine null
# Script which will return AND NOT REMOVE the custom item from the chunk file
CustomItemRead:
    type: procedure
    definitions: chunkID|locale
    script:
        - if <server.has_file[/ChunkData/<[chunkID]>.yml]>:
            - yaml "load:/ChunkData/<[chunkID]>.yml" id:<[chunkID]>
            - define newItem:<yaml[<[chunkID]>].read[info.<[locale]>]>
            - determine <[newItem]>
        - determine null


CustomRegionOnPlayerBreaksBlock:
    type: task
    script:
        - define cuboids:<context.location.cuboids>
        - if <context.location.cuboids.contains_text[AlchemyStation]>:
            - narrate "<&c>[Machines]<&co> You have broken your Alchemy Station..."
            - run CustomBlockControllerHelper def:AlchemyStation
        - if <context.location.cuboids.contains_text[TransmutationCircle]>:
            - narrate "<&4>Dark Alchemy<&co> Your circle has faded."
            - run CustomBlockControllerHelper def:TransmutationCircle
        # - if <context.location.cuboids.contains_text[Candle]>:
        #     - define customItem:<[itemdrop]>
        #     - if <server.has_flag[<[customItem]>_<context.location.simple>]>:
        #         - if <server.flag[<[customItem]>_<context.location.simple>]> == lit:
        #             - define theThing <context.location.cuboids.filter[notable_name.starts_with[<[customItem]>]].get[1]||null>
        #             - note remove as:<[theThing].notable_name>
        #             - execute as_server "denizen save"
        #         - narrate "Your candle has been removed."
        #         - flag server <[customItem]>_<context.location.simple>:!
        #         - run CustomBlockControllerHelper def:<[itemDrop]>|<[cuboids]>
        # - if <context.location.cuboids.contains_text[FoulCandle]>:
        #     - narrate "Your candle has been removed."
        #     - run CustomBlockControllerHelper def:FoulCandle