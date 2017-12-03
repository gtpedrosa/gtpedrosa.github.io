+++
date = "2016-11-10T19:11:44-03:00"
title = "Installing a virtualenv with specific python version"
tags = ["python", "programming", "virtualenv"]
+++

When trying to install the requirements for a course on coursera I found out that my system's python distribution was a bit outdated. Since I did not want to change anything systemwide (and possibily break things) I decided to finally go for a virtual environment.

<!--more-->

Creating a virtual environment (venv) is easier than I thought. A venv shadows your current python packages by creating a standalone environment where you have a python executable, pip and easy\_install. This means you have all the tools to download and manage packages, and they are not installed in the local user system folders. Every package is installed relative to the folder you have created the virtualenv for.

As of the time of this writing, python's latest release was the 2.7.12. If you compile a new version from source, and create a virtual environment afterwards specifying the path relative to the new python installation, you might get the same AssertionError as I did:

~~~
AssertionError: Filename /packages/Python-2.7/Lib/os.py does not start with any of these prefixes: ['/usr/local']
~~~

The work arround to this is to compile python from source with the `prefix` option (thanks to Drachenfels on SO):

~~~ bash
./configure --prefix=/Path/To/Where/I/Want/Python/After/Compilation/
make
make install
~~~
 
This will fix any path issues from the new python executable, if you want to keep the new version in a place other than `/usr/bin/`. Now, to create the virtual environment:

~~~ bash
virtualenv -p /pathToPython/Python-2.7.12/bin/python2.7  venv_name
cd venv_name
source /bin/activate
pip install myProjectPackages
~~~

And you are all set.



 
