# Helper script which will identify a cuboid and remove it from the Chunk File
CustomBlockControllerHelper:
  type: task
  definitions: triggerText|cuboids
  script:
    - narrate "Looking for <[triggerText]>"
    - narrate <[cuboids].filter[notable_name.starts_with[<[triggerText]>]].get[1]||null>
    - define theThing:<[cuboids].filter[notable_name.starts_with[<[triggerText]>]].get[1]||null>
    - note remove as:<[theThing].notable_name>
    - execute as_server "denizen save"

# Controller Script which manages Custom Item block breaks and plaing.
CustomBlocksController:
  type: world
  events:
    on player breaks block:
      # Check if it has a custom region
      - define cuboids:<context.location.cuboids>
      - if <context.location.cuboids.contains_text[AlchemyStation]>:
        - narrate "<&c>[Machines]<&co> You have broken your Alchemy Station..."
        - run CustomBlockControllerHelper def:AlchemyStation
      - if <context.location.cuboids.contains_text[TransmutationCircle]>:
        - narrate "<&4>Dark Alchemy<&co> Your circle has faded."
        - run CustomBlockControllerHelper def:TransmutationCircle
      - if <context.location.cuboids.contains_text[sweetcandle]>:
        - narrate "Your candle has been removed."
        - run CustomBlockControllerHelper def:SweetCandle|<[cuboids]>
      - if <context.location.cuboids.contains_text[FoulCandle]>:
        - narrate "Your candle has been removed."
        - run CustomBlockControllerHelper def:FoulCandle

      # Check to see if it's a custom item
      - define chunkID:<context.location.chunk>
      - define locale:<context.location.block>
      - define itemDrop:<proc[CustomItemCheck].context[<[chunkID]>|<[locale]>]>

      # Check to see if it's in a Machine
      - define cubes:<context.location.cuboids>
      - define theCuboid <context.location.cuboids.filter[notable_name.starts_with[testmachine]].get[1]||null>
      - run MachineCheck def:<[cubes]>|<[theCuboid]>

      # Determine Drops
      - if <[itemDrop]> != null:
        - determine <[itemDrop]>

    # Custom Head Retention
    on player places CyanLootbag|BrownLootbag|PinkLootbag|PurpleLootbag|EggLootbag|GoldenLootbag|BlueLootbag|OrangeLootbag|RedLootbag|WhiteLootbag|LimestoneDinosaurSkullFossil|LimestoneDinosaurTrackFossil|LimestonePalmLeafFossil|LimestoneTrilobyteFossil|LimestoneShellFossil|LimestoneFishFossil|ShaleFishFossil|ShaleShellFossil|ShaleTrilobyteFossil|ShalePalmLeafFossil|ShaleDinosaurTrackFossil|ShaleDinosaurSkullFossil|SandstoneFishFossil|SandstoneShellFossil|SandstoneTrilobyteFossil|SandstonePalmLeafFossil|SandstoneDinosaurTrackFossil|SandstoneDinosaurSkullFossil|PoisonOil|LavenderOil|LemongrassOil|OrangeOil|PeppermintOil|PufferfishPoisonOil|EucalyptusOil|LightGreenStar|YellowStar|RedStar|PurpleStar|LightBlueStar|WhiteStar|PinkStar|OrangeStar|MagentaStar|LimeStar|LightGrayStar|SkyBlueStar|GreenStar|GrayStar|CyanStar|BrownStar|BlackStar|SapphireGeode|RoseQuartzGeode|NetherQuartzGeode|EmeraldGeode|AmethystGeode|QuartzGeode|RopeCoilAnchor|YellowCore|DumbCobblestone|DumbStone:
      - inject CustomItemPlaced
    on player places SweetCandle|FoulCandle:
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
      - yaml unload id:<context.entity.uuid>
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
# 914e68b0-4550-4c2c-bbee-dc903e8485f5|eyJ0aW1lc3RhbXAiOjE1NjM2MzE3NTA0ODksInByb2ZpbGVJZCI6ImIwZDRiMjhiYzFkNzQ4ODlhZjBlODY2MWNlZTk2YWFiIiwicHJvZmlsZU5hbWUiOiJ4RmFpaUxlUiIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNzYwYTA4ZGE4ZDNlNzNjNWFkZGNjMTAzODk1NjU2YWM0MDRmZjQyZjJkNWI1Yjc0NmNjZGU2MDdjZTkwNDQzYyJ9fX0=
SweetCandle:
  type: Item
  material: stone
  display name: Sweet Candle
FoulCandle:
  type: Item
  material: grass_block
  display name: Foul Candle
TempDiamond:
  type: item
  material: diamond
TempEmerald:
  type: item
  material: emerald
TempGlowstone:
  type: item
  material: glowstone
TempRedstone:
  type: item
  material: redstone
TempInventory:
  type: inventory
  inventory: BREWING


# =================================================================================
# ====================================Lootbags=====================================
# =================================================================================

GetAllBags:
  type: task
  script:
    - give CyanLootbag
    - give BrownLootbag
    - give PinkLootbag
    - give PurpleLootbag
    - give EggLootbag
    - give GoldenLootbag
    - give BlueLootbag
    - give OrangeLootbag
    - give RedLootbag
    - give WhiteLootbag
CyanLootbag:
  type: Item
  material: player_head[skull_skin=914e68b0-4550-4c2c-bbee-dc903e8485f5|eyJ0aW1lc3RhbXAiOjE1NjM2MzE3NTA0ODksInByb2ZpbGVJZCI6ImIwZDRiMjhiYzFkNzQ4ODlhZjBlODY2MWNlZTk2YWFiIiwicHJvZmlsZU5hbWUiOiJ4RmFpaUxlUiIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNzYwYTA4ZGE4ZDNlNzNjNWFkZGNjMTAzODk1NjU2YWM0MDRmZjQyZjJkNWI1Yjc0NmNjZGU2MDdjZTkwNDQzYyJ9fX0=]
  display name: Lootbag
  lore:
    - This is a test!
BrownLootbag:
  type: Item
  material: player_head[skull_skin=d0a7b4a9-2edc-4d9d-8ad3-4e7974c92e5d|eyJ0aW1lc3RhbXAiOjE1NjM2MzIyNjA1MDksInByb2ZpbGVJZCI6IjkxZjA0ZmU5MGYzNjQzYjU4ZjIwZTMzNzVmODZkMzllIiwicHJvZmlsZU5hbWUiOiJTdG9ybVN0b3JteSIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvODc1ZTc5NDg4ODQ3YmEwMmQ1ZTEyZTcwNDJkNzYyZTg3Y2UwOGZhODRmYjg5YzM1ZDZiNWNjY2I4YjlmNGJlZCJ9fX0=]
  display name: Lootbag
  lore:
    - A totally cool lootbag!
PinkLootbag:
  type: Item
  material: player_head[skull_skin=4374d269-3f94-49b5-a1a4-55b79fadfda0|eyJ0aW1lc3RhbXAiOjE1NjM2MzIzNjE2NjUsInByb2ZpbGVJZCI6IjkxZjA0ZmU5MGYzNjQzYjU4ZjIwZTMzNzVmODZkMzllIiwicHJvZmlsZU5hbWUiOiJTdG9ybVN0b3JteSIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMWU1NTc0YTRlZjk0ZWY0Y2EzMDBkMDJmNjQ0ZDk4YmUwN2RiZmJhN2RmNzg4MDhlOGE5YTAyMWIwNjdkOTk2ZCJ9fX0=]
  display name: Lootbag
PurpleLootbag:
  type: Item
  material: player_head[skull_skin=af2af59c-2418-4fe3-b3e7-501dc15158cc|eyJ0aW1lc3RhbXAiOjE1NjM2MzI0NTU3ODQsInByb2ZpbGVJZCI6IjNmYzdmZGY5Mzk2MzRjNDE5MTE5OWJhM2Y3Y2MzZmVkIiwicHJvZmlsZU5hbWUiOiJZZWxlaGEiLCJzaWduYXR1cmVSZXF1aXJlZCI6dHJ1ZSwidGV4dHVyZXMiOnsiU0tJTiI6eyJ1cmwiOiJodHRwOi8vdGV4dHVyZXMubWluZWNyYWZ0Lm5ldC90ZXh0dXJlLzM5YzdmMWRiMWNlMjFhZDBkMmM1ZDExMjQ2NmVlYTc5ODRkYTNhMDEzMzMwZTEwYWM5YzFlNzlkMTYwMjVlOTIifX19]
  display name: lootbag
EggLootbag:
  type: Item
  material: player_head[skull_skin=ac1ab2c2-49b6-4fe4-92fa-b94a6f31f6d7|eyJ0aW1lc3RhbXAiOjE1NjM2MzI0OTQyNTcsInByb2ZpbGVJZCI6ImIwZDRiMjhiYzFkNzQ4ODlhZjBlODY2MWNlZTk2YWFiIiwicHJvZmlsZU5hbWUiOiJ4RmFpaUxlUiIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYjEzNWM3MjcxNzlmN2Y5YWQzZjhiMDVjNzJhYTEyNzg1ZmRiMzM5MTZlMjFkYWRhMjM0YTAzY2YxYWQzNDdkMCJ9fX0=]
  display name: Lootbag
