DiscordVerification:
    type: command
    name: verify
    description: no
    usage: /verify YourNameXXXX
    script:
        - if <context.args.size> == 1 && <context.args.get[1]> == test:
            - define value:<proc[ReadBaseYAML].context[<player>|Info.Discord.account]>
            - narrate "<&d>Discord<&co> A message has been sent to the account on file."
            - discord id:mybot message user:<[value]> "Your account is linked and is working!"

            - stop
        - if <context.args.size> == 1:
            - define user:<context.args.get[1]>
            - define temp:<discord[mybot].group[Aetheria].member[<[user]>]>
            - if <[temp]> != null:
                - define key:<util.random.uuid>
                - flag player discord_verify:<[key]>
                - flag player discord_name:<[temp]>
                - narrate "<&d>Discord<&co> A message has been sent to the discord user <[temp].name>"
                - discord id:mybot message user:<[temp]> "Hello. A minecraft user `<player.name>` has attempted to verify this account as theirs. If this is you, please run `/verify confirm <[key]>` in game. If this is not you, please inform a Server Admin."
            - else:
                - narrate "<&d>Discord<&co> No user was found with this name. Please use the format of Username#1234."
        - if <context.args.size> == 2 && <context.args.get[1]> == confirm:
            - define key:<context.args.get[2]>
            - if <player.flag[discord_verify]> == <[key]>:
                - narrate "<&d>Discord<&co> Your discord account is now confirmed and linked to this minecraft account."
                - define temp:<player.flag[discord_name]>
                - narrate <[temp]>
                - run SetBaseYAML def:<player>|Info.Discord.name|<[temp].name>
                - run SetBaseYAML def:<player>|Info.Discord.account|<[temp]>
                - flag player discord_verify:!
                - flag player discord_name:!
            - else:
                - narrate "<&d>Discord<&co> The key entered is incorrect. Please reconfirm."
                - flag player discord_verify:!
                - flag player discord_name:!
