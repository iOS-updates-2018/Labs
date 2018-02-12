## Using CoreData in Contacts App

This lab is meant to introduce students to using iOS CoreData within an Application. The basis for this application will be the ContactsLite application shown in lecture, however it will be re-written from the ground-up using CoreData. Contacts Lite will be used as a reference for more of the visual aspects of the application (including storyboards and navigation), however the backend for loading/saving contacts will be re-written for CoreData use.


### Part 0: Familiarizing with ContactsLite
In this section, students will be asked to clone the [ContactsLite Application](https://github.com/profh/67442_ContactsLite) and familiarize with how plists are used to manage information. This will also give students a chance to look at the visuals for ContactsLite to remember how it was set up.

### Part 1: Starting the ContactsAdvanced Application
In this section, students will be asked to set up a new Xcode project from scratch **being sure to check** `Use Core Data` **in the setup dialogs** and re-create the visuals for the application.

The goal by the end of the section will be to launch a non-saving application that allows for a contact to be entered and the cells in the table view transitioning appropriately to the detail view.

One feature to walkthrough would be uploading images of users for their contacts (such as a contact photo).

### Part 2: Adding Core Data
Here, after the main UI functionality has been built, we will walk students through the process of setting up entities in CoreData, saving data, and loading data.

The first step will be setting up the entities through the GUI in Xcode. This will guide students through the GUI as well and we will provide a (simple) set of entities to use (i.e. using the provided `xcdatamodeld` file).

The second step will be to setup delegation/contexts.

The third step will be to implement saving data, and checking to see that data has been saved properly.

The fourth step will be to load data and update the table view accordingly.
