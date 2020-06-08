BookshelfController:
    type: world
    events:
        on player places BookshelfItem:
            - define locale:<context.location>
            - note in@CustomBookshelfInventory as:Bookshelf_<context.location.simple>
            - narrate "<&a>Creating your bookshelf. Please wait..."
            - wait 1s
            - narrate "<&a>Your bookshelf is ready to use!"
        on player places BookshelfItem2:
            - define locale:<context.location>
            - note in@CustomBookshelfInventory as:Bookshelf_<context.location.simple>
            - narrate "<&a>Creating your bookshelf. Please wait..."
            - wait 1s
            - narrate "<&a>Your bookshelf is ready to use!"
        on player places BookshelfItem3:
            - define locale:<context.location>
            - note in@CustomBookshelfInventory as:Bookshelf_<context.location.simple>
            - narrate "<&a>Creating your bookshelf. Please wait..."
            - wait 1s
            - narrate "<&a>Your bookshelf is ready to use!"
        on player clicks item in CustomBookShelfInventory:
            - define list:li@writable_book|written_book|book|air
            - if !<[list].contains[<context.item.material.name>]>:
                - determine cancelled

BookshelfOnPlayerBreaksBlock:
    type: task
    speed: instant
    script:
        - if <[itemdrop]> == BOOKSHELFITEM || <[itemdrop]> == BOOKSHELFITEM2 || <[itemdrop]> == BOOKSHELFITEM3:
            - narrate "<&a>Deleting Bookshelf. Dropping items."
            - define inventory:in@Bookshelf_<context.location.simple>
            - drop <[inventory].list_contents> <context.location>

BookshelfOnPLayerRightClicksPlayer_Head:
    type: task
    speed: instant
    script:
        # - narrate <[customitem]>
        - if <[customitem]> == BOOKSHELFITEM || <[customitem]> == BOOKSHELFITEM2 || <[customitem]> == BOOKSHELFITEM3:
            # - narrate "Opening Bookshelf_<context.location.simple>"
            - inventory open d:Bookshelf_<context.location.simple>

BookshelfItem:
    type: item
    material: player_head[skull_skin=2c576129-d810-40c7-a8d6-8ba855a0d497|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZWVlOGQ2ZjVjYjdhMzVhNGRkYmRhNDZmMDQ3ODkxNWRkOWViYmNlZjkyNGViOGNhMjg4ZTkxZDE5YzhjYiJ9fX0=]
    display name: Bookshelf
    recipes:
        1:
            type: shapeless
            input: Bookshelf
        2:
            type: shapeless
            input: BookshelfItem3

BookshelfItem2:
    type: item
    material: player_head[skull_skin=b15dd18e-fc43-4805-98d5-b8880d94a63a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZTViZTIyYjVkNGE4NzVkNzdkZjNmNzcxMGZmNDU3OGVmMjc5MzlhOTY4NGNiZGIzZDMxZDk3M2YxNjY4NDkifX19]
    display name: Bookshelf
    recipes:
        1:
            type: shapeless
            input: BookshelfItem

BookshelfItem3:
    type: item
    material: player_head[skull_skin=fb704aa8-e03a-426c-b946-f59e2a83282a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNmUzYzYwODlkMmIwNWQ5MGRlYmIxYTI1YWMyMTExMzMyY2VhNWE2YmQzNTM3MGI5YWEyMzdlZmI2YzFlYzJmYyJ9fX0=]
    display name: Bookshelf
    recipes:
        1:
            type: shapeless
            input: BookshelfItem2

CustomBookshelfInventory:
    type: inventory
    title: Bookshelf
    size: 9
    slots:
        - "[] [] [] [] [] [] [] [] []"
