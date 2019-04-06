+++
title = "Using httr with JSON API's"
author = ["Guilherme"]
date = 2019-03-24T11:35:00-03:00
tags = ["R", "APIs"]
draft = false
+++

It is incredbly easy to make R interact with external API's. I've found [the httr vignette](https://cran.r-project.org/web/packages/httr/vignettes/api-packages.html) to be a great resource on how to make a wrapper to interact with them. However I've stumbled in one quirk that is worth mentioning.

While creating a body to a POST request message, encoded with json, I verified that my requests were being turned down by the server. The issue was related  to a behavior of the `jsonlite` package, one of httr's dependencies which uses  `auto_unbox=TRUE` by default. This isn't an issue _per se_ but for length one vector jsonlite returned:

```R
cat(jsonlite:::toJSON(list(message = "my string"),auto_unbox=T))
```

```text
{"message":"my string"}
```

Whereas the API requested a **boxed** response from length one vectors, such the one you get without the `auto_unbox=TRUE` option

```R
cat(jsonlite:::toJSON(list(message = "my string")))
```

```text
{"message":["my string"]}
```

Reading [this github issue](https://github.com/r-lib/httr/issues/159) might give a more in depth explanation.

This led me to rabbit holes such as forking `httr` and recompiling with `auto_unbox=FALSE` option, which I did. But not without breaking other requests which truly needed to be unboxed.

The solution was simpler than I thought and makes use of the function `AsIs` from the base package. It can be called with the `I(x)` synthax and changes the class of an object indicating it should be treated _as is_. What this does is to prevent the `auto_unbox` behavior on certain fields where this is undesirable, such as in the following example:

```R
cat(jsonlite:::toJSON(list(message = "my string",mymessage = I("My other string")),auto_unbox=T))
```

```text
{"message":"my string","mymessage":["My other string"]}
```

This approach not only did not break anything but also made my requests compatible with the server boxed length one vectors specification as required.