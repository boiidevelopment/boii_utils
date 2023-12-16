--[[
    GENERAL COMMAND
]]

RegisterCommand("test_general_utils", function(source, args, rawCommand)
    print("is_number(123): " .. tostring(utils.general.is_number(123)))
    print("is_string('Hello'): " .. tostring(utils.general.is_string('Hello')))
    print("is_table({a = 1, b = 2}): " .. tostring(utils.general.is_table({a = 1, b = 2})))
    print("is_function(function() return end): " .. tostring(utils.general.is_function(function() return end)))
    print("is_boolean(true): " .. tostring(utils.general.is_boolean(true)))
    print("coalesce(nil, 'Hello', 'World'): " .. tostring(utils.general.coalesce(nil, "Hello", "World")))
    print("toggle_value('red', 'red', 'blue'): " .. utils.general.toggle_value('red', 'red', 'blue'))
    print("bool_to_string(true): " .. utils.general.bool_to_string(true))
    print("rgb_to_hex(255, 0, 0): " .. utils.general.rgb_to_hex(255, 0, 0))
    utils.general.try_catch(function() error("Oops!") end, function(err) print("Caught error: " .. err) end)
    local once_function = utils.general.once(function() print("This should print only once!") end)
    once_function()
    once_function()
    local throttled_print = utils.general.throttle(function() print("Throttled Hello!") end, 5000)
    throttled_print()
    throttled_print()
    print("All tests done!")
end, false)

--[[
    MATHS COMMAND
]]

RegisterCommand("test_math_utils", function(source, args, rawCommand)
    print("round_number(5.6789, 2): " .. tostring(utils.maths.round_number(5.6789, 2)))
    print("calculate_distance({x = 0, y = 0, z = 0}, {x = 3, y = 4, z = 0}): " .. tostring(utils.maths.calculate_distance({x = 0, y = 0, z = 0}, {x = 3, y = 4, z = 0})))
    print("clamp(15, 10, 20): " .. tostring(utils.maths.clamp(15, 10, 20)))
    print("is_within_range(5, 1, 10): " .. tostring(utils.maths.is_within_range(5, 1, 10)))
    print("lerp(0, 10, 0.5): " .. tostring(utils.maths.lerp(0, 10, 0.5)))
    print("random_between(1, 10): " .. tostring(utils.maths.random_between(1, 10)))
    print("factorial(5): " .. tostring(utils.maths.factorial(5)))
    print("is_even(4): " .. tostring(utils.maths.is_even(4)))
    print("is_odd(3): " .. tostring(utils.maths.is_odd(3)))
    print("deg_to_rad(180): " .. tostring(utils.maths.deg_to_rad(180)))
    print("rad_to_deg(math.pi): " .. tostring(utils.maths.rad_to_deg(math.pi)))
    print("angle_between_points({x = 0, y = 0}, {x = 1, y = 1}): " .. tostring(utils.maths.angle_between_points({x = 0, y = 0}, {x = 1, y = 1})))
    local mp = utils.maths.midpoint({x = 0, y = 0, z = 0}, {x = 2, y = 2, z = 2})
    print(string.format("midpoint({x = 0, y = 0, z = 0}, {x = 2, y = 2, z = 2}): {x = %f, y = %f, z = %f}", mp.x, mp.y, mp.z))
    print("is_point_in_rect({x = 1, y = 1}, {x = 0, y = 0, width = 3, height = 3}): " .. tostring(utils.maths.is_point_in_rect({x = 1, y = 1}, {x = 0, y = 0, width = 3, height = 3})))
    print("is_point_in_box({x = 1, y = 1, z = 1}, {x = 0, y = 0, z = 0, width = 3, height = 3, depth = 3}): " .. tostring(utils.maths.is_point_in_box({x = 1, y = 1, z = 1}, {x = 0, y = 0, z = 0, width = 3, height = 3, depth = 3})))
    print("calculate_slope({x = 0, y = 0}, {x = 2, y = 2}): " .. tostring(utils.maths.calculate_slope({x = 0, y = 0}, {x = 2, y = 2})))
    print("safe_divide(10, 2): " .. tostring(utils.maths.safe_divide(10, 2)))
    print("safe_divide(10, 0): " .. tostring(utils.maths.safe_divide(10, 0)))
    print("All math tests done!")
end, false)

