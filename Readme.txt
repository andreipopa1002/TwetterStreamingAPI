In order to test the App please log in on the simulator/device with you Twitter account 

** Technical considerations: **
In order to execute calls on the Twitter API we need oauth authentication. In order to achieve this we have two options:
1.	Request from twitter an API key and generate ourselves the values required for authenticating. 
2.	Use the Acount and Social frameworks available on iOS to prepare the request with authentication incuded.

I decided to go for the option with the Account and Social framework. In order to test the app please login on the simulator so that the app is able to access the API.

** UI **
In order to display the last 5 tweets I decided to go for a table view, due to the flexibility when changing the number of tweets and due to the support it offers for inserting and deleting tweets.

** Architecture **
As an architectural pattern for this app, I used a simplified VIPER that I am familiar with and offers good separation of concerns. In this architecture the Interactor is a coordinator that encapsulates the logic but does not do actual work. Other components are doing the work for the Interactor, and send information back to the Interactor via closures. When the Interactor has something to show it will send to the Presenter some Model objects.
The Presenter is the one that has knowledge about the existence of the UI layer and will tweak the Model object into a ViewModel object that can be rendered. Since we have no navigation there is no need for a Router component.

** Discipline **
As a discipline I used TDD in order to solve the problem and provide some stability to the code. There are a couple of foundation classes that are not exactly unit testable so I had to wrap them in a class and hide them behind a protocol to achieve testability. 

** Concerns **
The requirement state that we need to display the latest 5 tweets with this particular keyword.  This works ok well if the keyword is not too popular, but if the word becomes extremely popular the tweets will appear and disappear from the screen very fast making them difficult to read. I used for testing purposes keyword like: “trump” or “got”
To fix this I would suggest on of the following:
1.	adding a visual notification to the user that the feed changed. And when the user requests we will update the UI. Similar as the Facebook, Twitter and other social media app do.
2.	monitor the speed of the incoming tweets and if the speed is too big activate the solution from number 1. 
