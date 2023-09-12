+++
title = "Transfer files between computers using python and lftp"
author = ["Guilherme Pedrosa"]
date = 2023-09-11T22:53:00-03:00
tags = ["linux", "python"]
draft = false
+++

I have found a neat way to transfer single files or whole folders between two computers in the same network.

On one PC, turn it into an HTTP server:

```nil
python3 -m http.server
```

And find its IPV4 address. Use ipconfig (Windows) or ifconfig (Linux).

Finally, using a browser in the other PC, access the server on `http://my_ip:8000`. From there, you can navigate the file system and download single files easily or download whole folders using lftp:

```nil
lftp -c 'mirror --parallel=100 http://my_ip:8000/folder ;exit'
```