--[[
    STRINGS COMMAND
]]

RegisterCommand("teststringutils", function(source, args, rawCommand)
    print("trim('  Hello World  '): " .. tostring(utils.strings.trim("  Hello World  ")))
    print("starts_with('Hello World', 'Hello'): " .. tostring(utils.strings.starts_with("Hello World", "Hello")))
    print("ends_with('Hello World', 'World'): " .. tostring(utils.strings.ends_with("Hello World", "World")))
    print("to_upper('Hello World'): " .. utils.strings.to_upper("Hello World"))
    print("to_lower('Hello World'): " .. utils.strings.to_lower("Hello World"))
    local parts = utils.strings.split_string("Hello,World", ",")
    print("split_string('Hello,World', ','): " .. table.concat(parts, ", "))
    print("count_occurrences('Hello World Hello Lua', 'Hello'): " .. tostring(utils.strings.count_occurrences("Hello World Hello Lua", "Hello")))
    print("replace_string('Hello World Hello Lua', 'Hello', 'Hi'): " .. utils.strings.replace_string("Hello World Hello Lua", "Hello", "Hi"))
    print("reverse_string('Hello'): " .. utils.strings.reverse_string("Hello"))
    print("pad_left('Hello', 10, '*'): " .. utils.strings.pad_left("Hello", 10, "*"))
    print("pad_right('Hello', 10, '*'): " .. utils.strings.pad_right("Hello", 10, "*"))
    print("string_contains('Hello World', 'World'): " .. tostring(utils.strings.string_contains("Hello World", "World")))
    print("to_boolean('true'): " .. tostring(utils.strings.to_boolean("true")))
    print("capitalize('hello world'): " .. utils.strings.capitalize("hello world"))
    print("repeat_string('Hello', 3): " .. utils.strings.repeat_string("Hello", 3))
    print("format_str('Hello %s!', 'World'): " .. utils.strings.format_str("Hello %s!", "World"))
    print("random_string(10): " .. utils.strings.random_string(10))
    print("concat_table({'Hello', ' ', 'World'}): " .. utils.strings.concat_table({"Hello", " ", "World"}))
    print("is_alphabet('Hello'): " .. tostring(utils.strings.is_alphabet("Hello")))
    print("is_alphabet('Hello123'): " .. tostring(utils.strings.is_alphabet("Hello123")))
    print("All string tests done!")
end, false)

--[[
    TABLES COMMAND
]]