GoldenLootbag:
  type: Item
  material: player_head[skull_skin=90d5189e-3485-45fd-a81a-ff81f634859f|eyJ0aW1lc3RhbXAiOjE1NjM2MzI1Mzc4MjEsInByb2ZpbGVJZCI6ImIwZDRiMjhiYzFkNzQ4ODlhZjBlODY2MWNlZTk2YWFiIiwicHJvZmlsZU5hbWUiOiJ4RmFpaUxlUiIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvOGYxNGQxYTQ2ZjdjMWMwODQ2ODhjNjM0ZjUwZDJhZDc3ZDk4Nzk2MTlmZjg4MmNkN2RiN2U0YTJlNTA1MTlmOSJ9fX0=]
  display name: Lootbag
BlueLootbag:
  type: Item
  material: player_head[skull_skin=5221bc19-cc02-4eb1-b63b-80b1c3b3bc0c|eyJ0aW1lc3RhbXAiOjE1NjM2MzI1NzMyNzMsInByb2ZpbGVJZCI6IjgyYzYwNmM1YzY1MjRiNzk4YjkxYTEyZDNhNjE2OTc3IiwicHJvZmlsZU5hbWUiOiJOb3ROb3RvcmlvdXNOZW1vIiwic2lnbmF0dXJlUmVxdWlyZWQiOnRydWUsInRleHR1cmVzIjp7IlNLSU4iOnsidXJsIjoiaHR0cDovL3RleHR1cmVzLm1pbmVjcmFmdC5uZXQvdGV4dHVyZS83MmU2MDgxYzgyNWU4Mzk3N2E2MTQ4MjhiMTlmYWI1OGMxZjZlNjMzNzBjYjEwOTVkYTUzNTk4NDBkOGNlMTE2In19fQ==]
  display name: Lootbag
OrangeLootbag:
  type: Item
  material: player_head[skull_skin=71e22ee6-c582-4abb-8b2c-f0147839bba3|eyJ0aW1lc3RhbXAiOjE1NjM2MzI2MDcxNzUsInByb2ZpbGVJZCI6IjkxZmUxOTY4N2M5MDQ2NTZhYTFmYzA1OTg2ZGQzZmU3IiwicHJvZmlsZU5hbWUiOiJoaGphYnJpcyIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZjM0MzQ4ZDMzOWE3YmRiYjRkYzNlYTM5YzM0NDQ3Y2E3NjM4NDZiMjllMDZmNTY4ZTBjOGM1MjE5MjAzZGY5ZiJ9fX0=]
  display name: Lootbag
RedLootbag:
  type: Item
  material: player_head[skull_skin=2964405b-b366-49fa-9454-a805869f517e|eyJ0aW1lc3RhbXAiOjE1NjM2MzI1ODQzMzcsInByb2ZpbGVJZCI6IjNmYzdmZGY5Mzk2MzRjNDE5MTE5OWJhM2Y3Y2MzZmVkIiwicHJvZmlsZU5hbWUiOiJZZWxlaGEiLCJzaWduYXR1cmVSZXF1aXJlZCI6dHJ1ZSwidGV4dHVyZXMiOnsiU0tJTiI6eyJ1cmwiOiJodHRwOi8vdGV4dHVyZXMubWluZWNyYWZ0Lm5ldC90ZXh0dXJlLzIwODAwM2FlMWRlYzY0MTdiMTQwNzA0NjI3YTAwNzE5NmU1MTZhZWVjOWIzOTRhZjc4ZDcwMTkyYzhlMzUxNWQifX19]
  display name: Lootbag
WhiteLootbag:
  type: Item
  material: player_head[skull_skin=553901aa-93af-472d-9c1c-aa940145bfb5|eyJ0aW1lc3RhbXAiOjE1NjM2MzI1OTA0MDgsInByb2ZpbGVJZCI6ImIwZDczMmZlMDBmNzQwN2U5ZTdmNzQ2MzAxY2Q5OGNhIiwicHJvZmlsZU5hbWUiOiJPUHBscyIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNjE3NmE0YzQ0NmI1NGQ1MGFlM2U1YmE4ZmU2ZjQxMzE3Njg5ZmY1YTc1MjMwMjgwOTdmNjExOTUzZDFkMTI5NyJ9fX0=]
  display name: Lootbag
YellowCore:
  type: Item
  material: player_head[skull_skin=41c6ab09-7b43-4568-8f15-583e75169735|eyJ0aW1lc3RhbXAiOjE1NjM2MzMzNzc1MjksInByb2ZpbGVJZCI6IjdkYTJhYjNhOTNjYTQ4ZWU4MzA0OGFmYzNiODBlNjhlIiwicHJvZmlsZU5hbWUiOiJHb2xkYXBmZWwiLCJzaWduYXR1cmVSZXF1aXJlZCI6dHJ1ZSwidGV4dHVyZXMiOnsiU0tJTiI6eyJ1cmwiOiJodHRwOi8vdGV4dHVyZXMubWluZWNyYWZ0Lm5ldC90ZXh0dXJlL2MwODI2YmFiZTk4MzNjMGJlNjE4NDkyYmQzNjA2NTFkMjg1ZDlkNTU5YmE4OGU3N2Y0NzI3ODE3OTUwN2ZjNjYifX19]
  display name: Yellow Core

# =================================================================================
# ====================================Fossils======================================
# =================================================================================

GetAllFossils:
  type: task
  script:
    - give LimestoneFishFossil
    - give LimestonePalmLeafFossil
    - give LimestoneDinosaurTrackFossil
    - give LimestoneShellFossil
    - give LimestoneDinosaurSkullFossil
    - give LimestoneTrilobyteFossil
    - give ShaleFishFossil
    - give ShalePalmLeafFossil
    - give ShaleDinosaurTrackFossil
    - give ShaleShellFossil
    - give ShaleDinosaurSkullFossil
    - give ShaleTrilobyteFossil
    - give SandstoneFishFossil
    - give SandstonePalmLeafFossil
    - give SandstoneDinosaurTrackFossil
    - give SandstoneShellFossil
    - give SandstoneDinosaurSkullFossil
    - give SandstoneTrilobyteFossil
LimestoneFishFossil:
  type: Item
  material: player_head[skull_skin=789e8bcb-98c9-4db4-a5d1-2ebd82a05944|eyJ0aW1lc3RhbXAiOjE1NjM2MzQ4ODc5NTMsInByb2ZpbGVJZCI6IjkxZmUxOTY4N2M5MDQ2NTZhYTFmYzA1OTg2ZGQzZmU3IiwicHJvZmlsZU5hbWUiOiJoaGphYnJpcyIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvY2E0NzQ3YmFlZGExM2I1NmFlMDBlYzZlZmE3NTY1YzUwNGFhNTAxODc0ZjIzMjBjNTA3YjEyN2I3M2UxNDk2OSJ9fX0=]
  display name: Limestone Fossil
  lore:
    - A fossil, aged and
    - weathered with time.
    - This one appears to be
    - preserved in pure Limestone,
    - bearing the shape of
    - an ancient aquatic creature.
LimestonePalmLeafFossil:
  type: Item
  material: player_head[skull_skin=377a1d5f-bb9d-4208-a80b-4c38d91e1263|eyJ0aW1lc3RhbXAiOjE1NjM2MzQ4OTE3OTQsInByb2ZpbGVJZCI6IjU3MGIwNWJhMjZmMzRhOGViZmRiODBlY2JjZDdlNjIwIiwicHJvZmlsZU5hbWUiOiJMb3JkU29ubnkiLCJzaWduYXR1cmVSZXF1aXJlZCI6dHJ1ZSwidGV4dHVyZXMiOnsiU0tJTiI6eyJ1cmwiOiJodHRwOi8vdGV4dHVyZXMubWluZWNyYWZ0Lm5ldC90ZXh0dXJlL2I3OGJjZDQwZmJiOTIyOTUwYzQ3YjFmYjExNmJjMmY2OThmMzNmZDg5YjJiZTZjMWQ1MmMyMDUxOWQwMDJmNzMifX19]
  display name: Limestone Fossil
  lore:
    - A fossil, aged and
    - weathered with time.
    - This one appears to be
    - preserved in pure Limestone,
    - bearing the shape of
    - an ancient plant.
LimestoneDinosaurTrackFossil:
  type: Item
  material: player_head[skull_skin=9febecb4-f501-4a2e-b731-772cc51e861e|eyJ0aW1lc3RhbXAiOjE1NjM2MzQ5MzQ5NTEsInByb2ZpbGVJZCI6ImIwZDRiMjhiYzFkNzQ4ODlhZjBlODY2MWNlZTk2YWFiIiwicHJvZmlsZU5hbWUiOiJ4RmFpaUxlUiIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMzc5ZjYxMzM3ODIyYmVhZWVmYTVhMTAyZTlkZjk5ZmFhMjYyODYwOGJlMzkwOWFkZTBjODQ5NzZlNzY3NzNjYiJ9fX0=]
  display name: Limestone Fossil
  lore:
    - A fossil, aged and
    - weathered with time.
    - This one appears to be
    - preserved in pure Limestone,
    - bearing the shape of
    - an animal track.
