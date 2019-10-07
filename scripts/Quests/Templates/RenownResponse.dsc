YourRenownResponse:
    type: task
    script:
        - if <[renown]> == unknown:
            - chat ""
            - stop
        - if <[renown]> == liked:
            - chat ""
            - stop
        - if <[renown]> == admired:
            - chat ""
            - stop
        - if <[renown]> == hero:
            - chat ""
            - stop
        - if <[renown]> == disliked:
            - chat ""
            - stop
        - if <[renown]> == shunned:
            - chat ""
            - stop
        - if <[renown]> == despised:
            - chat ""
            - stop