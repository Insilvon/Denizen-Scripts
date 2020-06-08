DaysSinceCrash:
    type: world
    events:
        on system time daily:
            - flag server DaysSinceCrash:++

DaysSinceCrashCommand:
    type: command
    name: daysincecrash
    desc: sh
    usage: sh
    permission: aetheria.dayssincecrash
    aliases:
    - dsc
    script:
        - flag server DaysSinceCrash:0

DaysSinceCrashOnJoin:
    type: task
    script:
        - narrate "<&e>It has been -<&c><server.flag[DaysSinceCrash].to_uppercase><&e>- day(s) since the last World Edit Incident."