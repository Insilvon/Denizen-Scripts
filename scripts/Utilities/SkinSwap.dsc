
SkinSwap:
    type: command
    name: SkinSwap
    description: Ah
    usage: /SkinSwap
    script:
        - define url <context.args.get[1]||null>
        - if <[url]> == null:
            - narrate "<&c>You must specify a valid skin URL."
            - stop
        - if !<[url].ends_with[.png]>:
            - narrate "<&c>That URL isn't likely to be valid. Make sure you have a direct image URL, ending with '.png'."
        - narrate "<&a>Retrieving the requested skin..."
        - run skin_url_task def:<[url]> save:newQueue
        - while <entry[newQueue].created_queue.state> == running:
            - if <[loop_index]> > 20:
                - queue <entry[newQueue].created_queue> clear
                - narrate "<&c>The request timed out. Is the url valid?"
                - stop
            - wait 5t
        - if <entry[newQueue].created_queue.determination.first||null> == null:
            - narrate "<&c>Failed to retrieve the skin from the provided link. Is the url valid?"
            - stop
        - define yamlid <player.uuid>_skin_from_url
        - yaml loadtext:<entry[newQueue].created_queue.determination[result].first> id:<[yamlid]>
        - if !<yaml[<[yamlid]>].contains[data.texture]>:
            - narrate "<&c>An unexpected error occurred while retrieving the skin data. Please try again."
        - else:
            - adjust <player> skin_blob:<yaml[<[yamlid]>].read[data.texture.value]>;<yaml[<[yamlid]>].read[data.texture.signature]>
            - narrate "<&e><player.name><&a>'s skin set to <&e><[url]><&a>."
        - yaml unload id:<[yamlid]>
SkinHandler:
    type: task
    script:
        - define url:<player.flag[<[character]>_skin]>
        - if <[url]> == null:
            - narrate "<&c>You must specify a valid skin URL."
            - stop
        - if !<[url].ends_with[.png]>:
            - narrate "<&c>That URL isn't likely to be valid. Make sure you have a direct image URL, ending with '.png'."
        - narrate "<&a>Retrieving the requested skin..."
        - run skin_url_task def:<[url]> save:newQueue
        - while <entry[newQueue].created_queue.state> == running:
            - if <[loop_index]> > 20:
                - queue <entry[newQueue].created_queue> clear
                - narrate "<&c>The request timed out. Is the url valid?"
                - stop
            - wait 5t
        - if <entry[newQueue].created_queue.determination.first||null> == null:
            - narrate "<&c>Failed to retrieve the skin from the provided link. Is the url valid?"
            - stop
        - define yamlid <player.uuid>_skin_from_url
        - yaml loadtext:<entry[newQueue].created_queue.determination[result].first> id:<[yamlid]>
        - if !<yaml[<[yamlid]>].contains[data.texture]>:
            - narrate "<&c>An unexpected error occurred while retrieving the skin data. Please try again."
        - else:
            - adjust <player> skin_blob:<yaml[<[yamlid]>].read[data.texture.value]>;<yaml[<[yamlid]>].read[data.texture.signature]>
            - define skinTexture:<yaml[<[yamlid]>].read[data.texture.value]>
            - narrate "<&e><player.name><&a>'s skin set to <&e><[url]><&a>."
        - yaml unload id:<[yamlid]>
skin_url_task:
    type: task
    debug: false
    definitions: url
    script:
    - ~webget "https://api.mineskin.org/generate/url" post:url=<[url]> timeout:5s save:webResult
    - determine <entry[webResult].result||null>
SkinSave:
    type: task
    debug: false
    script:
        - flag server <player.uuid>_DefaultSkin:<player.skin_blob>