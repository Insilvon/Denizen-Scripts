MCLTest:
    type: task
    script:
        - narrate "<&hover[Press This]><&click[https://denizenscript.com].type[open_url]>Option One<&end_click><&end_hover> | <&hover[Or This]><&click[/dnpc]>Option Two<&end_click><&end_hover>"
        - narrate "<&hover[Click Me!]><&click[Tell me about yourself.]>Ask about their history.<&end_click><&end_hover> | <&hover[Click Me!]><&click[I think you should leave.]>Ask them to stop following you.<&end_click><&end_hover>"