LimestoneShellFossil:
  type: Item
  material: player_head[skull_skin=2616c2bb-c6ca-44b7-a5f9-51218636b13d|eyJ0aW1lc3RhbXAiOjE1NjM2MzQ4OTUzMDAsInByb2ZpbGVJZCI6IjkxZjA0ZmU5MGYzNjQzYjU4ZjIwZTMzNzVmODZkMzllIiwicHJvZmlsZU5hbWUiOiJTdG9ybVN0b3JteSIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMjk5MWQ5ZTU3M2IzM2UxYzYwOTdmYmFmMmE2YzQxMmRhYTZkNzNmMDFlNmE2YzliNzMzZjlmN2ZmYzUwZjQ0MSJ9fX0=]
  display name: Limestone Fossil
  lore:
    - A fossil, aged and
    - weathered with time.
    - This one appears to be
    - preserved in pure Limestone,
    - bearing the shape of
    - a shell.
LimestoneDinosaurSkullFossil:
  type: Item
  material: player_head[skull_skin=2f9c248e-8079-4324-a445-19bedaf96046|eyJ0aW1lc3RhbXAiOjE1NjM2MzQ5MDI2ODYsInByb2ZpbGVJZCI6ImIwZDRiMjhiYzFkNzQ4ODlhZjBlODY2MWNlZTk2YWFiIiwicHJvZmlsZU5hbWUiOiJ4RmFpaUxlUiIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZjQyOGZmNjg5NjI1YzY2OTdlMmIzNzRjYmM4YjkwOTRiYzJkMzI0NGY4NWM5OTY0NGRhNjZlYTkwM2Y0ZTExNSJ9fX0=]
  display name: Limestone Fossil
  lore:
    - A fossil, aged and
    - weathered with time.
    - This one appears to be
    - preserved in pure Limestone,
    - bearing the shape of
    - an ancient skull.
LimestoneTrilobyteFossil:
  type: Item
  material: player_head[skull_skin=08c46eb9-f4d3-431d-8dfe-2b014a65e200|eyJ0aW1lc3RhbXAiOjE1NjM2MzUxMTgzMjYsInByb2ZpbGVJZCI6IjkxZjA0ZmU5MGYzNjQzYjU4ZjIwZTMzNzVmODZkMzllIiwicHJvZmlsZU5hbWUiOiJTdG9ybVN0b3JteSIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMmZjY2Q2YjYyZTE0NjQ2MTg2M2EyYjY0ZWFkMWExNWRkODJhZTNjNGVjZWIyMTRhZGUwOWNiM2UyZTYyYjhlMiJ9fX0=]
  display name: Limestone Fossil
  lore:
    - A fossil, aged and
    - weathered with time.
    - This one appears to be
    - preserved in pure Limestone,
    - bearing the shape of
    - an ancient organism.
ShaleFishFossil:
  type: Item
  material: player_head[skull_skin=e3487b94-8ce6-4de1-adee-8dbea8a484c4|eyJ0aW1lc3RhbXAiOjE1NjM2MzUyMTc1MTUsInByb2ZpbGVJZCI6IjkxZjA0ZmU5MGYzNjQzYjU4ZjIwZTMzNzVmODZkMzllIiwicHJvZmlsZU5hbWUiOiJTdG9ybVN0b3JteSIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYjY0MzIyZjc5ZTJhNDhmZThjZjg2NzU0YzhiMmFkNGIwOGNmNmRlN2RhZDE2OGUwMjE3ZWE5Mzg5ODFjZTcwIn19fQ==]
  display name: Shale Fossil
  lore:
    - A fossil, aged and
    - weathered with time.
    - This one appears to be
    - preserved in pure
    - sedimentary shale,
    - bearing the shape of
    - an ancient aquatic creature.
ShalePalmLeafFossil:
  type: Item
  material: player_head[skull_skin=1b82dc83-54d1-4dd3-95ac-f42968bf48d6|eyJ0aW1lc3RhbXAiOjE1NjM2MzUwODY1MDgsInByb2ZpbGVJZCI6IjkxZjA0ZmU5MGYzNjQzYjU4ZjIwZTMzNzVmODZkMzllIiwicHJvZmlsZU5hbWUiOiJTdG9ybVN0b3JteSIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNGFhNmM5NmY4YWQ1NDk3ZTQ4N2E5YTRmOTU5ZTE5ZTUzNzQzMWZlZmQwNjgxYzk0MTkxMTc4NmVlZTg0N2FlZiJ9fX0=]
  display name: Shale Fossil
  lore:
    - A fossil, aged and
    - weathered with time.
    - This one appears to be
    - preserved in pure
    - sedimentary shale,
    - bearing the shape of
    - an ancient plant.
ShaleDinosaurTrackFossil:
  type: Item
  material: player_head[skull_skin=46be5aca-d849-4cd7-b764-3169f9e836a5|eyJ0aW1lc3RhbXAiOjE1NjM2MzUyNjY2NjAsInByb2ZpbGVJZCI6IjkxZjA0ZmU5MGYzNjQzYjU4ZjIwZTMzNzVmODZkMzllIiwicHJvZmlsZU5hbWUiOiJTdG9ybVN0b3JteSIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYjgyMDRmZWNjNmM2OGU2YjE1N2YwNDZlYTA4NjdhMjc4MDdmNDQyM2Q5M2QxODk5MWE3ZjQxZDNkZTlhOGFjOCJ9fX0=]
  display name: Shale Fossil
  lore:
    - A fossil, aged and
    - weathered with time.
    - This one appears to be
    - preserved in pure
    - sedimentary shale,
    - bearing the shape of
    - an animal track.
ShaleShellFossil:
  type: Item
  material: player_head[skull_skin=ff304a17-4ffc-41cb-a7f5-35c2e35e9391|eyJ0aW1lc3RhbXAiOjE1NjM2MzUxNjg3OTMsInByb2ZpbGVJZCI6IjkxZjA0ZmU5MGYzNjQzYjU4ZjIwZTMzNzVmODZkMzllIiwicHJvZmlsZU5hbWUiOiJTdG9ybVN0b3JteSIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNTdiZDlkMTcyNWU1OTQyNGYzNjFlZjFlZTJhNGQyNDNjYzg0MGNmYzRkOTVjZjBlN2Q2ZGRiNWUyNTQ1YWI1NyJ9fX0=]
  display name: Shale Fossil
  lore:
    - A fossil, aged and
    - weathered with time.
    - This one appears to be
    - preserved in pure
    - sedimentary shale,
    - bearing the shape of
    - a shell.
ShaleDinosaurSkullFossil:
  type: Item
  material: player_head[skull_skin=65b8f554-442e-40fe-bba6-5198de9cd3d7|eyJ0aW1lc3RhbXAiOjE1NjM2MzUwMDExODUsInByb2ZpbGVJZCI6IjVkMjRiYTBiMjg4YzQyOTM4YmExMGVjOTkwNjRkMjU5IiwicHJvZmlsZU5hbWUiOiIxbnYzbnQxdjN0NGwzbnQiLCJzaWduYXR1cmVSZXF1aXJlZCI6dHJ1ZSwidGV4dHVyZXMiOnsiU0tJTiI6eyJ1cmwiOiJodHRwOi8vdGV4dHVyZXMubWluZWNyYWZ0Lm5ldC90ZXh0dXJlLzU3ZWJmYzg1MDA1Yzk5NzdlMDI5MzhkZWZhOWE4NjEwNTRhMWM1OTk0MmNlNzNhMzE1OWJmZWE4NjZmMmU4MjAifX19]
  display name: Shale Fossil
  lore:
    - A fossil, aged and
    - weathered with time.
    - This one appears to be
    - preserved in pure
    - sedimentary shale,
    - bearing the shape of
    - an ancient skull.
ShaleTrilobyteFossil:
  type: Item
  material: player_head[skull_skin=a404118e-b624-4f32-b217-5a886cb77599|eyJ0aW1lc3RhbXAiOjE1NjM2MzUyNzQ1NDgsInByb2ZpbGVJZCI6ImIwZDRiMjhiYzFkNzQ4ODlhZjBlODY2MWNlZTk2YWFiIiwicHJvZmlsZU5hbWUiOiJ4RmFpaUxlUiIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNjViY2YxY2VmZTJiNjUyY2VlZWMwNjU0ZTZiMmNlZDE5YjQ0Yzc2MWFlYzg2NmM2YWExMzVkY2FkM2IyNzhlNyJ9fX0=]
  display name: Shale Fossil
  lore:
    - A fossil, aged and
    - weathered with time.
    - This one appears to be
    - preserved in pure
    - sedimentary shale,
    - bearing the shape of
    - an ancient organism.