RegisterCommand("testtableutils", function(source, args, rawCommand)
    print("table_contains({1, 2, 3, 4, 5}, 3): " .. tostring(utils.tables.table_contains({1, 2, 3, 4, 5}, 3)))
    print("table_count({a = 1, b = 2, c = 3}): " .. tostring(utils.tables.table_count({a = 1, b = 2, c = 3})))
    local original_table = {a = 1, b = 2}
    local copied_table = utils.tables.deep_copy(original_table)
    copied_table.b = 5
    print("deep_copy({a = 1, b = 2}): Modified copied_table.b = 5; Original b = " .. tostring(original_table.b))
    print("flatten({1, 2, {3, 4, {5, 6}}, 7}): " .. table.concat(utils.tables.flatten({1, 2, {3, 4, {5, 6}}, 7}), ", "))
    local merged_table = utils.tables.merge_tables({a = 1, b = 2}, {b = 3, c = 4})
    print("merge_tables({a = 1, b = 2}, {b = 3, c = 4}): b = " .. tostring(merged_table.b))    
    print("remove_value_from_table({1, 2, 3, 4, 5}, 3): " .. table.concat(utils.tables.remove_value_from_table({1, 2, 3, 4, 5}, 3), ", "))
    print("filter_table({1, 2, 3, 4, 5}, even function): " .. table.concat(utils.tables.filter_table({1, 2, 3, 4, 5}, function(num) return num % 2 == 0 end), ", "))
    print("map_table({1, 2, 3, 4, 5}, double function): " .. table.concat(utils.tables.map_table({1, 2, 3, 4, 5}, function(num) return num * 2 end), ", "))
    print("find_in_table({1, 2, 3, 4, 5}, greater than 3): " .. tostring(utils.tables.find_in_table({1, 2, 3, 4, 5}, function(num) return num > 3 end)))
    print("get_keys({a = 1, b = 2, c = 3}): " .. table.concat(utils.tables.get_keys({a = 1, b = 2, c = 3}), ", "))
    print("union({1, 2, 3}, {3, 4, 5}): " .. table.concat(utils.tables.union({1, 2, 3}, {3, 4, 5}), ", "))
    print("intersection({1, 2, 3}, {3, 4, 5}): " .. table.concat(utils.tables.intersection({1, 2, 3}, {3, 4, 5}), ", "))
    print("difference({1, 2, 3}, {3, 4, 5}): " .. table.concat(utils.tables.difference({1, 2, 3}, {3, 4, 5}), ", "))
    print("shuffle({1, 2, 3, 4, 5}): " .. table.concat(utils.tables.shuffle({1, 2, 3, 4, 5}), ", "))
    print("reduce({1, 2, 3, 4}, sum): " .. tostring(utils.tables.reduce({1, 2, 3, 4}, function(acc, val) return acc + val end, 0)))
    print("every({2, 4, 6}, even): " .. tostring(utils.tables.every({2, 4, 6}, function(num) return num % 2 == 0 end)))
    print("some({2, 4, 5}, odd): " .. tostring(utils.tables.some({2, 4, 5}, function(num) return num % 2 ~= 0 end)))
    local tbl = {1, 2, 3}
    utils.tables.push(tbl, 4)
    print("push({1, 2, 3}, 4): " .. table.concat(tbl, ", "))
    print("pop({1, 2, 3, 4}): " .. tostring(utils.tables.pop(tbl)))
    local tbl2 = {2, 3, 4}
    utils.tables.unshift(tbl2, 1)
    print("unshift({2, 3, 4}, 1): " .. table.concat(tbl2, ", "))
    print("shift({1, 2, 3, 4}): " .. tostring(utils.tables.shift(tbl2)))
    print("All table tests done!")
end, false)

--[[
    VALIDATION COMMAND
]]

RegisterCommand("test_validation_utils", function()
    print("Testing Input Validation Utilities:")
    print("has_min_length('Hello', 5): " .. tostring(utils.validation.has_min_length("Hello", 5)))
    print("has_max_length('Hello', 10): " .. tostring(utils.validation.has_max_length("Hello", 10)))
    print("matches_pattern('abc', '^%a+$'): " .. tostring(utils.validation.matches_pattern("abc", "^%a+$")))
    print("is_email('test@example.com'): " .. tostring(utils.validation.is_email("test@example.com")))
    print("is_alpha('Hello'): " .. tostring(utils.validation.is_alpha("Hello")))
    print("is_digit('12345'): " .. tostring(utils.validation.is_digit("12345")))
    print("is_alphanumeric('Hello123'): " .. tostring(utils.validation.is_alphanumeric("Hello123")))
    print("is_within_range(5, 1, 10): " .. tostring(utils.validation.is_within_range(5, 1, 10)))
    print("is_phone_number('+12345678901'): " .. tostring(utils.validation.is_phone_number("+12345678901")))
    print("is_url('https://www.example.com'): " .. tostring(utils.validation.is_url("https://www.example.com")))
    print("is_date('2023-04-01'): " .. tostring(utils.validation.is_date("2023-04-01")))
    print("is_ip_address('192.168.1.1'): " .. tostring(utils.validation.is_ip_address("192.168.1.1")))
    print("is_server_address('192.168.1.1:30120'): " .. tostring(utils.validation.is_server_address("192.168.1.1:30120")))
    print("is_username('Username123'): " .. tostring(utils.validation.is_username("Username123")))
    print("is_strong_password('Password123!'): " .. tostring(utils.validation.is_strong_password("Password123!")))
    print("is_hex_color('#FF00AA'): " .. tostring(utils.validation.is_hex_color("#FF00AA")))
    print("All tests for Input Validation Utilities complete!")
end, false)
