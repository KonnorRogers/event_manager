# event_manager

A project created using googleAPIs to pull legislator information & determine
their various voting locations & who their legislators are.

Using said API, learned how to read CSV's and use the information from the CSV
to extrapolate the data.

EventManager class will read the CSV and parse the data. It will also create
thank you letters in an output directory in html format using ERB.

To create the html output files on a unix system from command line:
"$ ruby lib/event_manager.rb"
the project will then run the lib/event_manager.rb file.

The other file contained is the time_targetting.rb class.

Using the information from event_manager.rb, it will determine the best hour & the
best day to have people sign up.
To run the file from command line on a unix system:

"ruby lib/time_targetting.rb"

It will then print to the command line the best hour & days to have people signup
for voting based on the googleAPI CSV. The project was created as part of
TheOdinProject curriculum.