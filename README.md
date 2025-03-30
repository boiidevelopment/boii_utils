# BOII Developer Utility Library (v2.0)

![utils_thumb](https://github.com/user-attachments/assets/e80578e0-42a6-499d-93fb-1eec1716f196)

## Overview

Welcome to boii_utils — your new favorite excuse to never write boilerplate code again.

This all-in-one, modular, feature-stuffed utility library is built specifically for FiveM script developers who are tired of reinventing the wheel every time they touch a new resource.

In v2.0, everything’s been rewritten from the ground up:

- The bloat? Gone.
- The bugs? Squashed.
- The logic? Rewired with duct tape and ambition.
- The license? MIT, because freedom tastes better without GPL breath.

What you’re getting now is a cleaner, faster, actually organized toolkit designed to make your life easier and your codebase prettier.
Use just what you need, ignore the rest, and regain a little sanity.

## Why use boii_utils?

- **Simplifies Scripting:** Functions that just work, without needing a 12-tab Stack Overflow deep dive.
- **Prebuilt Systems:** Fully modular. Plug in, power up, and pretend you built it from scratch.
- **Reduces Dev Load:** Spend less time writing boilerplate and more time watching your players ignore your server rules.

## Highlights

### **Framework & UI Bridges:** Making peace treaties between frameworks since inception.
- **Framework Bridge:** `boii`, `esx`, `nd`, `ox`, `qb`, `qbx` because commitment issues are real.
- **Notification Bridge:** `default`, `boii`, `esx`, `okok`, `ox`, `qb` every flavor of annoying popup you could desire.
- **DrawText Bridge:** `default`, `boii`, `esx`, `okok`, `ox`, `qb` for when you really need to make your players read something.

### **Standalone Systems:** Because frameworks shouldn’t hold all the power.
- **Callbacks:** For when you're tired of yelling into the void; now it yells back, politely.
- **Commands:** Database-backed permissions included, or switch to Ace if you insist on complicating things.
- **Licences:** Comprehensive license system including theory tests, practical tests, points management, and revoking, like your local DMV, minus the soul-crushing lines.
- **XP:** Level-up system with growth factors and max levels, because who doesn't love arbitrary numbers going up?

### **Unique Scripting Modules:** Pre-made shortcuts for the lazy genius in all of us.
- **Characters Module:** Enough functions to build character creators, clothing stores, tattoos, everything you need to keep your players staring at themselves for hours.
- **Vehicles Module:** If it drives and you can customize it, these functions probably have you covered.

### **UI Elements:** The obligatory flashy bits to trick players into thinking you know what you're doing.
- **Action Menu:** Bored of spinning circles deciding what to click next? Try out a different take.
- **Context Menu:** Simple and effective, with header images.
- **Dialogue:** NPC conversations without the awkward silence.
- **DrawText:** Display on screen text clearly, ensuring players ignore it even faster.
- **Notify:** Notification styles for all occasions: `success`, `error`, `info`, `warning`, `primary`, `secondary`, `light`, `dark`, `critical`, `neutral`.
- **Progress Bar:** The classic, comforting sight of incremental loading bars.
- **Progress Circle:** Revolutionary innovation.. it's like a progress bar, but circular!

## All Modules

- **Framework Bridge:** Bridges multiple cores through one api.
- **Notifications Bridge:** Bridges multiple different notification resources through one api.
- **DrawText UI Bridge:** Bridges multiple different drawtext ui resources through one api.
- **Callbacks:** A standalone alternative to framework systems.
- **Characters:** Covers all character customisation relevant function with shared styles data.
- **Commands:** A standalone alternative to framework systems.
- **Debugging:** A couple of useful debugging functions.
- **Entities:** Everything related to entities (npc, vehicles, objects) within the game world.
- **Environment:** Set of function to cover everything enviroment, from current times to simulated seasons.
- **Geometry:** Suite of functions to simplfy geometric calculations in 2d and 3d space.
- **Items:** A standalone usable items registry to provide an alternative to framework specific systems.
- **Keys:** Includes a full static key list and simple function to get and retrieve keys by name or value.
- **Licences:** Full standalone licence system with support for point systems, theory and practical test markers, with support for licence revoking.
- **Maths:** Extends base `math.` functionality with a large suite of additional functions.
- **Methods:** Provides a system to register, remove, and trigger custom method callbacks on both the client and server.
- **Player:** Small amount of player related functions such as retrieving the players cardinal direction or running animations on the player with full attached prop support.
- **Requests:** Set of wrapper functions around cfx `Request` functions.
- **Strings:** Extends base `string.` functionality by adding some addition functions.
- **Tables:** Extends base `table.` functionality by adding some useful functions otherwise not already provided.
- **Timestamps:** Covers everything related to server side timestamps with formatted responses.
- **Vehicles:** Large suite of vehicle related functions, should include everything needed to create a vehicle customs resource.
- **Version:** Provides resource version checking from an externally hosted `.json` file.
- **XP:** Full standalone XP system with support for types, growth factors and max levels.

## UI Screenshots

![Menus and DrawText](https://i.ibb.co/PG7vKfPB/image-2025-03-15-004251413.png)  
![Progress Bars](https://i.ibb.co/9HkYnYqh/image-2025-03-15-004440049.png)

## Installation

You know the drill.

1. Drop it in your `resources/`.
2. Insert the included `REQUIRED.sql` into your database.
3. `ensure boii_utils`.
4. Restart your server.

Full setup guide: `docs/2-Installation.md`.

## Dependencies

- **[OxMySQL](https://github.com/overextended/oxmysql/releases)**

## License

Released under the MIT License.
That means it’s free, open-source, and yours to use, modify, or build on — just don’t remove the license or the credit.
You’re welcome to profit from it, but let’s keep things respectful: don’t act like you wrote it all yourself.

## Contributing

Got code? Great. Got opinions? Even better.

If you’ve written something useful, spotted something broken, or just want eternal internet glory *(or shame)*, submit a pr.
We welcome contributions, improvements, fixes, and clever feature requests.

You can also reach out through Discord if you would prefer.

## Notes

- Currently documentation for the library is limited to the included `docs` files, these will be moved to gitbook in time however for now it will have to do.

## Support

Need help? Found a bug? Need to vent about a bug that isn’t from this library?
Support is available through the BOII Development **[Discord](https://discord.gg/MUckUyS5Kq)**.

> Support Hours: Mon–Fri, 10AM–10PM GMT

Outside those hours? Pray to the debug gods or leave a message.
