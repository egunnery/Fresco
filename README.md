# Fresco

## How to install

Open FrescoTask in terminal

Run `pod install`

Open `Fresco.xcworkspace`

## General

Overall, I am moderately happy with what I got done in the time I spent on this. I did go over the 12 hours, as some parts of this test included some research for me (such as the mock stream, have never delt with streaming requests.) I enjoyed getting to play around with different UI components again, as I have spent the last few months working on frameworks so this was a fun refresher. 

Due to the size of the project, some implementation decisions were made based on time. I think I could spend twice as long trying to get this perfect, but for the purposes of a tech test I did what I thought was reasonable. This is probably most obvious in the design. I spent my time on the functionality of the app rather than the design, as I think having core working features was the most important thing. UI can be tweaked as needed. 

With regards to the weigh screen, I think that I have done what was requested. Weight events are streamed, ignoring timestamps for older events if newer ones have been recieved, and updates the scale accordingly. The done button doesn't actually do anything bar navigating back to the previous screen, as the full functionality of this was in the extra requirements. 

## Architectural decisions

Wasn't sure whether or not to add a coordinator given the size of the app, so I decided on a simple one. It's not a complete coordinator implementation. I am not a big fan of having to pass the coordinator as a parameter of the view models, so given more time I would implement a fully fledged one (for example, using PublishSubjects for routes, which are cases in an enum). I do like my implemented option better than leaving everything down to the view models though. 

I would expand on my components to make them more reactive rather than passing set up values on initiation as I do now. Something along the lines of how the drivers I use in my view models update values.

## Known issues

I do not have a refresh method for when the network call fails. I would add this and create a nicer flow for failing requests, and add pull to refresh. 

I did not complete the extra requirements. 

The beer image is fetched on the main thread which I didn't get around to fixing. 

## Dependencies

I used RxSwift and Snapkit, as I use these in my current role. I felt that using these to a certain degree here would both help me speed the process up, and help to give a more accurate picture of where I'm at.

I could have used Rx more to give more power to the view models but would have needed to write a number of extensions, further delaying the process. 

## Extra requirements 

* It will be very convenient for the user if the weighted ingredient is marked as done.

* User might want to navigate back to browser screen and back, so would be nice if all marked ingredients will not lose marked state

Due to time constraints, I didn't get a chance to implement these. If I had time, I would maybe do something like save the beers using Realm. This way rather than passing beers back and forth, I could use the saved values across screens in the app, without needing to constantly pass them between view models. Though I would need to see what kind of requirements were around this, and when to clear the database for future use. 

* Unit, Integration or UI tests

I tested the view models to get some tests in.

Given time, would do a proper implementation of a coordinator to test routes, and some UITests. 
