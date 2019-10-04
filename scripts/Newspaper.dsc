# on sundays
# loop through all currently added items to put into the book
# for each item, pull out the text inside
# add that text as a page of the new book
# Flags: newspaperitems, newspaperid
NewspaperGenerator:
    type: task
    script:
        - define itemList:<server.flag[NewspaperItems]||null>
        - define issueNumber:<server.flag[NewspaperID]||null>
        - if <[itemList]> == null:
            - determine canclled
        - else:
            - if <[issueNumber]> == null:
                - define issueNumber:0
            # Create the Book and Relevant Book Item
            # - note NewspaperTextTemplate as:NewspaperText<[issueNumber]>
            # Set the 
            - define page:1
            - define 'pages:The Newspaper'
            - foreach <[itemList].as_list> as:article:
                # Take the text out of this article item
                - define text:<[article].book.page[1]>
                # Smack it in the current page of the book item
                - define pages:<[pages]>|<[text]>
            # Generate the item to give out
            # - note i@NewspaperText<[issueNumber]>[display_name=;lore=Cool;text=<[pages]>] as:NewsPaperText<[issueNumber]>
            - define args:[book=author|Writer|title|TestTitle|pages|<[pages]>;display_name=Test]
            - note i@written_book<[args]> as:Newspaper<[issueNumber]>
            # Set up things for the next paper to run
            - flag server NewspaperItems:!
            - flag server NewspaperID:+:1
            - give Newspaper<[issueNumber]>
ScribeTest:
    type: task
    script:
        - define text:Hello1|Hello2|Hello3
        - note i@written_book[book=author|Writer|title|TestTitle|pages|<[text]>;display_name=Test] as:TestPaper
        - give TestPaper
AddArticle:
    type: task
    script:
        - flag server NewspaperItems:->:<player.item_in_hand>
NewspaperTextTemplate:
    type: book
    title: The Newspaper
    author: The Silver Quill
    signed: true
    text:

JournalistAssignment:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
            - trigger name:click state:true
        on click:
            - random:
                - narrate "*The journalist looks up from their desk, eyeing the object in your hands.*"
                - narrate "*As you approach, the jouranlist peers up at you.*"
                - narrate "*The sounds of quills scratching against parchment cease as you appraoch.*"
            - if <player.item_in_hand.script.contains_text[QuestCompleted]>:
                - chat "You got news for me? Fine. I guess I<&sq>ll take it and have a look."
                - random:
                    - narrate "*They begin to comb through the pages, reading the description of your event.*"
                    - narrate "*Slowly they trace a finger over the ink on the page.*"
                    - narrate "*As the journalist studies your work, they squint at the text.*"
                    - narrate "*They dip their quill in red ink, prepared to scratch out anything they see unfit.*"
                - random:
                    - chat "Fine fine - I<&sq>ll consider having a look. Get on with it - there<&sq>s work to do."
                    - chat "I<&sq>d hardly call this newsworthy... but I don<&sq>t have enough content. I<&sq>ll take it."
                    - chat "You call this a story? Fine - whatever, I suppose we can run it. Thanks for the free press."
                    - chat "This is fairly interesting. Not sure if it<&sq>ll catch attention, but maybe with some other stories."
                    - chat "We<&sq>ll give it a run - not my fault if it doesn<&sq>t bring in revenue though."
                    - chat "This was a pretty solid read. I<&sq>ll give you that. We<&sq>ll run it."
                    - chat "Straightforward, snappy, and to the point. We<&sq>ll run the story."
                    - chat "I<&sq>ll mull it over, but I think this is runnable. Check the paper this week. You might be happy with what you see."
            - else:
                - chat "I don<&sq>t know what you<&sq>re trying to shove at me, but I don<&sq>t appreciate it."
                - chat "Get out of here if you don<&sq>t have something constructive for me."
JournalistInteract:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                        script:
                            - chat "Hello"