Work-Arounds
============
*mostly pulled from [Josh Kelley's 2018 blog post](https://www.joshkel.com/2018/01/18/symlinks-in-windows/)*
At present, as stated by others, symbolic links created in wsl aren't processed by windows.  This does not, however, go the other direction.  WSL/WSL2 handles symbolic links created in windows just fine.
Cygwin
------
There is a cygwin workaround that already exists detailed in [this answer](https://stackoverflow.com/a/18660841/1228832).  In short, we learn that adding the environment variable `CYGWIN=winsymlinks:nativestrict` instructs cygwin to use windows native symbolic links instead of POSIX.
Msys
----
For MSYS the setting is almost the same except that the environment variable name is MSYS.  It is possible to set the CYGWIN variable in your .bashrc/.bash_profile but for MSYS on must add the variable in windows.
Msys git
--------
Typing `git config --system core.symlinks true` on the console (cmd or pwrshell) will set the value for you.
Git-for-windows
---------------
For git-for-windows the setting is contained the *super-system* configuration file as described in [this answer](https://stackoverflow.com/a/32849199/25507).  One should update the `core.symlinks` option to be `true` in the file found at `\ProgramData\git\config`.

WSL2
----

Given all of those other work-arounds, let's see if we can hammer out a quick one for msys2 users that works until we get a complete solution.  After all, it's been quite a while that this has been an issue.

*Direct cmd.exe hack*
---------------------

Consider this the rapid trial for getting this working on your system.  It's fine if you just need one or two links, but I'm sure if you need more (as most of you will) that you will wish to continue on to the scripted solution below.

*Without any extra options, mklink creates a symbolic link to a file. The below command creates a symbolic, or “soft”, link at Link pointing to the file Target :*

`/mnt/c/Windows/System32/cmd.exe /c mklink Link Target`

*Use /D when you want to create a soft link pointing to a directory. like so:*

`/mnt/c/Windows/System32/cmd.exe /c mklink /D Link Target`

*Use /H when you want to create a hard link pointing to a file:*

`/mnt/c/Windows/System32/cmd.exe /c mklink /H Link Target`

*Use /J to create a hard link pointing to a directory, also known as a directory junction:*

`/mnt/c/Windows/System32/cmd.exe /c mklink /J Link Target`

*Handling multiple files & dirs at once*
----------------------------------------

Now, since nobody is going to want to run commands for a bunch of files or dirs, let's handle them more elegantly.

I have a github project for my portable configs and one-off scripts.  Here is a find command to link all the items in that repo to my current working directory: `find ~/src/poweruser_tools/ -mindepth 1 -maxdepth 1 -exec echo $(which cmd.exe) /c mklink "{}" ./ \;`.
