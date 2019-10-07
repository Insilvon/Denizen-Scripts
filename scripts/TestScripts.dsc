MCLTest:
    type: task
    script:
        - narrate "<&hover[Press This]><&click[https://denizenscript.com].type[open_url]>Option One<&end_click><&end_hover> | <&hover[Or This]><&click[/dnpc]>Option Two<&end_click><&end_hover>"
