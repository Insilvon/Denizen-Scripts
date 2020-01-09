LetterFormat:
    type: format
    format: "<&a>[Letters]<&co><&f> <text>"
LetterOnJoin:
    type: task
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - if !<player.has_flag[<[character]>_Letter]> && <player.has_flag[character]>:
            - note in@LetterInventory as:<[character]>_Mailbox
            - flag player <[character]>_Letter
        - define inventory:in@<[character]>_Mailbox
        - if <[inventory].first_empty> != 1:
            - narrate "You have <&a>unread<&f> letters!" format:LetterFormat
        - else:
            - narrate "You have no new letters." format:LetterFormat
LetterController:
    type: world
    events:
        on player signs book:
            # - narrate <context.book>
            # - narrate <context.book.script>
            - if <context.book.script.name> == LetterBase:
                - define character:<proc[GetCharacterName].context[<player>]>
                - if !<player.has_flag[<[character]>_letter]>:
                    - flag player <[character]>_letter:1
                - note <context.book> as:Letter_<[character]>_<player.flag[<[character]>_letter]>
                - flag player <[character]>_letter:++
        
        # on player clicks in inventory with item priority:5:
            
        # on player clicks LetterBase in inventory with item priority:1:
        #     - define gift:<context.cursor_item>
        #     - flag server Letter_<context.item>:<[gift]>
        #     - wait 1s
        #     - take <[gift]>
        # on player right clicks LetterBase in inventory:
        #     - determine cancelled passively
        #     - if <server.has_flag[Letter_<context.item>]>:
        #         - give player <server.flag[Letter_<context.item>]>
        #         - flag server Letter_<context.item>:!

Letter:
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
                    # - case attach:
                    #     - inject LetterAttach
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
                - inventory open d:in@<proc[GetCharacterName].context[<player>]>_Mailbox

LetterPost:
    type: task
    script:
        - if <player.item_in_hand.script.name> != LetterBase:
            - narrate "You are not holding a valid letter!" format:LetterFormat
            - stop
        - define target:<server.match_offline_player[<[arg]>]||null>
        - if <server.list_players.contains[<[target]>]> && <[target]> != null:
            - define targetCharacter:<proc[GetCharacterName].context[<[target]>]>
            - give <player.item_in_hand> to:in@<[targetCharacter]>_Mailbox

            - define message:<player.item_in_hand.book.pages.space_separated>
            - define channel:<discord[mybot].group[Aetheria].channel[big-sister-letters]>
            
            - ~discord id:mybot message channel:<[channel]> "<&gt> *Letter Sent from* <player.name> (**<proc[GetCharacterName].context[<player>]>**) *->* <[target].name> (**<[targetCharacter]>**):"
            - ~discord id:mybot message channel:<[channel]> "<[message]>"

            - take <player.item_in_hand>
            - narrate "Your letter has been sent." format:LetterFormat

            - narrate "A raven drops a letter off at <[target].name.display><&sq>s feet." format:LetterFormat targets:<[target].location.find.players.within[<10.10>]>
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
        
# LetterAttach:
#     type: task
#     script:
#         - if <player.item_in_hand.material.name> != written_book:
#             - narrate "You are not holding a written letter!"
#             - stop
        
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

LetterInventory:
    type: inventory
    inventory: chest
    title: Mailbox
    size: 27
    slots:
        - "[] [] [] [] [] [] [] [] []"
        - "[] [] [] [] [] [] [] [] []"
        - "[] [] [] [] [] [] [] [] []"