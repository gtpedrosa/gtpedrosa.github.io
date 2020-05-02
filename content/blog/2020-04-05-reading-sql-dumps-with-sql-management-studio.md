+++
title = "Reading SQL Dumps with SQL Server management Studio"
author = ["Guilherme Pedrosa"]
date = 2020-04-12T10:58:00-03:00
tags = ["sql", "Databases"]
draft = false
+++

This post is about how to inspect the content of SQL database (_.mdf_ and _.ldf_ files). The answer is to attach these files to an existing SQL server instance, instead of opening them directly with a tool such as SQL Management Studio. This was not clear time until I stumbled upon [this video.](https://www.youtube.com/watch?v=rhIr9Qf-oHw)


## Steps {#steps}

1.  Keep a SQL Server instance running in the background;
2.  Fire up SQL Management studio and connect to this instance by providing _.\SQLEXPRESS_ in the "Server name" field;
3.  Right click "Database" and attach the mdf file. The ldf is automatically included;


## Attention points {#attention-points}

To check #1 spin up _SQL Configuration Manager_ and look for ****SQL Server
(SQLEXPRESS)**** instance. It should be already running by default, as shown in
Figure 1.

<a id="orgf66bd4a"></a>

{{< figure src="/img/sqlexpress.png" caption="Figure 1: SQL Express running instance" >}}

As for #2 make sure to login using the system credentials as shown in Figure 2.

<a id="orgd5a6918"></a>

{{< figure src="/img/sqlserver.png" caption="Figure 2: SQL Server login" >}}

As for #3, if you are not admin the mdf file needs to be stored somewhere in the
 Public user profile so the SQLExpress instance is able to locate it.