SandstoneFishFossil:
  type: Item
  material: player_head[skull_skin=796e6fcb-176e-4ff0-9f92-534c920e1228|eyJ0aW1lc3RhbXAiOjE1NjM2MzUzMTI0MjksInByb2ZpbGVJZCI6IjNmYzdmZGY5Mzk2MzRjNDE5MTE5OWJhM2Y3Y2MzZmVkIiwicHJvZmlsZU5hbWUiOiJZZWxlaGEiLCJzaWduYXR1cmVSZXF1aXJlZCI6dHJ1ZSwidGV4dHVyZXMiOnsiU0tJTiI6eyJ1cmwiOiJodHRwOi8vdGV4dHVyZXMubWluZWNyYWZ0Lm5ldC90ZXh0dXJlL2IwMTVjMmZhZDQzMjA5NDA4YjM5ODk0ZTNlZWVmY2VmM2M5ZGIzMDQ5YWViOGM5MDFiOTUwYWY3NWUyNDRkMWMifX19]
  display name: Sandstone Fossil
  lore:
    - A fossil, aged and
    - weathered with time.
    - This one appears to be
    - preserved in sandstone,
    - bearing the shape of
    - an ancient aquatic creature.
SandstonePalmLeafFossil:
  type: Item
  material: player_head[skull_skin=79c544fe-6fc0-417d-9bab-173919fd2fd9|eyJ0aW1lc3RhbXAiOjE1NjM2MzUzMDQ4MDIsInByb2ZpbGVJZCI6IjdkYTJhYjNhOTNjYTQ4ZWU4MzA0OGFmYzNiODBlNjhlIiwicHJvZmlsZU5hbWUiOiJHb2xkYXBmZWwiLCJzaWduYXR1cmVSZXF1aXJlZCI6dHJ1ZSwidGV4dHVyZXMiOnsiU0tJTiI6eyJ1cmwiOiJodHRwOi8vdGV4dHVyZXMubWluZWNyYWZ0Lm5ldC90ZXh0dXJlLzU0ZWI2ODMyZDM0Y2Y0M2VkNTRmOTBhNTUyMTE4MzBkNTE0MTA2YjJhYTc2ZWE4ZWVmOWNhMTk4ODI0ZjNmZjgifX19]
  display name: Sandstone Fossil
  lore:
    - A fossil, aged and
    - weathered with time.
    - This one appears to be
    - preserved in sandstone,
    - bearing the shape of
    - an ancient plant.
SandstoneDinosaurTrackFossil:
  type: Item
  material: player_head[skull_skin=e0104aa6-828d-4166-b06b-632d7ff87266|eyJ0aW1lc3RhbXAiOjE1NjM2MzUzMjU3MjYsInByb2ZpbGVJZCI6IjkxZjA0ZmU5MGYzNjQzYjU4ZjIwZTMzNzVmODZkMzllIiwicHJvZmlsZU5hbWUiOiJTdG9ybVN0b3JteSIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZjQ5YjZjMmQwNjBjOTdhMzkxMmJmYTA2MjBkOThjODdhMmE1YzQyZTI5MjBiMzMzZTEwY2IwNDFiNjk3MjY1OSJ9fX0=]
  display name: Sandstone Fossil
  lore:
    - A fossil, aged and
    - weathered with time.
    - This one appears to be
    - preserved in sandstone,
    - bearing the shape of
    - an animal track.
SandstoneShellFossil:
  type: Item
  material: player_head[skull_skin=3bcdf98e-5ac6-424c-a9ec-9cc1d9189d12|eyJ0aW1lc3RhbXAiOjE1NjM2MzU0NDgwMTUsInByb2ZpbGVJZCI6IjkxZjA0ZmU5MGYzNjQzYjU4ZjIwZTMzNzVmODZkMzllIiwicHJvZmlsZU5hbWUiOiJTdG9ybVN0b3JteSIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZDU1OGI3N2E3YjlkMThkNGUwNzBmZDc3YjkwNzk5YzJjYjU3NGViY2Q3NjEwMzZkOTgyNDk3MDQ5OTU4YWY3NCJ9fX0=]
  display name: Sandstone Fossil
  lore:
    - A fossil, aged and
    - weathered with time.
    - This one appears to be
    - preserved in sandstone,
    - bearing the shape of
    - a shell.
SandstoneDinosaurSkullFossil:
  type: Item
  material: player_head[skull_skin=815b5e15-46d6-4f8f-8e33-db0062cb4118|eyJ0aW1lc3RhbXAiOjE1NjM2MzU0NTMwNzEsInByb2ZpbGVJZCI6ImIwZDRiMjhiYzFkNzQ4ODlhZjBlODY2MWNlZTk2YWFiIiwicHJvZmlsZU5hbWUiOiJ4RmFpaUxlUiIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYjEzOThiZWFlMDU5MmQ0OTEyZDNhMDViOWVmYzdkOTdjNGRhYTA0OWNhOTk2YzI0OGE3ZjhiYTgzZTZiOTRjOCJ9fX0=]
  display name: Sandstone Fossil
  lore:
    - A fossil, aged and
    - weathered with time.
    - This one appears to be
    - preserved in sandstone,
    - bearing the shape of
    - an ancient skull.
SandstoneTrilobyteFossil:
  type: Item
  material: player_head[skull_skin=4c3b7f6f-4c7c-44c1-b8dd-1e627293f60e|eyJ0aW1lc3RhbXAiOjE1NjM2MzU0NzE2MzMsInByb2ZpbGVJZCI6IjVkMjRiYTBiMjg4YzQyOTM4YmExMGVjOTkwNjRkMjU5IiwicHJvZmlsZU5hbWUiOiIxbnYzbnQxdjN0NGwzbnQiLCJzaWduYXR1cmVSZXF1aXJlZCI6dHJ1ZSwidGV4dHVyZXMiOnsiU0tJTiI6eyJ1cmwiOiJodHRwOi8vdGV4dHVyZXMubWluZWNyYWZ0Lm5ldC90ZXh0dXJlL2MyZjE1ZDk2ODA2N2M0N2VkZmNhZTNiZjA1MmEyMDdmOTVjODdkODA4ZmM1NjY4MzQwMDhkYjk4NDczMDg3ZjcifX19]
  display name: Sandstone Fossil
  lore:
    - A fossil, aged and
    - weathered with time.
    - This one appears to be
    - preserved in sandstone,
    - bearing the shape of
    - an ancient organism.

# =================================================================================
# ====================================Geodes=======================================
# =================================================================================

GetAllGeodes:
  type: task
  script:
    - give QuartzGeode
    - give AmethystGeode
    - give EmeraldGeode
    - give SapphireGeode
    - give RoseQuartzGeode
    - give NetherQuartzGeode
QuartzGeode:
  type: Item
  material: player_head[skull_skin=bdcc3590-421f-4b49-a201-fcb22cf649bc|eyJ0aW1lc3RhbXAiOjE1NjM2NDUwMjQ4MDgsInByb2ZpbGVJZCI6IjNmYzdmZGY5Mzk2MzRjNDE5MTE5OWJhM2Y3Y2MzZmVkIiwicHJvZmlsZU5hbWUiOiJZZWxlaGEiLCJzaWduYXR1cmVSZXF1aXJlZCI6dHJ1ZSwidGV4dHVyZXMiOnsiU0tJTiI6eyJ1cmwiOiJodHRwOi8vdGV4dHVyZXMubWluZWNyYWZ0Lm5ldC90ZXh0dXJlLzg3ZDFmMGE3OTJkOWU5MTQ0NzdkYWRlNzEyNjM3ZjlkMWVhMWUwNTU1ZWU0YmIyZWRmZTIwYTg3NTk1OTA4ZTgifX19]
  display name: Geode
AmethystGeode:
  type: Item
  material: player_head[skull_skin=2b8e6634-76c5-4926-b9d8-b31d03a5e957|eyJ0aW1lc3RhbXAiOjE1NjM2NDUwMzIwOTgsInByb2ZpbGVJZCI6IjkxZjA0ZmU5MGYzNjQzYjU4ZjIwZTMzNzVmODZkMzllIiwicHJvZmlsZU5hbWUiOiJTdG9ybVN0b3JteSIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvOGQxMTk4YTU1YmY3YWQwN2Q4Mjg2M2U4MTM0NTk5OGJiNDAwMDZkZGZkZjVhOTk2ZmNlZDhiNTMxYTAzNTBhOCJ9fX0=]
  display name: Geode
