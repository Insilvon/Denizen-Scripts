Roll:
    type: command
    name: roll
    description: null
    usage: /roll number
    permission: Aetheria.roll
    script:
        - define number:<context.args.get[1]||20>
        - if <[number].is_integer>:
            - define result:<util.random.int[1].to[<[number]>]>
            - define color:<&f>
            - if <[number]> == 20:
                - if <[result]> == 20:
                    - define color:<&e>
                - if <[result]> < 20 && <[result]> >= 15:
                    - define color:<&a>
                - if <[result]> < 15 && <[result]> > 8:
                    - define color:<&b>
                - if <[result]> <= 8 && <[result]> > 1:
                    - define color:<&c>
                - if <[result]> == 1:
                    - define color:<&4>
            - narrate "<&e>[Dice]:<&f> <player.name.display> rolled a <[color]><[result]>!" targets:<player.location.find.players.within[15.15]>
        - else:
            - narrate "<&e>[Dice]:<&f> Invalid command, please use /roll <&lt>Number<&gt>>"
ProfessionRoll:
    type: command
    name: proll
    description: null
    usage: /proll profession
    permission: Aetheria.roll
    script:
        - if <context.args.size> == 1:
            - define prof:<context.args.get[1]>
            - define character:<player.flag[CharacterSheet_CurrentCharacter]>
            - if <player.has_flag[<[character]>_Profession_<[prof]>]>:
                - define level:<player.flag[<[character]>_Profession_<[prof]>]||0>
                - define bonus:<[level].mul_int[3]>
                - define result:<util.random.int[1].to[100].add_int[<[bonus]>]>
                - if <[result]> >= 100:
                    - define color:<&e>
                - if <[result]> < 100 && <[result]> >= 80:
                    - define color:<&a>
                - if <[result]> < 80 && <[result]> >= 70:
                    - define color:<&b>
                - if <[result]> < 70 && <[result]> > 1:
                    - define color:<&c>
                - if <[result]> == 1:
                    - define color:<&4>
            - narrate "<&e>[Dice]:<&f> <player.name.display> rolled a <[color]><[result]> for <[prof]>!" targets:<player.location.find.players.within[15.15]>