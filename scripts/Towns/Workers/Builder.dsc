BuilderWorkerVoucher:
    type: item
    material: paper
    display name: Builder Voucher
    lore:
        - Right click to spawn
        - a Builder
        - for your town.
BuilderWorkerAssignment:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
    interact scripts:
    - 1 BuilderWorkerInteract
BuilderWorkerInteract:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                    - chat "Hello"