EmeraldGeode:
  type: Item
  material: player_head[skull_skin=fd5eb42d-05e9-44e1-b615-024ac87c37e9|eyJ0aW1lc3RhbXAiOjE1NjM2NDUwNjMxMDksInByb2ZpbGVJZCI6IjNmYzdmZGY5Mzk2MzRjNDE5MTE5OWJhM2Y3Y2MzZmVkIiwicHJvZmlsZU5hbWUiOiJZZWxlaGEiLCJzaWduYXR1cmVSZXF1aXJlZCI6dHJ1ZSwidGV4dHVyZXMiOnsiU0tJTiI6eyJ1cmwiOiJodHRwOi8vdGV4dHVyZXMubWluZWNyYWZ0Lm5ldC90ZXh0dXJlLzExZGI3MWVkMTMzYTA3NzJkZGNmYjQyNDA1MmNiZTI3OWQ3YjEzZjRhMWFhNjg5ZDQ0YjdlN2JjMTUyYTdmNjUifX19]
  display name: Geode
SapphireGeode:
  type: Item
  material: player_head[skull_skin=f53df1c9-2d93-4814-9f5f-df19b8c62919|eyJ0aW1lc3RhbXAiOjE1NjM2NDUwNDQ0NDQsInByb2ZpbGVJZCI6ImIwZDczMmZlMDBmNzQwN2U5ZTdmNzQ2MzAxY2Q5OGNhIiwicHJvZmlsZU5hbWUiOiJPUHBscyIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvOTU1NDQwZWVlMzZiZmRhODkzMTZlYzc4NjZmNDMzMzJlNzA1ZWMyN2UyMjk3ZTFiMjZlMjVlYzMyOGI3Yjk0OSJ9fX0=]
  display name: Geode
RoseQuartzGeode:
  type: Item
  material: player_head[skull_skin=616bb4ef-75db-44e0-891a-b0aa743b7e1f|eyJ0aW1lc3RhbXAiOjE1NjM2NDUwNDk0MjgsInByb2ZpbGVJZCI6IjkxZmUxOTY4N2M5MDQ2NTZhYTFmYzA1OTg2ZGQzZmU3IiwicHJvZmlsZU5hbWUiOiJoaGphYnJpcyIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZmE2NTlhNmU4NGIxYjY5Yzg5MmYwMjU5ODU4MDI4ZWNiN2M3NmNkMGY2MmQwNDBkMjQ3MzI4ZTZiNGEwNDAzIn19fQ==]
  display name: Geode
NetherQuartzGeode:
  type: Item
  material: player_head[skull_skin=5c75b889-30c9-42c9-834d-9ca693aab587|eyJ0aW1lc3RhbXAiOjE1NjM2NDUwNTQwMzMsInByb2ZpbGVJZCI6IjU3MGIwNWJhMjZmMzRhOGViZmRiODBlY2JjZDdlNjIwIiwicHJvZmlsZU5hbWUiOiJMb3JkU29ubnkiLCJzaWduYXR1cmVSZXF1aXJlZCI6dHJ1ZSwidGV4dHVyZXMiOnsiU0tJTiI6eyJ1cmwiOiJodHRwOi8vdGV4dHVyZXMubWluZWNyYWZ0Lm5ldC90ZXh0dXJlLzZmNDY2ODJkMTY4ODk5NDEyMmVmNzljOTdlODI3NDI4MzAwM2M1ZmJiMzIyZDc3ZDIxNzlmM2Y2MjRiNWE0MzIifX19]
  display name: Geode

# =================================================================================
# ====================================Potions======================================
# =================================================================================

GetAllOils:
  type: task
  script:
    - give PoisonOil
    - give LavenderOil
    - give LemongrassOil
    - give OrangeOil
    - give PeppermintOil
    - give PufferfishPoisonOil
    - give EucalyptusOil
PoisonOil:
  type: Item
  material: player_head[skull_skin=9b7d67ea-6af0-490c-93d6-b10a5bcee637|eyJ0aW1lc3RhbXAiOjE1NjM2NDYxODM5MTQsInByb2ZpbGVJZCI6IjkxZmUxOTY4N2M5MDQ2NTZhYTFmYzA1OTg2ZGQzZmU3IiwicHJvZmlsZU5hbWUiOiJoaGphYnJpcyIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMjdkYjZlMzI1ZmE4MmU5MmRiMmMzNWRiODY2MzA0OTk5N2Q4NjRkYzU1YzI4NzRlZWJkYTlkNTAwODZlYjVhNyJ9fX0=]
  display name: Oil
LavenderOil:
  type: Item
  material: player_head[skull_skin=8e541e90-837c-4c02-87e7-9cf35e4be8d3|eyJ0aW1lc3RhbXAiOjE1NjM2NDYxNDgyMTAsInByb2ZpbGVJZCI6IjgyYzYwNmM1YzY1MjRiNzk4YjkxYTEyZDNhNjE2OTc3IiwicHJvZmlsZU5hbWUiOiJOb3ROb3RvcmlvdXNOZW1vIiwic2lnbmF0dXJlUmVxdWlyZWQiOnRydWUsInRleHR1cmVzIjp7IlNLSU4iOnsidXJsIjoiaHR0cDovL3RleHR1cmVzLm1pbmVjcmFmdC5uZXQvdGV4dHVyZS85YzgzZGEwMDlkNWY1NmExNGQzN2IxMDExZGJkYmU4ODI3OGMxYTUzMTY5NTUwZTlhOGVlNjk0MTZiODIzM2YwIn19fQ==]
  display name: Oil
LemongrassOil:
  type: Item
  material: player_head[skull_skin=509ff7cb-b2b3-4ce6-b45c-67a92495bf42|eyJ0aW1lc3RhbXAiOjE1NjM2NDYyMDQ5MzUsInByb2ZpbGVJZCI6IjU3MGIwNWJhMjZmMzRhOGViZmRiODBlY2JjZDdlNjIwIiwicHJvZmlsZU5hbWUiOiJMb3JkU29ubnkiLCJzaWduYXR1cmVSZXF1aXJlZCI6dHJ1ZSwidGV4dHVyZXMiOnsiU0tJTiI6eyJ1cmwiOiJodHRwOi8vdGV4dHVyZXMubWluZWNyYWZ0Lm5ldC90ZXh0dXJlLzQ1NzI4ODU0NGZlYmFkMzNmNDVjMDIzY2E4MWNmOGI1NDIzOWU3NmRjMzY2YzBiZWQ1NjI1MTFlN2FkOWEyNDAifX19]
  display name: Oil
OrangeOil:
  type: Item
  material: player_head[skull_skin=6af8bdae-ccb8-4d73-8445-aa66ccbee13d|eyJ0aW1lc3RhbXAiOjE1NjM2NDYxNTc0MTksInByb2ZpbGVJZCI6ImIwZDRiMjhiYzFkNzQ4ODlhZjBlODY2MWNlZTk2YWFiIiwicHJvZmlsZU5hbWUiOiJ4RmFpaUxlUiIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZmMwZTdiMWIwZGU3OTRiOGQzMzgwNjdmY2JlMTA3N2U0MTUzYzU1NGY5OWE3ZjUzN2I1MWQ0N2NlYzNiN2Q3ZCJ9fX0=]
  display name: Oil
PeppermintOil:
  type: Item
  material: player_head[skull_skin=ddb410b0-c0c3-4661-b53e-91606e036fdb|eyJ0aW1lc3RhbXAiOjE1NjM2NDYxNjIxNDksInByb2ZpbGVJZCI6IjkxZjA0ZmU5MGYzNjQzYjU4ZjIwZTMzNzVmODZkMzllIiwicHJvZmlsZU5hbWUiOiJTdG9ybVN0b3JteSIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZjM0ZmVhNmUyNDljN2JhZGY3NjNmYjgxNjBmOWZhNmE5MWJkYmM4NWEwOWE2ZWU1MWJmZjE3MGVhZWQxMGYzOCJ9fX0=]
  display name: Oil
PufferfishPoisonOil:
  type: Item
  material: player_head[skull_skin=4b80e623-2ed8-46af-a5a0-126cdded9560|eyJ0aW1lc3RhbXAiOjE1NjM2NDYxOTIyMzMsInByb2ZpbGVJZCI6ImIwZDRiMjhiYzFkNzQ4ODlhZjBlODY2MWNlZTk2YWFiIiwicHJvZmlsZU5hbWUiOiJ4RmFpaUxlUiIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvODNiMzBlMTZlMTU2NjZlZTgyZmU2OGFmN2YxYjE3M2QwN2UwYzZkMTM4YmJlMzRjZjEwYjUxOTE5NDFkNjFiNSJ9fX0=]
  display name: Oil
EucalyptusOil:
  type: Item
  material: player_head[skull_skin=102baa1d-96f2-46a7-a6b4-dced3b9b68af|eyJ0aW1lc3RhbXAiOjE1NjM2NDYyMjA3MjIsInByb2ZpbGVJZCI6ImRkZWQ1NmUxZWY4YjQwZmU4YWQxNjI5MjBmN2FlY2RhIiwicHJvZmlsZU5hbWUiOiJEaXNjb3JkQXBwIiwic2lnbmF0dXJlUmVxdWlyZWQiOnRydWUsInRleHR1cmVzIjp7IlNLSU4iOnsidXJsIjoiaHR0cDovL3RleHR1cmVzLm1pbmVjcmFmdC5uZXQvdGV4dHVyZS83NDYxN2JhMWZhNmU4YzYwZmEwOTgzOTE0MWFmMjMwNGE3MGQzMGQwMGRhMDNmMzI0MjY3ZGZiMWM0M2QxMTBlIn19fQ==]
  display name: Oil

