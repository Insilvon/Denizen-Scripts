Noah:
    type: assignment
    actions:
        on assignment:
            - chat "Hey man, you ready for this NPC?"
    interact scripts:
    - 1 NoahInteract

NoahInteract:
    type: interact
    steps:
        1:
            proximity trigger:
                entry:
                    script:
                        - if <player.name> == Insilvon:
                            - chat "Hey! Hey Colin! Hey! *Waves frantically* I'm saying hi!"
                        - else:
                            - random:
                                - chat "Hey man."
                                - chat "How's it going?"
                                - chat "Heyyyyy mannn."
            chat trigger:
                1:
                    trigger: /Regex:Hey|Hello|Hi/
                    script:
                        - chat "Hey man, how's it going?"
                2:
                    trigger: Okay, /you/?
                    script:
                        - chat "Livin the dream man!"
                        - wait 1s
                    
                        - define list:li@Math Exam|Biology Exam|Test|Class|Quiz
                        - define thing:<[list].get[<util.random.int[1].to[<[list].size>]>]>
                        - chat "Are you ready for this <[thing]>?"
                        - wait 2s
                        - chat "I know I'm not man. I've been studying all night and I'm probably going to fail."
                        - wait 2s
                        - chat "Guess I can always go back to working construction!"
                3:
                    trigger: /Regex:Yeah|Yea|Yes|No|Nah/
                    script:
                        - chat "HAHAHAHAHA"
