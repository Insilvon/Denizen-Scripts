# # on sundays
# # loop through all currently added items to put into the book
# # for each item, pull out the text inside
# # add that text as a page of the new book
# # Flags: newspaperitems, newspaperid
# NewspaperGenerator:
#     type: task
#     script:
#         - define itemList:<server.flag[NewspaperItems]||null>
#         - define issueNumber:<server.flag[NewspaperID]||null>
#         - if <[itemList]> == null:
#             - determine canclled
#         - else:
#             - if <[issueNumber]> == null:
#                 - define issueNumber:0
#                 # Create the Book and Relevant Book Item
#                 - note NewspaperTextTemplate as:NewspaperText<[issueNumber]>
#                 # Set the 
#                 - define page:1
#                 - define 'pages:li@The Newspaper'
#                 - foreach <[itemList].as_list> as:article:
#                     # Take the text out of this article item
#                     - define text:<[article].book.page[0]>
#                     # Smack it in the current page of the book item
#                     - define pages:->:<[text]>
#                 # Generate the item to give out
#                 # - note i@NewspaperText<[issueNumber]>[display_name=;lore=Cool;text=<[pages]>] as:NewsPaperText<[issueNumber]>
#                 - note i@written_book<[issueNumber]>[book=author|Writer|title|TestTitle|pages|<[pages]>;display_name=]
#                 # Set up things for the next paper to run
#                 - flag server NewspaperItems:!
#                 - flag server NewspaperID:+:1
ScribeTest:
    type: task
    script:
        - define text:Hello1|Hello2|Hello3
        - note i@written_book[book=author|Writer|title|TestTitle|pages|<[text]>;display_name=Test] as:TestPaper
        - give TestPaper

NewspaperTextTemplate:
    type: book
    title: The Newspaper
    author: The Silver Quill
    signed: true
    text: