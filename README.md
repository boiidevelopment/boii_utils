# BOII Development - Developer Utility Library

## 🌍 Overview

Welcome to `boii_utils`, a comprehensive utility resource tailored for resource developers and server administrators.
This suite of tools is designed to simplify, streamline, and enhance the development process, offering a wide range of functionalities that span from string manipulations to table operations, and from input validations to miscellaneous utilities.

The utility library is constantly growing, anything that can save development time for boii resources gets added.
If its saving us time, it should save you time also.

The main aim here is just to create a large consolidated resource to handle the majority of repeat code and cut down on repetitive for everyone.

Happy Scripting!

## 🌐 Features

Utils covers a pretty large range of things so this section is a little long.

### Client

- **Blip Manager:** Various functions all related to blips, including features to create, update, or toggle blip visibility for either all or specific categories.
- **Callback System:** Standalone callback system to help speed up the scripting process, instead of creating individual callbacks for multiple frameworks this gives a dedicated location to allow for 1 callback for all.
- **Character Creation:** Various functions and tables all related to creating characters anything you could need to create a character creator script or a clothing store could be done using these. The multicharacter within boii_framework currently uses this section.
- **Command System:** A standalone command system, similar to callback system. This is to save on the need for typing different commands for multiple frameworks.
- **Conversion Utilities:** This section syncs any converted framework specific data into utils data. Currently this only covers qb-core licences and metadata.
- **Cooldown System:** Easy to use cooldown system to allow for setting cooldowns in a variety of ways.
- **Developer Utilities:** This is just a straight forward section to allow developers to display some useful on screen drawtext from coords to player info.
- **Draw Utilities:** Covers all the default "draw" functions along with a variety of custom functions to draw specific shapes.
- **Entities Utilities:** Variety of functions related to entities. Covers things like get closest player, vehicle, objects etc.
- **Environment Utilities:** Various functions for environment related things, for example getting the current weather name.
- **Framework Brige:** Possibly the most important. This section covers a large variety of functions to bridge common functionalities between any framework.
- **Group System:** Built into utils is an in-depth group system to allow for players to group up to perform activities, races, and anything else in between.
- **Licence System:** Standalone licencing system to allow for things like drivers licences and any other licences you can think of.
- **Notifications Bridge:** This section is going to be removed as soon as possible, it has been replaced by the new ui section.
- **Ped Manager:** Various functions all relating to peds. This includes creating peds, adding weapons, animations, and more.
- **Player Utilities:** Variety of functions relating to the player character. Covers things like retreiving the players cardinal direction, getting their current weapon and a few other useful things.
- **Reputation System:** Another element built into utils is a standalone reputation system, allows for a dedicated location for giving rep to pretty much anything you desire.
- **Request Utilities:** This section covers everything relating to default "request" functions.
- **Skill System:** A in-depth standalone skills system, to you guessed it, provide players with skills.
- **UI Bridge:** The UI bridge is intended to create a dedicated location to allow for bridging various different types of ui elements used as every server uses different things. This is for things like notifications, progress bars, drawtext ui's etc.
- **Vehicle Utilities:** Large variety of vehicle related functions to do pretty much anything you could want or need to do.
- **Zone System:** Another element included is zones, this allows you to dedicate zones around the map to validate player positions, define safe zones, etc.

### Server

- **Bucket Utilities:** This section covers anything related to FiveM routing buckets.
- **Callback System:** Server side of the standalone call back system. 
- **Command System:** Server side of the command system, also includes a dedicated command list if you wish to have a location to create commands internally.
- **Connections Management:** This section controls players connecting, adds a user to the utils tables if one does not exist and checks for ban statuses.
- **Conversion Utilities:** Server side of the framework conversion utilities.
- **Cooldown System:** Server side for the cooldown system.
- **Database Utilities:** A section for functions relating to all things database. Currently this section is bare bones however it will be added too as needed.
- **Date & Time Utilities:** Variety of functions relating to the date and time. Covers things like converting timestamps, converting os.time into readable times etc.
- **Framework Bridge:** Server side to the framework bridge, this is rather in-depth and covers a large variety of things needed to speed up multi framework script development.
- **Group System:** Server side to the group system.
- **Usable Items System:** A standalone setup to allow for creating usable items to remove the need of creating usables in different formats for frameworks.
- **Licence System:** Server side to the licence system.
- **Networking Utilities:** Section to allow for creating synced data between server and client.
- **Notifications Bridge:** This section is going to be removed as soon as possible, it has been replaced by the new ui section.
- **Reputation System:** Server side to the reputation system.
- **Scope Utilities:** Section with a variety of functions relating to player scopes.
- **Skill System:** Server side to the skill system.
- **UI Bridge:** The UI bridge is intended to create a dedicated location to allow for bridging various different types of ui elements used as every server uses different things. This is for things like notifications, progress bars, drawtext ui's etc.
- **Versioning Utilities:** Section for script version control. This uses a json table stored within a github repo in order to store versioning details and compare against.
- **Zone System:** Server side to the zone system.

### Shared

- **Data Section:** Section to store any shared data, this can be used to store things required be external resources. It currently houses all character related data to be used by the character creation utilities.
- **Debugging Utilities:** Variety of functions for debugging and sending debug messages.
- **General Utilities:** Variety of functions to cover things more general in nature. Covers things like emulating try catch behaviour, to converting rgb values.
- **Geometry Utilities:** A large variety of functions related to geometry within the game world. Covering things like angles between points, checking if a point is within a location and validating distances.
- **Key Utilities:** Small section dedicated to key presses. 
- **Math Utilities:** A large variety of math related functions to ease up development.
- **Networking Utilities:** Shared location for networked data.
- **Serialization Utilities:** Variety of functions to allow for the serialization of data.
- **String Utilities:** Section contains functions related to strings. For example, string splitting, counting occurrences and more.
- **Table Utilities:** Large variety of functions to handle pretty much anything you could want or need relating to tables.
- **Validation Utilities:** Variety of functions to ease up repeat typing for validating data.

## 💹 Dependencies

None utils is standalone. 
For framework bridge functions you of course need your chosen framework installed.

## 📝 Notes

- Utils is constantly being developed, some things may change that may affect functionality of resources you choose to build with this. However we will try to minimise this as much as possible.
- New functions are being added all the time, as updated progress for boii development resources if theres something that can save future time by adding into utils, it will be added.

## 🤝 Contributions

Contributions are welcome! 
If you'd like to contribute to the development of the utility library, or any additional free resource created by BOII Development, please fork the repository and submit a pull request or contact through discord.

## 📝 Documentation

https://docs.boii.dev/fivem-resources/free-resources/boii_utils

## 📩 Support

https://discord.gg/boiidevelopment