# =================================================================================
# ====================================Firework Stars===============================
# =================================================================================

GetAllStars:
  type: task
  script:
    - give LightGreenStar
    - give YellowStar
    - give RedStar
    - give PurpleStar
    - give LightBlueStar
    - give WhiteStar
    - give PinkStar
    - give OrangeStar
    - give MagentaStar
    - give LimeStar
    - give LightGrayStar
    - give SkyBlueStar
    - give GreenStar
    - give GrayStar
    - give CyanStar
    - give BrownStar
    - give BlackStar
LightGreenStar:
  type: Item
  material: player_head[skull_skin=cdde0eb0-680d-4b55-824c-9a0d35838049|eyJ0aW1lc3RhbXAiOjE1NjM2NDc0MDg5MjEsInByb2ZpbGVJZCI6IjkxZjA0ZmU5MGYzNjQzYjU4ZjIwZTMzNzVmODZkMzllIiwicHJvZmlsZU5hbWUiOiJTdG9ybVN0b3JteSIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNTJkYjlmOWEzNjRmZTQzOGMwZGU1ZjQ5ODQwN2E5ODc2ZDRiOGIxM2ViM2E1YTQwNWZhZTJiNDI1YzRkNWMwMiJ9fX0=]
  display name: Star
YellowStar:
  type: Item
  material: player_head[skull_skin=0ad61031-c91f-49d8-8159-a286973fa19c|eyJ0aW1lc3RhbXAiOjE1NjM2NDc0MTYwMzksInByb2ZpbGVJZCI6IjU2Njc1YjIyMzJmMDRlZTA4OTE3OWU5YzkyMDZjZmU4IiwicHJvZmlsZU5hbWUiOiJUaGVJbmRyYSIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMmJiM2NjOTM5MzUwNGQ0YzAzZTNmYzQ3NThlZDliMTY3MTE1ZGFhYmZjM2MwZWRhYmYwODgzYTFhNjU2ZDc5YSJ9fX0=]
  display name: Star
RedStar:
  type: Item
  material: player_head[skull_skin=526623d2-7e35-433d-9090-9d8212d364e7|eyJ0aW1lc3RhbXAiOjE1NjM2NDc0MjEzNjQsInByb2ZpbGVJZCI6Ijc1MTQ0NDgxOTFlNjQ1NDY4Yzk3MzlhNmUzOTU3YmViIiwicHJvZmlsZU5hbWUiOiJUaGFua3NNb2phbmciLCJzaWduYXR1cmVSZXF1aXJlZCI6dHJ1ZSwidGV4dHVyZXMiOnsiU0tJTiI6eyJ1cmwiOiJodHRwOi8vdGV4dHVyZXMubWluZWNyYWZ0Lm5ldC90ZXh0dXJlLzg1OGNmZjRlNzBmMGExN2VmYTIyNTZhMDhhY2QxNTVmZmEzMDQwMGRhNzJhYjNkOGIxZTEzYmRhOTU1NzZhYSJ9fX0=]
  display name: Star
PurpleStar:
  type: Item
  material: player_head[skull_skin=96d8d735-c634-4b3d-8837-9afdcd84c50e|eyJ0aW1lc3RhbXAiOjE1NjM2NDc0OTAyNDAsInByb2ZpbGVJZCI6IjkxZjA0ZmU5MGYzNjQzYjU4ZjIwZTMzNzVmODZkMzllIiwicHJvZmlsZU5hbWUiOiJTdG9ybVN0b3JteSIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZTU2Y2RjYjUxZWQzNzFiODBkYTRhYmI0ZGM0YzI4YzcxNDliOGU3MzFmYWQ1NTUxM2E4YjVmZDdiN2FiNmI5NiJ9fX0=]
  display name: Star
LightBlueStar:
  type: Item
  material: player_head[skull_skin=8b7e80a0-4504-4d3e-baf7-1a4458a18129|eyJ0aW1lc3RhbXAiOjE1NjM2NDc2MTUzNzEsInByb2ZpbGVJZCI6ImIwZDRiMjhiYzFkNzQ4ODlhZjBlODY2MWNlZTk2YWFiIiwicHJvZmlsZU5hbWUiOiJ4RmFpaUxlUiIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMjdkYjRmY2ExZDc1ZmY4MmVmZGViNzU1M2U5YTVkZWUyZGJlNjJiODIyYzkxNzgyZjFmZGY5ODdhNzQ2N2U1NCJ9fX0=]
  display name: Star
WhiteStar:
  type: Item
  material: player_head[skull_skin=0583c72b-45c6-4fd1-b107-29b82a41fd22|eyJ0aW1lc3RhbXAiOjE1NjM2NDc0Mzc3MTIsInByb2ZpbGVJZCI6IjgyYzYwNmM1YzY1MjRiNzk4YjkxYTEyZDNhNjE2OTc3IiwicHJvZmlsZU5hbWUiOiJOb3ROb3RvcmlvdXNOZW1vIiwic2lnbmF0dXJlUmVxdWlyZWQiOnRydWUsInRleHR1cmVzIjp7IlNLSU4iOnsidXJsIjoiaHR0cDovL3RleHR1cmVzLm1pbmVjcmFmdC5uZXQvdGV4dHVyZS84YzUwNjNmOTU3NjU3MGE4OTM5MDA2MjA3NjU5OTg5ZmY4MWI5Yzg3YTI4Y2UzNDE3Y2FhZTgyYjZlN2Q2MmUifX19]
  display name: Star
PinkStar:
  type: Item
  material: player_head[skull_skin=7bfbec6e-c241-4a11-9baf-bf568c9e2991|eyJ0aW1lc3RhbXAiOjE1NjM2NDc0NTg3MzQsInByb2ZpbGVJZCI6IjkxZjA0ZmU5MGYzNjQzYjU4ZjIwZTMzNzVmODZkMzllIiwicHJvZmlsZU5hbWUiOiJTdG9ybVN0b3JteSIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZDk4ODZiZjFlODBkYWZiM2RkY2JlNGI1NGMzOTBiYzUwYmEyOTcwZjU1YjNjMTgwMDlkOTYyNjliYzE1NDFhNiJ9fX0=]
  display name: Star
OrangeStar:
  type: Item
  material: player_head[skull_skin=2dc4965d-e160-43f9-adc9-f404899384c9|eyJ0aW1lc3RhbXAiOjE1NjM2NDc0NDkyMTAsInByb2ZpbGVJZCI6ImIwZDczMmZlMDBmNzQwN2U5ZTdmNzQ2MzAxY2Q5OGNhIiwicHJvZmlsZU5hbWUiOiJPUHBscyIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNGM4MjNjOGU1M2QzYWU3NTNjMTkxYzUxZmU2Njc5MTE1MjczMzA2NDFhMDE2YTEzMzI1MDIzYTM5OWYwMTcyYSJ9fX0=]
  display name: Star
MagentaStar:
  type: Item
  material: player_head[skull_skin=0ac75e42-17b2-4c74-8238-5c34cd1f3aa5|eyJ0aW1lc3RhbXAiOjE1NjM2NDc0Njg0ODIsInByb2ZpbGVJZCI6ImIwZDRiMjhiYzFkNzQ4ODlhZjBlODY2MWNlZTk2YWFiIiwicHJvZmlsZU5hbWUiOiJ4RmFpaUxlUiIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvODFhZTc0ZjFkYjRhMWVkYTI2MDJjNjMwMDM5YWIyYTcyY2MxNWI5MzZhMmFmZTE2ZTU0ZDcwYjFiY2EwZTI2MCJ9fX0=]
  display name: Star
LimeStar:
  type: Item
  material: player_head[skull_skin=957327ac-5004-4895-ab91-2b7681e9c26d|eyJ0aW1lc3RhbXAiOjE1NjM2NDc0NzIxNzgsInByb2ZpbGVJZCI6ImRkZWQ1NmUxZWY4YjQwZmU4YWQxNjI5MjBmN2FlY2RhIiwicHJvZmlsZU5hbWUiOiJEaXNjb3JkQXBwIiwic2lnbmF0dXJlUmVxdWlyZWQiOnRydWUsInRleHR1cmVzIjp7IlNLSU4iOnsidXJsIjoiaHR0cDovL3RleHR1cmVzLm1pbmVjcmFmdC5uZXQvdGV4dHVyZS84NWQ4MDY4ZTc2MDE4YzllYmZkZjhhMGU5MDIwNjY0MmFiN2I5ZTQyMzFhMDViYTJhNjM3NGUwZWU0MjI0YjAwIn19fQ==]
  display name: Star
