+++
title = "Offline python documentation with Zeal and doc2dash"
author = ["Guilherme Pedrosa"]
date = 2022-09-13T23:35:00-03:00
tags = ["linux", "python", "documentation", "solar", "pvlib"]
draft = false
+++

While working on a python project today, the internet connection went down. For a while, I couldn't reference some API documentation online. This got me thinking: could I have them all offline? Later on (with connection!), I have found the answer: an offline documentation tool called Zeal.

If the project you are working on is popular, there are already docsets available for download. This will make the documentation for a given package accessible in the blink of an eye! However (and more likely) docsets won't be available. One alternative is to use doc2dash to generate them from the project documentation.

Using the excellent pvlib package as an example:

```bash
pip install pvlib[doc]
pip install doc2dash
git clone https://github.com/pvlib/pvlib-python.git
cd pvlib-python/docs/sphinx
make html
doc2dash -A ./build/html
```

In Windows, I had some trouble with the **-A** flag which led me to manually move the docset to Zeal. Aside from this, I was pretty satisfied with the result and how fast I could reach the API reference without the internet.
