+++
title = "Generating documentation of Matlab scripts automatically with mkdocs"
author = ["Guilherme"]
date = 2019-01-20T23:06:00-03:00
draft = false
+++

Something that always called my attention is how much more documented and even appealing to newcomers projects in python or R are if compared to Matlab in general. One exception is [MatConvNet](https://github.com/vlfeat/matconvnet), a library that implements convolutional neural networks (CNNs) in Matlab and has a good looking and helpful documentation.

The documentation stands out as it is produced with [MkDocs](https://www.mkdocs.org/), a static site generator based on markdown specific for project documentation. Something very different from Matlab's default html help template. But why bother adding another layer of complexity writing markdown files for the documentation? Why not use the source code itself? The authors of MatConvNet created a parser capable of extracting the comments of the functions in mfiles and auto generate the markdown necessary for MkDocs. The python scripts `matdoc.py` and `matdocparser.py` do exactly that. I must acknowledge it is copywrited material (Copyright (c) 2014-16 The MatConvNet Team) and not made by me.

For the remaining of this post consider a simple project composed of two mfiles: `addme.m` and `subtractme.m` which do exactly what you would expect from them, add and subtract two numbers. Also consider a `index.md` and a `mkdocs.yml` file, the bare minimum for a MkDocs documentation. This is the files setup and they can be downloaded from my github [here](https://github.com/gtpedrosa/matlab-mkdocs).

```shell
tree -L 2 ~/Sandbox/docs
```

```text
/home/guilherme/Sandbox/docs
├── addme.m
├── COPYING
├── COPYING~
├── docs
│   ├── index.md
│   └── mfiles
├── makefile
├── matdocparser.py
├── matdocparser.pyc
├── matdoc.py
├── mkdocs.yml
└── subtractme.m

2 directories, 10 files
```

The following make file is responsible for the automation of the pocess:

```shell
PYTHON = python2
MKDOCS = mkdocs
SRC = $(wildcard *.m)
TAR = $(SRC:.m=.md)

mfiledir = docs/mfiles

$(info SRC is $(SRC))
$(info TAR is $(TAR))
$(info mfiledir is $(mfiledir))

.PHONY: all clean

all: $(TAR)

%.md: %.m matdoc.py matdocparser.py
	$(info $(@))
	$(info $(@D))
	mkdir -p $(mfiledir)
	$(PYTHON) ./matdoc.py "$(<)" > "$(mfiledir)/$(@)"

doc-serve: mkdocs.yml
	$(MKDOCS) serve

clean:
	rm -f $(TAR)
	rm -rf $(mfiledir)
```

Issuing

```shell
make all
make doc-serve
```

This is the expected output:

```text
SRC is subtractme.m addme.m
TAR is subtractme.md addme.md
mfiledir is docs/mfiles
subtractme.md
.
mkdir -p docs/mfiles
python2 ./matdoc.py "subtractme.m" > "docs/mfiles/subtractme.md"
addme.md
.
mkdir -p docs/mfiles
python2 ./matdoc.py "addme.m" > "docs/mfiles/addme.md"
SRC is subtractme.m addme.m
TAR is subtractme.md addme.md
mfiledir is docs/mfiles

INFO    -  Building documentation...
INFO    -  Cleaning site directory
[I 190120 22:44:13 server:283] Serving on http://127.0.0.1:8000
[I 190120 22:44:13 handlers:60] Start watching changes
[I 190120 22:44:13 handlers:62] Start detecting changes
[I 190120 22:44:55 handlers:133] Browser Connected: http://localhost:8000/#project-layout
[I 190120 22:44:55 handlers:133] Browser Connected: http://127.0.0.1:8000/

```

And finally, the end result, a home page based on the `index.md` file:

<a id="org7383841"></a>

{{< figure src="/img/mkdocshome.png" caption="Figure 1: MkDocs documentation generated automatically for a matlab project" >}}

And more importantly, automatic documentation for each function in a specific menu called `M-files`:

<a id="orgaa2430d"></a>

{{< figure src="/img/mkdocsfunction.png" caption="Figure 2: Documentation for each mfile" >}}