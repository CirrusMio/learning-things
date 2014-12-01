---
layout: page
title: CoffeeScript Style Guide
permalink: /style-guides/coffeescript/
---

- Use 2 spaces for indentation, no tabs.
- End each file with a blank line.
- Wrap lines at 80 characters.
- Remove trailing whitespace.
- Space after a comma but not before:

    ```coffeescript
    # Yes
    api_app.factory "ApiService", ($http) ->

    # No
    api_app.factory "ApiService" ,($http) ->

- Write constants in all caps, `LIKE_THIS`.
- Use `if`/`else`, not `unless`/`else`.
- Use list comprehensions when they fit on a single line:

    ```coffeescript
    # Yes
    result = (item.name for item in array)

    # No
    results = []
    for item in array
      results.push item.name

- Use comprehensions for filtering when they fit on a single line:

    ```coffeescript
    result = (item for item in array when item.name is "test")

- Use `@property` not `this.property`.

## See also:

- [polarmobile CoffeeScript Style Guide](https://github.com/polarmobile/coffeescript-style-guide)
