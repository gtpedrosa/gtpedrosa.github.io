+++
title = "Upgrading an outdated Hugo template"
author = ["Guilherme Pedrosa"]
date = 2020-05-10T18:04:00-03:00
draft = false
+++

Recently, I wanted to restart blogging in a new machine. After installing the
latest hugo version at the time and pulling my git repo I soon realized:

1.  My Hugo version in which the blog was built was v0.31, whereas the current one
    was v0.68.1.
2.  The cocoa development was abandonned and no updates were made to cope with
    hugo enhancements

Since I do like this theme and already had a fork of it I decided to try and
upgrade it by myself, even though I have no experience with the go programming
language or web development.

This post is to tell you how I went about it.


## Finding where the errors come from {#finding-where-the-errors-come-from}

First of all, running the dated theme with new hugo raised the following errors:

<a id="org4b9e274"></a>

![](/img/hugo-warnings.png)
**Hugo serve warnings on outdated template**

The first thing you may notice is that there is no mention to what part of the
template is raising the warnings being shown. To overcome this, I grepped the
offending structures and mapped which template files were triggering the
warnings:

<a id="org45ed49f"></a>

![](/img/hugo-warning-lines.png)
**Hugo warning files and lines**

Just in case you are wondering here is a summary of the grep flags used:

-   r or -R is recursive,
-   n is line number, and
-   w stands for match the whole word.

The next step involved fiddling with the source code and learning about each one of the errors.


## Page.RSSLink is deprecated {#page-dot-rsslink-is-deprecated}