LightGrayStar:
  type: Item
  material: player_head[skull_skin=ae80f47e-2386-44cd-b236-a316f10dc857|eyJ0aW1lc3RhbXAiOjE1NjM2NDc0NjQ2OTAsInByb2ZpbGVJZCI6IjU3MGIwNWJhMjZmMzRhOGViZmRiODBlY2JjZDdlNjIwIiwicHJvZmlsZU5hbWUiOiJMb3JkU29ubnkiLCJzaWduYXR1cmVSZXF1aXJlZCI6dHJ1ZSwidGV4dHVyZXMiOnsiU0tJTiI6eyJ1cmwiOiJodHRwOi8vdGV4dHVyZXMubWluZWNyYWZ0Lm5ldC90ZXh0dXJlLzM4Mzg1YTVhNDY5ODIxYjhiMzNlNDdhNWI1YzQyYWVhNTk2NjM0NjU0NjkzODhhMWE0ZDRlNTIzZTVhOGRkZDIifX19]
  display name: Star
SkyBlueStar:
  type: Item
  material: player_head[skull_skin=6f87e9c4-472a-47ba-b4b4-6663dca0d33f|eyJ0aW1lc3RhbXAiOjE1NjM2NDc1MDczMzEsInByb2ZpbGVJZCI6IjdkYTJhYjNhOTNjYTQ4ZWU4MzA0OGFmYzNiODBlNjhlIiwicHJvZmlsZU5hbWUiOiJHb2xkYXBmZWwiLCJzaWduYXR1cmVSZXF1aXJlZCI6dHJ1ZSwidGV4dHVyZXMiOnsiU0tJTiI6eyJ1cmwiOiJodHRwOi8vdGV4dHVyZXMubWluZWNyYWZ0Lm5ldC90ZXh0dXJlL2Q1ZWQ1YzczMjRjMTYzYmRiODVkNWZlZjVjYmIzMzg2ZDkzNDcyN2E1NDFlYmMxMTAxZDQ5Y2Q4OTYwMzQ4ZWIifX19]
  display name: Star
GreenStar:
  type: Item
  material: player_head[skull_skin=ee9bc3a6-adff-4075-971f-13eb12953b99|eyJ0aW1lc3RhbXAiOjE1NjM2NDc0Nzc2NjcsInByb2ZpbGVJZCI6IjNmYzdmZGY5Mzk2MzRjNDE5MTE5OWJhM2Y3Y2MzZmVkIiwicHJvZmlsZU5hbWUiOiJZZWxlaGEiLCJzaWduYXR1cmVSZXF1aXJlZCI6dHJ1ZSwidGV4dHVyZXMiOnsiU0tJTiI6eyJ1cmwiOiJodHRwOi8vdGV4dHVyZXMubWluZWNyYWZ0Lm5ldC90ZXh0dXJlLzk2NGFkOGRhMzE5ZTZlYjM3NzIxZTAyYzc4ODY0OTkwYjQ1ZmMwZmVhMDZlZTUyZWQ0YzI0YWMxOTcyNzhjYjcifX19]
  display name: Star
GrayStar:
  type: Item
  material: player_head[skull_skin=e5202fb5-e45b-4c6b-a9f7-66662a4140d8|eyJ0aW1lc3RhbXAiOjE1NjM2NDc1MjEyODgsInByb2ZpbGVJZCI6IjkxZjA0ZmU5MGYzNjQzYjU4ZjIwZTMzNzVmODZkMzllIiwicHJvZmlsZU5hbWUiOiJTdG9ybVN0b3JteSIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNWU1YmMxY2Y4NmU0OTkwNjU0M2MzMTY5OWJlNjdmNjJmZGQ3ZjY1YzgzNjNjZjIwNTkyZGI1N2ExNTExNjZkZSJ9fX0=]
  display name: Star
CyanStar:
  type: Item
  material: player_head[skull_skin=2d9ba18e-7ed2-4b1e-bc41-95d7d53fc2f0|eyJ0aW1lc3RhbXAiOjE1NjM2NDc1MTY5NzUsInByb2ZpbGVJZCI6IjNmYzdmZGY5Mzk2MzRjNDE5MTE5OWJhM2Y3Y2MzZmVkIiwicHJvZmlsZU5hbWUiOiJZZWxlaGEiLCJzaWduYXR1cmVSZXF1aXJlZCI6dHJ1ZSwidGV4dHVyZXMiOnsiU0tJTiI6eyJ1cmwiOiJodHRwOi8vdGV4dHVyZXMubWluZWNyYWZ0Lm5ldC90ZXh0dXJlLzI4ZjkyMzUzZmQ1MmQwZWVkNjU3ZDk5N2VhODE0OWM4MjVkMzY2YjAyOGMxNTE0YmQ5ZWNhYWYyNDNmYjdiYzYifX19]
  display name: Star
BrownStar:
  type: Item
  material: player_head[skull_skin=7a669cf6-ee56-453e-acc7-40228868d1af|eyJ0aW1lc3RhbXAiOjE1NjM2NDc1MzQwMDcsInByb2ZpbGVJZCI6IjJjMTA2NGZjZDkxNzQyODI4NGUzYmY3ZmFhN2UzZTFhIiwicHJvZmlsZU5hbWUiOiJOYWVtZSIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMTZhMThmOWQxYWU1YWIwNDQ2MTEyN2UzMWM1MTkwYzc2YjQ0MmRhNTAyODc3YWE2NDdmZDAzNDA1MDdiMzNhNSJ9fX0=]
  display name: Star
BlackStar:
  type: Item
  material: player_head[skull_skin=a1b0559e-5b66-464f-885e-4447aadaeed0|eyJ0aW1lc3RhbXAiOjE1NjM2NDc1MDAxMDAsInByb2ZpbGVJZCI6ImIwZDRiMjhiYzFkNzQ4ODlhZjBlODY2MWNlZTk2YWFiIiwicHJvZmlsZU5hbWUiOiJ4RmFpaUxlUiIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYmQ3NDk5NWQ2Y2RhMmI4YTI0NzcyYWY5NjllZjA3N2FlM2E4NWUyMzU3YzZmNjExOWI4YTI1MDYwNDFhNDQ4YiJ9fX0=]
  display name: Star

# =================================================================================
# ====================================Ores=========================================
# =================================================================================

BabyDiamondOre:
  type: Item
  material: player_head[skull_skin=498ccdc4-e5b0-457d-8589-16301be33d76|eyJ0aW1lc3RhbXAiOjE1NjM3MzQzNzEzNTEsInByb2ZpbGVJZCI6IjU3MGIwNWJhMjZmMzRhOGViZmRiODBlY2JjZDdlNjIwIiwicHJvZmlsZU5hbWUiOiJMb3JkU29ubnkiLCJzaWduYXR1cmVSZXF1aXJlZCI6dHJ1ZSwidGV4dHVyZXMiOnsiU0tJTiI6eyJ1cmwiOiJodHRwOi8vdGV4dHVyZXMubWluZWNyYWZ0Lm5ldC90ZXh0dXJlLzQ1ODhlZDQzMThhMzE1YjY0NjVhYjliYTI2MzlhMzZlOGRiMTU1ZTI5M2Q5ZDc3NDM0YmRlZGZjMGI0YTE0NjgifX19]
  display name: Baby Diamond Ore
SapphireOreExtract:
  type: Item
  material: player_head[skull_skin=10d33f14-fd75-46fc-ab7e-9736ca3ba30b|eyJ0aW1lc3RhbXAiOjE1NjM3MzQzNzU1MjAsInByb2ZpbGVJZCI6ImRkZWQ1NmUxZWY4YjQwZmU4YWQxNjI5MjBmN2FlY2RhIiwicHJvZmlsZU5hbWUiOiJEaXNjb3JkQXBwIiwic2lnbmF0dXJlUmVxdWlyZWQiOnRydWUsInRleHR1cmVzIjp7IlNLSU4iOnsidXJsIjoiaHR0cDovL3RleHR1cmVzLm1pbmVjcmFmdC5uZXQvdGV4dHVyZS82OTYzOTRiYzMzZDI2ODMzNDZlYmVjNmIxZWExNjljZWM2YTUzNWViMzVkNDE5OGEwYTVkM2RjYzRlODAwYTQwIn19fQ==]
  display name: Sapphire Extract
StoneOreExtract:
  type: Item
  material: player_head[skull_skin=cd7d82d3-fc84-4e7a-a71e-c61cf94d2d0f|eyJ0aW1lc3RhbXAiOjE1NjM3MzQzNjY2NzQsInByb2ZpbGVJZCI6IjkxZmUxOTY4N2M5MDQ2NTZhYTFmYzA1OTg2ZGQzZmU3IiwicHJvZmlsZU5hbWUiOiJoaGphYnJpcyIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZjY5OWMxNGIxZWQ1NjQ1YjUxNWEwMjI4NjIzMzI5NGI2YWQ3YTBhYjcxZTJhYThiMjJiM2JmNmFkYWI5M2U4NSJ9fX0=]
  display name: Stone Extract

# =================================================================================
# ====================================Misc=========================================
# =================================================================================

