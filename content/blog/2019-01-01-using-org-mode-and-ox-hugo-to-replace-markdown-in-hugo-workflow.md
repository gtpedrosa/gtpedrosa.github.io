+++
title = "Using org mode and ox-hugo to replace markdown in hugo workflow"
author = ["Guilherme Pedrosa"]
date = 2019-01-13T13:41:00-02:00
draft = false
+++

I have decided to give org mode blogging a go. Why org mode? The main reasons for this were:

-   Abandon markdown: I always get confused by markdown markup choices. I find myself constantly reaching for [markdown cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet) to find out how to insert a link. "Is it parenthesis or brackets?" gets me every time;
-   Increase familiarity with org mode synthax to use it in my literary programming workflows in the near future (tangle+babel);
-   Reduce friction to create new blog posts using the great [ox-hugo](https://ox-hugo.scripter.co/) by Kaushal Modi.

For anyone trying to do the same, I recommend:

-   [ox-hugo tutorial by Ken Grimes](https://www.kengrimes.com/ox-hugo-tutorial/)
-   [ox-hugo website/manual](https://ox-hugo.scripter.co/)
-   [Some org mode markup notes and comments by Karl Voigt](https://karl-voit.at/2017/09/23/orgmode-as-markup-only/)
-   [Most frequently used org mode markup by Xah](http://ergoemacs.org/emacs/emacs_org_markup.html)

Since I want this post to be self contained for further reference in the near future, I will summarise what I've learned from the references above.


## Installation and .emacs setup {#installation-and-dot-emacs-setup}

> **EDIT Apr 04 2020:** Instructions updated after noticing they failed in brand new system installation

-   Installation with package manager:

<!--listend-->

```emacs-lisp
  M-x package-install RET ox-hugo RET
```

-   Require it in the .emacs file:

<!--listend-->

```org
  (with-eval-after-load 'ox__
    (require 'ox-hugo))
```

-   To take advantage of auto exporting on save I added the following to my .emacs file:

<!--listend-->

```org
  ;; Hugo orgmode exporter
  (require 'org-hugo-auto-export-mode) ;If you want the auto-exporting on file saves
```

-   Enable snippets shortcuts

<!--listend-->

```org
  (require 'org-tempo);Enable snippets expantions (ex: <s+TAB or <q+TAB)
```

-   Now to create a capture template to create new blog postos on the fly:

<!--listend-->

```org
  ;; Populates only the EXPORT_FILE_NAME property in the inserted headline.
  (with-eval-after-load 'org-capture
    (defun org-hugo-new-subtree-post-capture-template ()
      "Returns `org-capture' template string for new Hugo post.
  See `org-capture-templates' for more information."
      (let* ((title (read-from-minibuffer "Post Title: ")) ;Prompt to enter the post title
             (fname (org-hugo-slug title)))
        (mapconcat #'identity
                   `(
                     ,(concat "* TODO " title)
                     ":PROPERTIES:"
                     ,(concat ":EXPORT_FILE_NAME: " (format-time-string "%Y-%m-%d-") fname)
                     ":END:"
                     "%?\n")          ;Place the cursor here finally
                   "\n"))))

  ;; org capture templates
  (setq org-capture-templates
   '(
     ("h"                ;`org-capture' binding + h
                      "Hugo post"
                      entry
                      ;; It is assumed that below file is present in `org-directory'
                      ;; and that it has a "Blog Ideas" heading. It can even be a
                      ;; symlink pointing to the actual location of all-posts.org!
                      (file+olp "/home/guilherme/blog/content-org/posts.org" "blog")
                      (function org-hugo-new-subtree-post-capture-template))
  ))
```

-   Include a _.dir-locals.el_ file in the project root, assuming all org-files are in a _content-org_ directory below root:

<!--listend-->

```org
  (("content-org/"
    . ((org-mode . ((eval . (org-hugo-auto-export-mode)))))))