I have found some github issues related to the matter, such as [this one.](https://github.com/gohugoio/hugo/issues/4427)
However, what solved my issue was to read the docs [here](https://gohugo.io/templates/rss/) and look how an up to dated
template should handle RSS. Replacing the bit using the _.RSSLink_ construct
with the snipped below solved the issue.

```html
{{ with .OutputFormats.Get "rss" -}}
    {{ printf `<link rel="%s" type="%s" href="%s" title="%s" />` .Rel .MediaType.Type .Permalink $.Site.Title | safeHTML }}
{{ end -}}
```


## Page.URL is deprecated {#page-dot-url-is-deprecated}

This error was easier to tackle. The warning gave a reasonable solution that
worked in my case. By replacing _Page.URL_ with _Params.URL_ everything worked
as expected. Note that there was some trial and error here since there are other
two other possible options according to the warning. I iterated until success.


## Page.UniqueID is deprecated {#page-dot-uniqueid-is-deprecated}

Again the warning suggestion was spot on and replacing _.UniqueID_ with
_.File.UniqueID_ supressed the warning.


## Most recent blog posts not showing on index.html {#most-recent-blog-posts-not-showing-on-index-dot-html}

This was the trickiest to fix. I ended up reading a little bit about [how to
debug hugo templates.](https://gohugo.io/templates/template-debugging/) It so happens that after a couple of iterations printing
some of the variables in the _index.html_ file with the synthax

```html
{{ printf "%#v" .Permalink }}
```

I found out _.Data.Pages_ as not yielding the right ammount of posts.
Using _.Site.RegularPages_ did. I cannot find the exact resource which brought to
my attention the difference between the old and new hugo synthax, however, It is
agreeable that _.Data_ is too generic of a name for this use case.


## Final result {#final-result}

As final result the theme is working without any warnings on hugo v0.68.1.

The changes applied to the theme are summarised by the git diff below. For more
reasonable view just check [my fork of the cocoa-hugo theme.](https://github.com/gtpedrosa/cocoa-hugo-theme)

```shell
cd /home/gtpedrosa/Projects/blog/hugo-blog/themes/cocoa/
git diff c6e7 434d
```

```shell
diff --git a/layouts/_default/list.html b/layouts/_default/list.html
index b2348a1..4490e6c 100644
--- a/layouts/_default/list.html
+++ b/layouts/_default/list.html
@@ -10,7 +10,7 @@
             <nav class="section-items">
                 <ul>
                 {{ range .ByWeight }}
-                    <li><a {{ printf "href=%q" .URL | safeHTMLAttr }}>{{ default .Title .Params.heading }}</a></li>
+                    <li><a {{ printf "href=%q" .Params.url | safeHTMLAttr }}>{{ default .Title .Params.heading }}</a></li>
                 {{ end }}
                 </ul>
             </nav>
diff --git a/layouts/index.html b/layouts/index.html
index be3a722..7d6252d 100644
--- a/layouts/index.html
+++ b/layouts/index.html
@@ -7,12 +7,12 @@
                     {{ .Content }}
                 </div>
             {{ end }}
-            {{ $totalpostscount := len (where .Data.Pages "Section" "blog") }}
+            {{ $totalpostscount := len (where .Site.RegularPages "Section" "==" "blog") }}
             {{ $latestpostscount := .Site.Params.latestpostscount | default $totalpostscount }}
             {{ if gt $latestpostscount 0 }}
                 <div class="page-heading">{{ i18n "latestPosts" }}</div>
                 <ul>
-                    {{ range (first $latestpostscount (where .Data.Pages.ByPublishDate.Reverse "Section" "blog")) }}
+                    {{ range (first $latestpostscount (where .Site.Pages.ByPublishDate.Reverse "Section" "blog")) }}
                         {{ partial "li.html" . }}
                     {{ end }}
                     {{ if gt $totalpostscount $latestpostscount }}
diff --git a/layouts/partials/head_includes.html b/layouts/partials/head_includes.html
index 3c21e39..24723e2 100644
--- a/layouts/partials/head_includes.html
+++ b/layouts/partials/head_includes.html
@@ -51,9 +51,9 @@
 >

 <!-- RSS -->
-{{ if .RSSLink }}
-  <link href="{{ .RSSLink }}" rel="alternate" type="application/rss+xml" title="{{ .Site.Title }}" />
-{{ end }}
+{{ with .OutputFormats.Get "rss" -}}
+    {{ printf `<link rel="%s" type="%s" href="%s" title="%s" />` .Rel .MediaType.Type .Permalink $.Site.Title | safeHTML }}
+{{ end -}}

 <!-- gitalk -->
 {{ if .Site.Params.gitalk }}
diff --git a/layouts/partials/staticman/form-comments.html b/layouts/partials/staticman/form-comments.html
index 91067df..544301c 100644
--- a/layouts/partials/staticman/form-comments.html
+++ b/layouts/partials/staticman/form-comments.html
@@ -1,6 +1,6 @@
 <form method="POST" action="https://api.staticman.net/v2/entry/{{ .Site.Params.staticman.username }}/{{ .Site.Params.staticman.repository }}/{{ .Site.Params.staticman.branch }}/">
     <input type="hidden" name="options[redirect]" value="{{ .Permalink }}#comment-submitted">
-    <input type="hidden" name="options[entryId]" value="{{ .UniqueID }}">
+    <input type="hidden" name="options[entryId]" value="{{ .File.UniqueID }}">
     <input name="fields[name]" type="text" placeholder="Your name">
     <input name="fields[email]" type="email" placeholder="Your email address">
     <textarea name="fields[body]" placeholder="Your message. Feel free to use Markdown." rows="10"></textarea>
diff --git a/layouts/partials/staticman/show-comments.html b/layouts/partials/staticman/show-comments.html
index bba3b5c..d7ff90e 100644
--- a/layouts/partials/staticman/show-comments.html
+++ b/layouts/partials/staticman/show-comments.html
@@ -1,6 +1,6 @@
  {{ $comments := readDir "data/comments" }}
  {{ $.Scratch.Add "hasComments" 0 }}
- {{ $entryId := .UniqueID }}
+ {{ $entryId := .File.UniqueID }}

  {{ range $comments }}
    {{ if eq .Name $entryId }}
```
