# misdeed_ios

# My App Name
[1-2 sentence description of the app]
MisDeeD
-This App is a crime spot map of SF, to help users determine where crimes are taken place. Users also be able to make their own reports, view other user’s reports and police incident coordinates.

## Audience
[Who cares/uses it? why?]
People new to the area, particularly commuters. Those considering moving into an area.

## Experience
A user opens the app... they will be taken to the launch page, where they can choose to login or view map.

Login – by logging in user can create account, create an incident report to inform others, view their reports

View Map – view map with coordinates. Tapping the pinpoint will open a small window containing more information. User can filter by police reports or user reports. Standard map view will only show reports created within 48 hrs. 

Future plan is to allow user to filter based on type of report, weekly, monthly. 




# Technical
## Models
[What data are we dealing with? What classes will we create for that data?]

User
Username String
-	Name String
-	Email String

Reports 
-	Address String
-	Category String 
-	Date String
-	Time 
-	reportedBy: username

SF Police incident reports API
https://data.sfgov.org/resource/cuks-n6tp.json


## Views
[What custom views do we need to create? Include pictures of your prototypes/sketches!]
-	IncidentReportListViewCell

## Controllers
[What controllers will we need? What will they do?]
LaunchpageViewController
MapHomeViewController
LoginViewController
UserHomeViewController
AddReportViewController

## Other
[Any other frameworks / things we will need? Helpers? Services?]
Cocopod 
Mapkit


# Weekly Milestone
## Week 4 - Usable Build
[List of tasks needed to be complete before you can start user testing]
Tuesday 
1.	Initial setup, cocopods
2.	create MapHomeView(storyboard UI + Controller) 
3.	able to display map on simulator 
4.	first push to git
Wednesday 
1.	call SF police incident report API
2.	display info window
Thursday
1.	createReportView (storyboard UI + Controller
2.	be able to create report and store in firebase
Friday
1.	display both SP incident API and user reports API on map
2.	debug and polish the week’s work to prepare for user testing 


## Week 5 - Finish Features
[List of tasks to complete the implementation of features]


## Week 6 - Polish
[List of tasks needed to polish and ship to the app store]


