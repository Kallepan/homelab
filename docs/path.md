# PATH

The `PATH` is an important concept when working on the command line. It's a list
of directories that tell your operating system where to look for programs, so
that you can just write `script` instead of `/home/me/bin/script` or
`C:\Users\Me\bin\script`. But different operating systems have different ways to
add a new directory to it:

## Windows

1. The first step depends which version of Windows you're using:
    * If you're using Windows 8 or 10, press the Windows key, then search for and select "System (Control Panel)".
    * If you're using Windows 7, right click the "Computer" icon on the desktop and click "Properties".
2. Click "Advanced system settings".
3. Click "Environment Variables".
4. Under "System Variables", find the `PATH` variable, select it, and click
   "Edit". If there is no `PATH` variable, click "New".
5. Add your directory to the beginning of the variable value followed by `;` (a
   semicolon). For example, if the value was `C:\Windows\System32`, change it to
   `C:\Users\Me\bin;C:\Windows\System32`.
6. Click "OK".
7. Restart your terminal.

## Mac OS X

1. Open the `.bash_profile` file in your home directory (for example,
   `/Users/your-user-name/.bash_profile`) in a text editor.
2. Add `export PATH="your-dir:$PATH"` to the last line of the file, where
   *your-dir* is the directory you want to add.
3. Save the `.bash_profile` file.
4. Restart your terminal.

## Linux

1. Open the `.bashrc` file in your home directory (for example,
   `/home/your-user-name/.bashrc`) in a text editor.
2. Add `export PATH="your-dir:$PATH"` to the last line of the file, where
   *your-dir* is the directory you want to add.
3. Save the `.bashrc` file.
4. Restart your terminal.
