TestAssignment:
    type: assignment
    actions: 
        on assignment:
            - narrate "A"
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
    interact scripts:
    - 1 TestInteract

TestInteract:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Hi/
                    script:
                        - chat "Hi"
                        - zap 2
        2:
            chat trigger:
                1:
                    trigger: /Hi/
                    script:
                        - chat "hi 2"
                        - zap 1