RopeCoilAnchor:
  type: Item
  material: player_head[skull_skin=392c6d6c-0b7e-4627-bd39-353960b2a43d|eyJ0aW1lc3RhbXAiOjE1NjM2MzU0ODUzNzQsInByb2ZpbGVJZCI6IjJkYzc3YWU3OTQ2MzQ4MDI5NDI4MGM4NDIyNzRiNTY3IiwicHJvZmlsZU5hbWUiOiJzYWR5MDYxMCIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYmZiM2M2ZTY2NTU0ODZlNzY3YTYwZDg3ODExY2E1Y2RkYzMzY2NmZjEyNjQ5YTM0Y2I2OTY4NjFhNjNjOGM1ZCJ9fX0=]
  display name: Fossil
DumbCobblestone:
  type: item
  material: cobblestone
  display name: Dumb Cobblestone
  lore:
    - It<&sq>s a rock.
DumbStone:
  type: item
  material: Stone
  display name: Stupid Stone
  lore:
    - A rock. Duh.
PowerOrb:
  type: item
  material: player_head[skull_skin=90bf6df9-eaae-48bc-b5ac-04a17594589a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvM2E3Y2RhOTAwNGZjMTk3ZDY2YWZiYzJiMDAzYTViOWVmMTNjZjQ2MDBiMWZjNzQ5MDA2NzU5MGYwNDcxODFlIn19fQ==]
  display name: <&b>Power Cube
MachineCore:
  type: item
  material: player_head[skull_skin=cfdea2d7-2234-44ad-bb83-cd64e7380167|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvM2ZjYzI2MTg5Y2Y4Mzk0ZGFiYzVkZTlmZjE5NjRmMmVkMGU2ZTQyODg3MTc1ZjdiZTIyZTYwNmQ0MDQ4N2RkIn19fQ==]
  display name: <&e>Machine Core

# Candles
SweetCandle:
  type: item
  material: player_head[skull_skin=edd6c805-f813-4ef6-b3b0-569c8b444242|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNzgxMjI2NjU2ZDgyNTI5MWIxZDdlNDU2Yjc0ZWNkY2UyODY3MjE2OTY0MWU2YzM1YjFlMjNiOWI0MDI3NGUifX19]
  display name: <&a>Sweet Smelling Candle

FoulCandle:
  type: item
  material: player_head[skull_skin=d6e2c590-d5d0-25c6-8c5c-0a2f3552c28a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZDFjOTQ0OGU5MGUxZmZhMjhmYTcyNDM0YTAyNTUxZjI1NzRjNjhmZTZhN2FhOGE5OTVjZDE2OTcxYWE4YTMyMyJ9fX0=]
  display name: <&c>Foul Smelling Candle

FreshLinenCandle:
  type: item
  material: player_head[skull_skin=d6e2c590-d5d0-25c6-8c5c-0a2f3552c28a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZDFjOTQ0OGU5MGUxZmZhMjhmYTcyNDM0YTAyNTUxZjI1NzRjNjhmZTZhN2FhOGE5OTVjZDE2OTcxYWE4YTMyMyJ9fX0=]
  display name: Fresh Linen Candle

CherryBlossomCandle:
  type: item
  material: player_head[skull_skin=d6e2c590-d5d0-25c6-8c5c-0a2f3552c28a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZDFjOTQ0OGU5MGUxZmZhMjhmYTcyNDM0YTAyNTUxZjI1NzRjNjhmZTZhN2FhOGE5OTVjZDE2OTcxYWE4YTMyMyJ9fX0=]
  display name: Cherry Blossom Candle

BonfireCandle:
  type: item
  material: player_head[skull_skin=d6e2c590-d5d0-25c6-8c5c-0a2f3552c28a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZDFjOTQ0OGU5MGUxZmZhMjhmYTcyNDM0YTAyNTUxZjI1NzRjNjhmZTZhN2FhOGE5OTVjZDE2OTcxYWE4YTMyMyJ9fX0=]
  display name: Fresh Bonfire Candle

BOCandle:
  type: item
  material: player_head[skull_skin=d6e2c590-d5d0-25c6-8c5c-0a2f3552c28a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZDFjOTQ0OGU5MGUxZmZhMjhmYTcyNDM0YTAyNTUxZjI1NzRjNjhmZTZhN2FhOGE5OTVjZDE2OTcxYWE4YTMyMyJ9fX0=]
  display name: BO Candle

OceanBreezeCandle:
  type: item
  material: player_head[skull_skin=d6e2c590-d5d0-25c6-8c5c-0a2f3552c28a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZDFjOTQ0OGU5MGUxZmZhMjhmYTcyNDM0YTAyNTUxZjI1NzRjNjhmZTZhN2FhOGE5OTVjZDE2OTcxYWE4YTMyMyJ9fX0=]
  display name: Ocean Breeze Candle

VanillaCandle:
  type: item
  material: player_head[skull_skin=d6e2c590-d5d0-25c6-8c5c-0a2f3552c28a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZDFjOTQ0OGU5MGUxZmZhMjhmYTcyNDM0YTAyNTUxZjI1NzRjNjhmZTZhN2FhOGE5OTVjZDE2OTcxYWE4YTMyMyJ9fX0=]
  display name: Vanilla Candle

GingerbreadCandle:
  type: item
  material: player_head[skull_skin=d6e2c590-d5d0-25c6-8c5c-0a2f3552c28a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZDFjOTQ0OGU5MGUxZmZhMjhmYTcyNDM0YTAyNTUxZjI1NzRjNjhmZTZhN2FhOGE5OTVjZDE2OTcxYWE4YTMyMyJ9fX0=]
  display name: Gingerbread Candle

PumpkinSpiceCandle:
  type: item
  material: player_head[skull_skin=d6e2c590-d5d0-25c6-8c5c-0a2f3552c28a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZDFjOTQ0OGU5MGUxZmZhMjhmYTcyNDM0YTAyNTUxZjI1NzRjNjhmZTZhN2FhOGE5OTVjZDE2OTcxYWE4YTMyMyJ9fX0=]
  display name: Pumpkin Spice Candle

PineCandle:
  type: item
  material: player_head[skull_skin=d6e2c590-d5d0-25c6-8c5c-0a2f3552c28a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZDFjOTQ0OGU5MGUxZmZhMjhmYTcyNDM0YTAyNTUxZjI1NzRjNjhmZTZhN2FhOGE5OTVjZDE2OTcxYWE4YTMyMyJ9fX0=]
  display name: Pine Candle

AppleCinnamonCandle:
  type: item
  material: player_head[skull_skin=d6e2c590-d5d0-25c6-8c5c-0a2f3552c28a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZDFjOTQ0OGU5MGUxZmZhMjhmYTcyNDM0YTAyNTUxZjI1NzRjNjhmZTZhN2FhOGE5OTVjZDE2OTcxYWE4YTMyMyJ9fX0=]
  display name: Apple Cinnamon Candle

ChocolateChipCookieCandle:
  type: item
  material: player_head[skull_skin=d6e2c590-d5d0-25c6-8c5c-0a2f3552c28a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZDFjOTQ0OGU5MGUxZmZhMjhmYTcyNDM0YTAyNTUxZjI1NzRjNjhmZTZhN2FhOGE5OTVjZDE2OTcxYWE4YTMyMyJ9fX0=]
  display name: Chocolate Chip Cookie Candle

LavenderCandle:
  type: item
  material: player_head[skull_skin=d6e2c590-d5d0-25c6-8c5c-0a2f3552c28a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZDFjOTQ0OGU5MGUxZmZhMjhmYTcyNDM0YTAyNTUxZjI1NzRjNjhmZTZhN2FhOGE5OTVjZDE2OTcxYWE4YTMyMyJ9fX0=]
  display name: Lavender Candle

LemongrassCandle:
  type: item
  material: player_head[skull_skin=d6e2c590-d5d0-25c6-8c5c-0a2f3552c28a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZDFjOTQ0OGU5MGUxZmZhMjhmYTcyNDM0YTAyNTUxZjI1NzRjNjhmZTZhN2FhOGE5OTVjZDE2OTcxYWE4YTMyMyJ9fX0=]
  display name: Lemongrass Candle

HoneydewCandle:
  type: item
  material: player_head[skull_skin=d6e2c590-d5d0-25c6-8c5c-0a2f3552c28a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZDFjOTQ0OGU5MGUxZmZhMjhmYTcyNDM0YTAyNTUxZjI1NzRjNjhmZTZhN2FhOGE5OTVjZDE2OTcxYWE4YTMyMyJ9fX0=]
  display name: Honeydew Candle

GardeniaCandle:
  type: item
  material: player_head[skull_skin=d6e2c590-d5d0-25c6-8c5c-0a2f3552c28a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZDFjOTQ0OGU5MGUxZmZhMjhmYTcyNDM0YTAyNTUxZjI1NzRjNjhmZTZhN2FhOGE5OTVjZDE2OTcxYWE4YTMyMyJ9fX0=]
  display name: Gardenia Candle