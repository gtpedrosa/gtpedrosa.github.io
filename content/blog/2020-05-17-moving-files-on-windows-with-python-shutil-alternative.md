+++
title = "Moving files on windows with python: shutil alternative"
author = ["Guilherme Pedrosa"]
date = 2020-05-17T11:20:00-03:00
draft = false
+++

Transfering data from my HD across a network, I have hit a bottleneck: the file
transfer speed was dramatically slow. In fact, the transfer took more time to finish than it took to generate the files. It was an unnaceptable situation due HD constraints.

It turns out that the file being copied to another partition is virtually
chunked, and each of them copied sequentialy. The more chunks the slower the
transfer is, while larger chunks increase memory usage [[1]​](https://superuser.com/questions/558292/how-does-copy-and-paste-for-large-files-work). Iniatially I thought
I had to change the shutil module itself to make it work, so I avoided this
path [[2]​](https://stackoverflow.com/questions/21799210/python-copy-larger-file-too-slow).

The solution I came up, however, was switching to Windows Robust File Copy utility, or `robocopy`. It has some perks, including showing the status of the
transfer on the command line, which was handy at this particular time. The
solution looks like the following:

```python
import time
import os

source = '\\source\\folder'
target = '\\target\\folder'

while True:
    for filename in os.listdir(source):
        os.system('Robocopy "%s" "%s" "%s" /MOV' %
                  (source, target, filename))
    time.sleep(300)
```

The python usage was only necessary to periodically move incoming files, keeping HD usage controlled.

> ****Attention:**** Do not use `/MOVE` unless you want the folder structure to be
>   moved as well. `/MOV` will keep the folder structure intact, moving only the
>   files targeted.

Later I have found out you can manage to adjust buffer size directly
without modifying the source code directly [[3]​](https://blogs.blumetech.com/blumetechs-tech-blog/2011/05/faster-python-file-copy.html). I will keep that in mind for the
next time.
