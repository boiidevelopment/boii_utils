## UI Elements

Provides client-side utility UI elements for interaction, feedback, and user experience. 
These are used as fallbacks when bridge UIs are unavailable or can be directly used in scripts.

---

### Accessing

The UI elements are accessed exclusively through exports.

---

## Client

### notify(options)
Displays a notification popup to the player.

#### Parameters
| Name        | Type     | Description                                       |
|-------------|----------|---------------------------------------------------|
| type        | `string` | Notification type (`success`, `error`, `info`)   |
| header      | `string` | Header text (optional)                           |
| message     | `string` | Message body of the notification                 |
| duration    | `number` | Duration in milliseconds (default: 3500)         |
| style       | `table`  | Optional custom CSS styling                      |

#### Example
```lua
exports.boii_utils:notify({
    type = 'success',
    header = 'Success!',
    message = 'You received $1000',
    duration = 5000
})
```

---

### show_progressbar(options)
Displays a progress bar overlay.

#### Parameters
| Name     | Type     | Description                          |
|----------|----------|--------------------------------------|
| header   | `string` | Text shown above the progress bar    |
| icon     | `string` | FontAwesome icon class               |
| duration | `number` | Duration in milliseconds             |

#### Example
```lua
exports.boii_utils:show_progressbar({
    header = 'Processing...',
    icon = 'fa-solid fa-cog',
    duration = 3000
})
```

---

### hide_progressbar()
Hides the progress bar.

#### Example
```lua
exports.boii_utils:hide_progressbar()
```

---

### show_circle(options)
Displays a progress circle.

#### Parameters
| Name     | Type     | Description                           |
|----------|----------|---------------------------------------|
| message  | `string` | Text displayed in the circle center   |
| duration | `number` | Duration in seconds                   |

#### Example
```lua
exports.boii_utils:show_circle({
    message = 'Gathering...',
    duration = 10
})
```

---

### show_drawtext(options)
Displays drawtext UI overlay.

#### Parameters
| Name        | Type     | Description                                  |
|-------------|----------|----------------------------------------------|
| header      | `string` | Title text                                   |
| message     | `string` | Subtitle message text                        |
| icon        | `string` | FontAwesome icon class (optional)           |
| keypress    | `string` | Key indicator (optional)                    |
| bar_colour  | `string` | HEX color code for bar (optional)           |
| style       | `table`  | Optional custom CSS styling                 |

#### Example
```lua
exports.boii_utils:show_drawtext({
    header = 'ATM',
    message = 'Press E to interact',
    keypress = 'e',
    bar_colour = '#00ff99'
})
```

---

### hide_drawtext()
Hides drawtext UI overlay.

#### Example
```lua
exports.boii_utils:hide_drawtext()
```

---

### dialogue(dialogue_data, npc, coords)
Opens a dialogue interaction sequence.

#### Parameters
| Name        | Type     | Description                               |
|-------------|----------|-------------------------------------------|
| dialogue    | `table`  | Dialogue data (header, lines, options)     |
| npc         | `number` | Entity ID of the speaking NPC              |
| coords      | `vector3`| Player-facing orientation vector           |

#### Example
```lua
exports.boii_utils:dialogue({
    header = {
        message = 'Foreman',
        icon = 'fa-solid fa-hard-hat'
    },
    conversation = {
        {
            id = 1,
            response = {
                'This job site is dangerous.',
                'What do you need?'
            },
            options = {
                {
                    icon = 'fa-solid fa-info-circle',
                    message = 'Tell me more.',
                    next_id = 2
                },
                {
                    icon = 'fa-solid fa-door-closed',
                    message = 'Goodbye.',
                    should_end = true
                }
            }
        }
    }
}, npc, coords)
```

---

### context_menu(menu_data)
Opens a context menu with selectable items or toggles.

#### Parameters
| Name       | Type     | Description                         |
|------------|----------|-------------------------------------|
| menu_data  | `table`  | Contains header and content config  |

#### Example
```lua
exports.boii_utils:context_menu({
    header = {
        title = 'Actions',
        subtitle = 'Select an option',
        icon = 'fa-solid fa-user'
    },
    content = {
        {
            label = 'Inventory',
            icon = 'fa-solid fa-boxes',
            action = { type = 'client', name = 'open_inventory' },
            should_close = true
        },
        {
            label = 'Enable Music',
            type = 'checkbox',
            state = true,
            on_change = { type = 'client', name = 'toggle_music' }
        }
    }
})
```

---

### action_menu(menu_data)
Creates a layered action menu with submenu support.

#### Parameters
| Name       | Type     | Description                          |
|------------|----------|--------------------------------------|
| menu_data  | `table`  | Menu content structure and actions   |

#### Example
```lua
exports.boii_utils:action_menu({
    {
        label = 'Main Menu',
        icon = 'fa-solid fa-bars',
        submenu = {
            {
                label = 'Settings',
                icon = 'fa-solid fa-cogs',
                submenu = {
                    {
                        label = 'Graphics',
                        icon = 'fa-solid fa-desktop',
                        action_type = 'client_event',
                        action = 'open_graphics_menu'
                    }
                }
            }
        }
    }
})
```

---

## Notes
- All functions are client-side only.
- FontAwesome icons are required for most menus.
- These UIs serve as fallbacks or standalone UI solutions.
