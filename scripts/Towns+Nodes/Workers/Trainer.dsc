TrainerWorkerVoucher:
    type: item
    material: paper
    display name: Farmworker Voucher
    lore:
        - Right click to spawn
        - a farm worker 
        - for your town.
TrainerWorkerAssignment:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
    interact scripts:
    - 1 TrainerWorkerInteract
TrainerWorkerInteract:
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