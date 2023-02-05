+++
title = "Python development workflow with Neovim and Jupyter-lab"
author = ["Guilherme Pedrosa"]
date = 2023-02-05T07:49:00-03:00
tags = ["neovim", "python", "jupyter"]
draft = false
+++

I want to expand on the previous post [Getting started with nvim](https://gtpedrosa.github.io/blog/getting-started-with-neovim-notes-to-self/) touching upon the jupyter-lab integration. I am still unpleased with the current solution, but the following trick addresses a couple of issues.

Jupyter-lab comes with an IPython interpreter, which in turn has an [auto-reload extension](https://ipython.org/ipython-doc/3/config/extensions/autoreload.html). It can be enabled easily as:

```nil
%load_ext autoreload
%autoreload 2
```

The magic command set to "2" reloads every module before any code is executed. In practice, this allows code edition in Neovim and REPL-like execution in jupyter-lab. Best of both worlds.

However, there are caveats. Pain points to solve include copy-pasting between editor and interpreter, and modifications to allow some of these snippets to be run as scripts. This could probably be solved using the [jupyter-vim package](https://github.com/jupyter-vim/jupyter-vim). Unfortunately, I could not make it work with my project\`s virtual environment.

The next steps involve translating the following vim script to lua:

```nil
" Always use the same virtualenv for vim, regardless of what Python
" environment is loaded in the shell from which vim is launched
let g:vim_virtualenv_path = '/path/to/my/new/vim_virtualenv'
if exists('g:vim_virtualenv_path')
    pythonx import os; import vim
    pythonx activate_this = os.path.join(vim.eval('g:vim_virtualenv_path'), 'bin/activate_this.py')
    pythonx with open(activate_this) as f: exec(f.read(), {'__file__': activate_this})
endif
```

and including "+y" as "Y" remap in _remap.lua_ file just in case.

So far, the trade-offs have had a net positive impact.
