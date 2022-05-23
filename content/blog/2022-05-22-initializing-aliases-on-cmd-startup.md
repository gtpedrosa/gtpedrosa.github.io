+++
title = "Initializing aliases on cmd startup"
author = ["Guilherme Pedrosa"]
date = 2022-05-22T21:09:00-03:00
tags = ["windows", "cmd", "registry"]
draft = false
+++

On my [previous post](https://gtpedrosa.github.io/blog/setting-up-a-data-science-local-environment-without-administrative-rights-on-windows/) about setting up a data-science development environment without admin rights on Windows, there is a step where the registry needs to be edited. Recently, I have tried to follow the same instructions I wrote back then without success. It happens that the Command Processor entry cannot simply be found anymore.

In order to make my aliases stored on HOME directory initialize upon cmd startup, I have found the following work around:

```bash
reg add "HKCU\Software\Microsoft\Command Processor" /v AutoRun /t REG_EXPAND_SZ /d "%"USERPROFILE"%\alias.cmd" /f
```

It correctly autoruns the alias on cmd startup, solving the issue. More info on Microsoft’s docs.
