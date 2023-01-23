+++
title = "Getting started with Neovim: Notes to self"
author = ["Guilherme Pedrosa"]
date = 2023-01-22T21:36:00-03:00
tags = ["neovim", "python", "dofiles"]
draft = false
+++

This week I wanted to up my python development \`fu\` by focusing on my tooling. My main criterium was to move fast between definitions and files to understand a new code base. For a while, I have been learning about vim from the ThePrimeagen Youtube channel. His latest video on [getting started with Neovim](https://www.youtube.com/watch?v=w7i4amO_zaE&t=817s) is simply an excellent resource.

So I took the time to implement each step following the video. In the process, not only I have learned a great deal about how to set up Neovim with Lua, but also what it is like to be _fluent in vim_, and I liked it. My new setup, which is a simplified version of the one in the video is now in [dot files repository](https://github.com/gtpedrosa/dotfiles).

Some of the shortcuts that I do not want to forget (not categorized):

-   gd: Jump to definition
-   Ctrl-o: Returns cursor to the previous position (e.g. before the jump to definition)
-   '': Similar to Ctrl-o but returns to the line (not position)
-   K: Shows help for the object under the cursor
-   pf: Project find, works with files
-   ps: Project search, works with code/text
-   pv: Opens Netrw navigator
-   f: finds a character in the current line after the cursor
-   a: Inserts after the cursor
-   J: Brings line below to current line
-   zz: Centralize the cursor  in the middle of the screen
-   Ctrl+e: Opens harpoon dialog
-   Spc+a: Marks file to harpoon
-   Ctrl+h: Switch to harpoon position 1
-   Ctrl+t: Switch to harpoon position 2

    At this time, I still have not replaced my development workflow, with Jupyter-lab, with the Neovim setup. Since I work mainly with data, it is necessary to find the best way to bend the new tooling to my REPL workflow. However, getting acquainted with the new code base has been a delight with the new tooling so far.
