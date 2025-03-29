## Requests Module

Lightweight utility wrappers for native resource loading in CFX.

---

### Accessing the Module

```lua
local REQUESTS <const> = exports.boii_utils:get("modules.requests")
```

---

## Client Only

### model(model)

Requests and loads a model.

#### Parameters
| Name  | Type   | Description              |
|-------|--------|--------------------------|
| model | `hash` | Hash of the model to load |

#### Example
```lua
REQUESTS.model(GetHashKey("prop_bench_01a"))
```

---

### interior(interior)

Requests and loads an interior.

#### Parameters
| Name      | Type     | Description                |
|-----------|----------|----------------------------|
| interior  | `number` | Interior ID to load        |

#### Example
```lua
REQUESTS.interior(GetInteriorAtCoords(435.5, -979.0, 30.0))
```

---

### texture(texture, wait)

Requests and optionally waits for a texture dictionary to load.

#### Parameters
| Name     | Type      | Description                      |
|----------|-----------|----------------------------------|
| texture  | `string`  | Texture dictionary name          |
| wait     | `boolean` | Whether to wait for the load     |

#### Example
```lua
REQUESTS.texture("commonmenu", true)
```

---

### collision(x, y, z)

Requests collision around a coordinate.

#### Parameters
| Name | Type     | Description          |
|------|----------|----------------------|
| x    | `number` | X coordinate         |
| y    | `number` | Y coordinate         |
| z    | `number` | Z coordinate         |

#### Example
```lua
REQUESTS.collision(200.0, -1000.0, 30.0)
```

---

### anim(dict)

Requests and loads an animation dictionary.

#### Parameters
| Name | Type     | Description               |
|------|----------|---------------------------|
| dict | `string` | Animation dictionary name |

#### Example
```lua
REQUESTS.anim("amb@world_human_bum_freeway@male@base")
```

---

### anim_set(set)

Requests and loads an animation set.

#### Parameters
| Name | Type     | Description            |
|------|----------|------------------------|
| set  | `string` | Animation set name     |

#### Example
```lua
REQUESTS.anim_set("move_m@business@a")
```

---

### clip_set(clip)

Requests and loads an animation clip set.

#### Parameters
| Name | Type     | Description            |
|------|----------|------------------------|
| clip | `string` | Clip set name          |

#### Example
```lua
REQUESTS.clip_set("move_clipset@pistol")
```

---

### audio_bank(audio)

Requests and loads a script audio bank.

#### Parameters
| Name  | Type     | Description        |
|-------|----------|--------------------|
| audio | `string` | Audio bank name    |

#### Example
```lua
REQUESTS.audio_bank("DLC_HEIST_HACKING_SNAKE_SOUNDS")
```

---

### scaleform_movie(scaleform)

Requests and loads a scaleform movie.

#### Parameters
| Name       | Type     | Description             |
|------------|----------|-------------------------|
| scaleform  | `string` | Name of the scaleform   |

#### Returns
| Type     | Description              |
|----------|--------------------------|
| `number` | Handle to the scaleform  |

#### Example
```lua
local handle = REQUESTS.scaleform_movie("instructional_buttons")
```

---

### cutscene(scene)

Requests and loads a cutscene.

#### Parameters
| Name  | Type     | Description           |
|-------|----------|-----------------------|
| scene | `string` | Cutscene name         |

#### Example
```lua
REQUESTS.cutscene("mp_introduction")
```

---

### ipl(str)

Requests and loads an IPL (map file).

#### Parameters
| Name | Type     | Description       |
|------|----------|-------------------|
| str  | `string` | IPL name to load  |

#### Example
```lua
REQUESTS.ipl("hei_bi_hw1_13_door")
```

---

## Notes
- All request functions wait until the resource is fully loaded.
- Client-side use only.
- Designed to simplify native calls in setup-heavy client scripts.