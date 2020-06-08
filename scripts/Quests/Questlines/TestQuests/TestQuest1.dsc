# Quest Template
# Made and designed for AETHERIA
# @author Insilvon
# @version 1.0.0
# Quest Template Prototype
# Allows for quick and easy setup of Quests

#====================================================#
#======================NPC Container=================#
#====================================================#
TestQuest1Assignment:
    type: assignment
    actions:
        on assignment:
        - narrate "Assignment set!"
        - trigger name:proximity state:true
        on click:
        - narrate "Hello!" targets:<server.match_player[Insilvon]>
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
    interact scripts:
    - 1 TestQuest1Interact

TestQuest1Interact:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - chat "Hi welcome to stage one"
                2:
                    trigger: /Regex:Goodbye/
                    script:
                        - chat "See ya"
                3:
                    trigger: /Regex:Quest/
                    script:
                        - chat "Can u come say hello to me"
                        - chat "Accept/Decline"
                        - zap 2
        2:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - chat "Say Accept/Decline"
                2:
                    trigger: /Regex:Accept/
                    script:
                        - chat "Ok cool thanks"
                        - run AddActiveQuest def:<player>|TestQuest1GuideBook
                        - zap 3
                3:
                    trigger: /Regex:Decline/
                    script:
                        - chat "Whatever okay"
                        - zap 1
                4:
                    trigger: /Regex:Goodbye/
                    script:
                        - chat "Bye"

        3:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - chat "Hey thanks for that you win"
                        - run AddCompletedQuest def:<player>|TestQuest1QuestCompleted
                        - run RemoveActiveQuest def:<player>|TestQuest1GuideBook
                        - zap 1
                2:
                    trigger: /Regex:Remind/
                    script:
                        - chat "Can u come say hello to me"
                3:
                    trigger: /Regex:Goodbye/
                    script:
                        - chat "See ya"
#====================================================#
#======================QuestItems====================#
#====================================================#
TestQuest1GuideBook:
    type: book
    author: Active Quest
    title: TestQuest1 Title
    signed: yes
    text:
        - "This is what you were asked to do"
        - "Should be the same as your quest remind"
TestQuest1QuestCompleted:
    type: book
    author: Completed Quest
    title: TestQuest1 Title
    signed: yes
    text:
        - "This is a one-page description of the quest. Do not exceed one page."
