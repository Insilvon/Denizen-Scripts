LetterFormat:
    type: format
    format: "<&a>[Letters]<&co><&f> <text>"

# LetterOnJoin:
#     type: task
#     script:
#         - define character:<proc[GetCharacterName].context[<player>]>
#         - inject CharacterCheck
#         - if !<player.has_flag[<[character]>_Letter]> && <player.has_flag[character]>:
#             - note in@LetterInventory as:<[character]>_Mailbox
#             - flag player <[character]>_Letter
#         - define inventory:in@<[character]>_Mailbox
#         - if <[inventory].first_empty> != 1:
#             - narrate "You have <&a>unread<&f> letters!" format:LetterFormat
#         - else:
#             - narrate "You have no new letters." format:LetterFormat
LetterController:
    type: world
    events:
        on player clicks item in LetterInventory:
            # - narrate <context.item.material.name>
            - if <context.item.script.name||air> == CharacterSheetBackItem:
                - inventory open d:CharacterSheetMenu
                - stop
            - if <context.item.material.name||air> != writable_book && <context.item.material.name||air> != written_book && <context.item.material.name||air> != air:
                - determine cancelled
        on player closes LetterInventory:
            - define character:<player.flag[CharacterSheet_CurrentCharacter]>
            - flag player CharacterSheet_<[character]>_Letters:<context.inventory.list_contents>
LetterCommand:
    type: command
    name: letter
    usage: /letter
    aliases:
    - l
    script:
        - define args:<context.args>
        - choose <[args].size>:
            - case 1:
                - define command:<[args].get[1]>
                - choose <[command]>:
                    - case help:
                        - inject LetterHelp
            - case 2:
                - define command:<[args].get[1]>
                - define arg:<[args].get[2]>
                - choose <[command]>:
                    - case post:
                        - inject LetterPost
            - case 3:
                - define command:<[args].get[1]>
                - define arg:<[args].get[2]>
                - choose <[command]>:
                    - case post:
                        - inject LetterPost2
            - default:
                - inventory open d:LetterInventory


LetterInventory:
    type: inventory
    inventory: chest
    title: Mailbox
    size: 27
    slots:
        - "[] [] [] [] [] [] [] [] []"
        - "[] [] [] [] [] [] [] [] []"
        - "[] [] [] [] [] [] [] [] [CharacterSheetBackItem]"
    procedural items:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - define letters:<player.flag[CharacterSheet_<[character]>_Letters]||li@air>
        - determine <[letters]>

LetterPost:
    type: task
    script:
        - if <player.item_in_hand.script.name> != LetterBase:
            - narrate "You are not holding a valid letter!" format:LetterFormat
            - stop
        - define target:<server.match_offline_player[<[arg]>]||null>
        - if <server.list_players.contains[<[target]>]> && <[target]> != null:
            - define targetCharacter:<[target].flag[CharacterSheet_CurrentCharacter]>
            - define item:<player.item_in_hand>
            - take <player.item_in_hand>
            - wait 10s
            - flag <[target]> CharacterSheet_<[targetCharacter]>_Letters:->:<[item]>
            
            # - define message:<player.item_in_hand.book.pages.space_separated>
            # - define channel:<discord[mybot].group[Aetheria].channel[big-sister-letters]>         
            # - ~discord id:mybot message channel:<[channel]> "<&gt> *Letter Sent from* <player.name> (**<proc[GetCharacterName].context[<player>]>**) *->* <[target].name> (**<[targetCharacter]>**):"
            # - ~discord id:mybot message channel:<[channel]> "```<[message].replace_text[§r].with[]>```"
            # - ~discord id:mybot message channel:<[channel]> "**================================**"

            - narrate "Your letter has been sent. It will take some time for it to arrive." format:LetterFormat
            - narrate "A raven drops a letter off at <[target].display_name><&sq>s feet." format:LetterFormat targets:<[target].location.find.players.within[10]>

LetterHelp:
    type: task
    script:
        - narrate "/letter help <&3>Shows this menu" format:LetterFormat
        - narrate "/letter post <player.name> <&3>Sends your held letter or package to a player." format:LetterFormat
        - narrate "/letter attach <&3>Opens a gui to add an attachment to your letter." format:LetterFormat
        - narrate "/letter <&3>View letters sent to you." format:LetterFormat
        - narrate "---------------------------------------" format:LetterFormat
        - narrate "Note: When you send a letter to a Username, it will arrive in the inbox of their last played character!" format:LetterFormat
        - narrate "Note: Letters rely on a <&3>Empty Letter<&f> to work. Be sure to craft some by placing paper in a crafting bench." format:LetterFormat
        - narrate "Note: You must be using a <&3>Character<&f> for this to work!" format:LetterFormat

LetterBase:
    type: item
    material: writable_book
    display name: Letter
    lore:
    - A bound letter to
    - be sent through the
    - skies.
    recipes:
        1:
            type: shapeless
            input: paper
