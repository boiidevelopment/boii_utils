# 2 - Installation

Before installing the library into your server please make sure you have the following dependencies in your server resources, setup and ready to go.

## Dependencies

- **[OxMySQL](https://github.com/overextended/oxmysql/releases)**

**If you want to make use of the framework or ui bridges you of course need the correct framework core/resources**

## Downloading The Library

- **[BDTK](https://github.com/boiidevelopment/boii_utils/releases)**

## Installation

The library is mostly drag and drop unless you want to modify some functionality.
For example; by default `AUTO_DETECT_FRAMEWORK` is enabled, if you want to run the library standalone you need to modify the `ENV` values for this.

You can find more in-depth details on configuring the library in **3-Configuration.md**.
If you want to make configuration changes do these before adding the library, save on adding twice.

### Database Tables

Included with the library are some `.sql` files which you need to add into your database. 

- `REQUIRED.sql`: This is is the main tables used by the library for user accounts and bans.
- `frameworks/*.sql`: These are tables to cover `utils_xp` and `utils_licences` for the libraries standalone systems.

The libraries standalone command system uses the `utils_users` table from `REQUIRED.sql` to handle admin permissions. 
Once you have joined the server for the first time you can update this in your database. 

Default Ranks: `("member", "mod", "admin", "dev", "owner")`


### Adding The Library

1. Add the `boii_utils` into your server resources.

2. Add `ensure boii_utils` into your `server.cfg`; 
- You can add the libraries convars also if you would like; view the included `convars.cfg` file, or they are covered in more detail in **3-Configuration.md**.

3. If all installation steps have been completed *(and optional configuration customisation)*, restart your server and you should be up and running.