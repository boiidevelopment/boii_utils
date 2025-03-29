## Characters Module

The Characters module handles everything related to character customisation, including appearance styles, tattoos, clothing, and genetics. It is fully client-side and provides a consistent structure for defining, resetting, and applying player ped appearance.

---

### Accessing the Module

```lua
local CHARACTERS <const> = exports.boii_utils:get("modules.characters")
```

---

## Client

### get_style(sex)

Retrieves the current appearance data structure for the given sex.

#### Parameters

| Name | Type | Description |
|------|------|-------------|
| sex | `string` | Either `"m"` or `"f"` to get the appropriate structure. |

#### Example

```lua
local style = CHARACTERS.get_style("m")
print(style.clothing.jacket_style)
```

---

### reset_styles()

Resets all style data back to defaults for both male and female presets.

#### Parameters
_None_

#### Example

```lua
CHARACTERS.reset_styles()
```

---

### get_clothing_and_prop_values(sex)

Returns maximum drawable/texture values for clothing and props for UI sliders.

#### Parameters

| Name | Type | Description |
|------|------|-------------|
| sex | `string` | Either `"m"` or `"f"` |

#### Returns

A table of maximum drawable values.

#### Example

```lua
local values = CHARACTERS.get_clothing_and_prop_values("f")
print(values.hair, values.mask_texture)
```

---

### set_ped_appearance(player, data)

Applies the full style data (genetics, hair, clothing, etc.) to the specified ped.

#### Parameters

| Name | Type | Description |
|------|------|-------------|
| player | `number` | The `PlayerPedId()` to apply the style to. |
| data | `table` | The full character style data table. |

#### Example

```lua
local ped = PlayerPedId()
local style = CHARACTERS.get_style("m")
CHARACTERS.set_ped_appearance(ped, style)
```

---

### update_ped_data(sex, category, id, value)

Updates a specific field in the ped style table and applies the changes to the current ped.

#### Parameters

| Name | Type | Description |
|------|------|-------------|
| sex | `string` | "m" or "f" to choose the dataset |
| category | `string` | The sub-table: "genetics", "barber", or "clothing" |
| id | `string` | The field inside the category to update |
| value | `number` or `table` | The value to assign |

#### Example

```lua
CHARACTERS.update_ped_data("f", "barber", "hair", 6)
CHARACTERS.update_ped_data("f", "genetics", "eye_colour", 2)
```

---

### change_player_ped(sex)

Changes the current player's ped model and reapplies stored appearance.

#### Parameters

| Name | Type | Description |
|------|------|-------------|
| sex | `string` | "m" or "f" |

#### Example

```lua
CHARACTERS.change_player_ped("f")
```

---

### rotate_ped(direction)

Rotates the current ped preview left, right, flip or reset.

#### Parameters

| Name | Type | Description |
|------|------|-------------|
| direction | `string` | "right", "left", "flip", or "reset" |

#### Example

```lua
CHARACTERS.rotate_ped("left")
```

---

### load_character_model(data)

Sets the current player's model and applies the entire style set from saved character data.

#### Parameters

| Name | Type | Description |
|------|------|-------------|
| data | `table` | The full identity and style structure used in character systems. |

#### Example

```lua
CHARACTERS.load_character_model({
    identity = { sex = "m" },
    style = CHARACTERS.get_style("m")
})
```

---

## Notes

- All functions are client-only
- Style tables are separated by sex (`m`, `f`)
- Update functions apply changes immediately to ped
- You can deep copy and modify style structures before applying them