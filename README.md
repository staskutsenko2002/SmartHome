# SmartHome

Hello dear reviewers!

Here is my small SmartHome project. 
It is written with no packages nor cocoapods, using layout in code. The architecture is MVVM-C. 
The application is localized with 4 languages (English, French, Spanish, Herbew).
Each device type has a dedicated class.
Also, you can find unit tests.

# Pages
There are 3 pages (Devices, Details, User).
Devices and User pages contain StateView (loading, loaded, empty, error).

Note:
I repeated API call to separate requesting of devices and user. I know it's a bad practice. Made just to demonstrate 2 different modules both with networking communication.

# Devices
This page is a list of our devices. We can go through it and tap on any device we want to modify it settings (here we proceed to Device Details page).
Contains Pull to refresh (to fetch data again).

# Details
Here we can adjust temperature(for heater), intensity(for light) and position(for roller). Also, we can change mode (ON/OFF) of light and heater.
When we go back to the list of out devices, the data is being updated and we will see the updates on the device we've just made.

# User
Here we can see our user information. There is update data button(top right corner).

