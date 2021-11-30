+++
title = "Setting up a Data Science local environment without administrative rights on Windows"
author = ["Guilherme Pedrosa"]
date = 2020-06-07T18:24:00-03:00
tags = ["data", "science", "windows", "R", "Python", "Git", "editors", "IDE"]
draft = false
+++

Installing any program on `C:\Program Files`, Windows default installation folder, requires administrative rights. It is possible, however, to install programs on the `HOME` folder without any special permissions. The default `HOME` path is set to `C:\Users\yourusername\` and can be accessed by typing `%HOME%` on the address bar. I have found this approach makes it possible to have some autonomy from the IT department without compromising security.

Using this approach, the softwares will run just fine without any customization. One caveat, however, is that some set up is needed in order to make them interact with one another properly.

The following list is a personal preference related to the tools used to perform the data science tasks I found easiest to setup without administrative (admin) rights and how to make them work without any problems.


## Softwares {#softwares}

The main softwares I use are listed below:

-   ****Languages:**** I use R mainly for data exploration/prototyping and Python for solution development. Bear in mind, however, that you can get some mileage with R exclusively depending on the need;
-   ****Editors:**** I have installed notepad++, vim, emacs and Sublime Text 3. I end up using notepad++ for quick inspections of files, emacs for orgmode exclusively and Sublime for all my Python needs;
-   ****IDEs:**** Why an IDE if you have a bunch of editors you might ask. Well, I find the experience of using RStudio for data explorations using R very well streamlined. Packaging works, I can do literate programming and weave the code into reports that work as an engineering memorandum and a reference for my future self or present analysis results;
-   ****VCS:**** Git, indispensable in the analysis workflow and necessary to expand the toolbox set by pulling packages;


## Configuration {#configuration}


### Portable Programs {#portable-programs}

[Sublime Editor](https://www.sublimetext.com/3), [Git](https://git-scm.com/download/win), [R](https://cran.r-project.org/bin/windows/base/), [RStudio](https://rstudio.com/products/rstudio/download/) and [Python](https://www.python.org/downloads/windows/) all have portable versions, which do not require any installation. If not, they allow you to proceed with the installation process selecting a folder of your choice, such as `HOME`.

The downfall of this installation process is that none of the above programs will be on the system path, nor they will be available through the command line. Here is where the `aliases.cmd` comes in.


### aliases.cmd {#aliases-dot-cmd}

To make a program available system wide, it's path should be appended to the `PATH` variable. Unfortunately, doing this permanently is also a privileged operation. It is possible however, to append the new paths every time you start a terminal for instance. To accomplish this, you can take the following approach, borrowed from [this SO answer](https://stackoverflow.com/questions/20530996/aliases-in-windows-command-prompt):

1.  Create a .bat or .cmd file with your DOSKEY commands.
2.  Run regedit and go to HKEY\_CURRENT\_USER\Software\Microsoft\Command Processor
3.  Add String Value entry with the name AutoRun and the full path of your .bat/.cmd file.

In my case, I have created a `alias.cmd` file in my `HOME` folder. The file is reproduced below:

```cmd
@echo off

:: Temporary system path at cmd startup

set PATH=%PATH%;

:: Commands

DOSKEY ls=dir /B
DOSKEY npp="C:\Users\yourusername\npp\notepad++.exe"
DOSKEY alias=notepad %USERPROFILE%\alias.cmd
DOSKEY vim="C:\Users\yourusername\Vim\vim81\gvim.exe"
DOSKEY p1=cd "C:\Users\yourusername\p1" ^& "venv\Scripts\activate"
DOSKEY va="venv\Scripts\activate"
DOSKEY vd="venv\Scripts\deactivate"

set curldir="C:\Users\yourusername\curl\bin\curl.exe"
set gitdir="C:\Users\yourusername\PortableGit\cmd"
set jupyterdir="C:\Users\yourusername\appdata\local\programs\python\python37\Scripts"
set subldir="C:\Users\yourusername\Sublime"
set rcdir="C:\Program Files (x86)\Windows Kits\10\bin\10.0.17763.0\x64"
set bashesdir="C:\Users\yourusername\bashes"
set cmakedir="C:\Users\yourusername\cmake\bin"

set pythonpath="C:\Users\yourusername\AppData\Local\Programs\Python\Python37"
set pythonscripts="C:\Users\yourusername\AppData\Local\Programs\Python\Python37\Scripts"
set rdir="C:\Users\yourusername\R\R-3.5.1\bin"
set PATH=%curldir%;%gitdir%;%cmakedir%;%pythonpath%;%pythonscripts%;%subldir%;%rcdir%;%bashesdir%;%rdir%;%PATH%
```

Some interesting points about this configuration:

-   Typing `alias` in the terminal brings me to the file above so I can tweak it easily;
-   Part of my workflow with python relies on using virtual environments. I have a standardized name for my virtual environments which is `venv`. Therefore, I alieased the actiavtion/deactivation from the project root to `va` and `vd`. This works across all my projects;
-   Usual projects received their own aliases, such as the `p1` example;
-   Python, Git, curl and R could are appended to the system path;

Now, either running a new terminal or executing the software, you should feel no difference in usage regardless of how/where the tools were installed.


## Failures {#failures}

This blog post would not be complete if I did not talk about the things i could ****not**** get to work.


### WSL {#wsl}

I have previously used Windows Subsystem for Linux (WSL) with success for personal projects. In fact, I believe that the [setup proposed](https://nickjanetakis.com/blog/a-linux-dev-environment-on-windows-with-wsl-docker-tmux-and-vscode) by Nick Janetakis is great. However, even asking for a privileged user to install and enable the WSL, I could not get it running with my unprivileged user.


### Docker {#docker}

Similarly to what happened to the WSL, I have also tried to make docker available without any success. It seemed that all the changes made by a privileged user did not persist when I tried to use the installed software with my unprivileged credentials.


### Apache airflow {#apache-airflow}

Apache airflow could not be installed without a admin rights.

In fact it should, but I did not have Microsoft Visual C++ Build Tools in my system, as per the error below.

> error: Microsoft Visual C++ 14.0 is required. Get it with "Microsoft Visual C++ Build Tools": <https://visualstudio.microsoft.com/downloads/>

Since it was not a pre requesite for my projects, I have not investigated any further.


### MikTex {#miktex}

I still have not figured out how to properly set MikTex to R's path. Miktex has a portable edition that can be downloaded from [MikTex download page](https://miktex.org/download). As of now, weaving documents to pdf are still unavailale in my system and will require further integration.


## Closing Notes {#closing-notes}

This is a simple, yet useful standard of tools and ways of operating with them. It should be noted:

-   I have not been working with tools for front-end, but did have npm installed recently to make slide decks with [reveal.js](https://revealjs.com/) using the same approach;
-   My analysis are not really considered data-heavy. In the cases where they were more intensive, relying on libraries such as [diskframe](https://diskframe.com/) or caches worked fine;

Let me know if you managed to get WSL, docker or Miktex working, or have a set-up willing to share.