```

**Note:** everything here so far is in the manual. I only added the current date to the file name being created in the `EXPORT_FILE_NAME:` property to be consistent with my previous naming scheme.


## Org file structure {#org-file-structure}

Ken grimes did a great job explaining how to use one org file to organize a hugo blog. I'll just mention a few things. First of all, Hugo has a contents folder and depending on the theme you use (I use cocoa) it will have

```shell
  tree -d -L 2 ../content
```

```text
../content
├── about
├── blog
├── projects
└── standalone

4 directories
```

I haven't been using ox-hugo in my previous posts, so I already have markdown files that do not have a corresponding org version. However, my posts reside in the blog folder. As an example, a minimal org file used to generate this post would be the following:

```org
  #+hugo_base_dir: /home/guilherme/blog/
   * blog
  :PROPERTIES:
  :EXPORT_HUGO_SECTION: blog
  :END:
   ** TODO Using org mode and ox-hugo to replace markdown in hugo workflow
  :PROPERTIES:
  :EXPORT_FILE_NAME: 2019-01-01-using-org-mode-and-ox-hugo-to-replace-markdown-in-hugo-workflow
  :END:

   * Footnotes
   * COMMENT Local Variables                          :ARCHIVE:
   # Local Variables:
   # org-hugo-auto-export-on-save: t
   # End:
```

The local variable `org-hugo-auto-export-on-save` with the ARCHIVE tag enables hugo auto export to my blog's master org file only.


## Workflow {#workflow}

To create a new blog post I simply issue `C+c C+c + h` and a title for my new post is prompted. Along with it the filename with date are already set by the property in the capture template. Form now on I just write.

To view any changes on my working post:

```bash
  hugo serve -D --navigateToChanged
```

When done with the post, just changing the task from TODO to DONE will create a special property date that will be the post's date published.


## Markup examples {#markup-examples}

I've put together some markup examples that were spread through the sources mentioned in the beggining of the post. These are for quick lookups, where I can find the synthax for features I use the most.

<a id="org7ab8758"></a>

![](/home/gtpedrosa/Projects/blog/hugo-blog/static/img/gnu-unicorn.png)
**Here we refer to [1](#org7ab8758).**

> Everything should be made as simple as possible,
> but not any simpler -- Albert Einstein

```org
  * This Is A Heading
  ** This Is A Sub-Heading
  *** And A Sub-Sub-Heading

  Paragraphs are separated by at least one empty line.

  *bold* /italic/ _underlined_ +strikethrough+ =monospaced= ~code~
  [[http://Karl-Voit.at][Link description]]
  http://Karl-Voit.at → link without description

  : Simple pre-formatted text such as for source code.
  : This also respects the line breaks. *bold* is not bold here.

  - list item
  - another item
    - sub-item
      1. also enumerated
      2. if you like
  - [ ] yet to be done
  - [X] item which is done
```

<a id="code-snippet--hello"></a>
```emacs-lisp
  (message "Hello")
```

<div class="src-block-caption">
  <span class="src-block-number"><a href="#code-snippet--hello">Code Snippet 1</a>:</span>
  Hello
</div>

**Here we refer to [2](#code-snippet--helloagain).**

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque et quam metus. Etiam in iaculis mi, sit amet pretium magna. Donec ut dui mi. Maecenas pharetra sapien nunc, ut mollis enim aliquam quis. Nam at ultricies metus. Nulla tempor augue in vestibulum tristique. Phasellus volutpat pharetra metus quis suscipit. Morbi maximus sem dolor, id accumsan ipsum commodo non.

<a id="code-snippet--helloagain"></a>
```emacs-lisp
  (message "Hello again")
```

<div class="src-block-caption">
  <span class="src-block-number"><a href="#code-snippet--helloagain">Code Snippet 2</a>:</span>
  Hello Again
</div>

**Here we refer to [1](#code-snippet--hello).**
