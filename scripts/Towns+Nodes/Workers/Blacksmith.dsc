BlacksmithWorkerVoucher:
    type: item
    material: paper
    display name: Blacksmith Worker Voucher
    lore:
        - Right click to spawn
        - a blacksmith worker
        - for your town.
BlacksmithWorkerAssignment:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
    interact scripts:
    - 1 BlacksmithWorkerInteract
BlacksmithWorkerInteract:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                    - chat "Hello"
                2:
                    trigger: /Regex:Follow/
                    script:
                        - if <npc.has_flag[Follow]>:
                            - follow stop
                            - flag npc Follow:!
                        - else:
                            - follow speed:1.5
                            - flag npc Follow