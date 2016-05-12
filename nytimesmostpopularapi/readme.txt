readme.txt

This application queries the NYTimes most popular API, displaying them in a tabular format on the screen.  Clicking one of the rows leads you to a detailed page with a picture, title, and publish date of the artice.  THis application has been tested primarily on iPhone6, but will work on most iOS devices.


Storing and refreshign data
The results of teh API are stored in coredata after they are downloaded.  On launch you only refresh teh api if data does not exist.  The user can also manually refresh whenever they want by pulling down the screen.

Design overview
I removed the storyboard, launchign from appdelegate instead.  The scenes start with a customized table view controller, adn send you to a detailed controller.  There tableviewcontroller can be navigated by a tabbarview that lets you switch between the different categories.  Adding additional categories would be very straightforward - they would need to be added into CustomTabBarViewConroller and then would automatically work.

Other libraries
In addition to the swift libraries I used SwiftyJSON to assist with the JSON wrapping and parsing.