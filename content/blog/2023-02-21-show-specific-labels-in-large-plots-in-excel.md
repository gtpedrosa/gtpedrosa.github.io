+++
title = "Show specific labels in large plots in Excel"
author = ["Guilherme Pedrosa"]
date = 2023-02-21T08:12:00-03:00
tags = ["excel", "plots"]
draft = false
+++

Suppose you need to highlight specific labels in a large bar or column chart in Excel. Here is a two-step way to accomplish the task.

With the COUNT.IF formula, you can detect if the current label belongs to a list of specific ones. The neat trick, however, is in the number formatting used to show the labels of interest exclusively:

```nil
[=0]"";0%
```

The formatting makes the cell show empty when zero (default output of the COUNT.IF) and a percentage otherwise (COUNT.IF\*CELL output).
