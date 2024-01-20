# How to add multiple remotes to a git repository


```bash
# add initial remote (skip if already done)
git remote add <remote-name> <remote-url>

# add additional remotes
git remote set-url --add --push <remote-name> <remote-url-1>
git remote set-url --add --push <remote-name> <remote-url-2>
# ...

# verify (prints all remotes)
git remote -v

# push to all remotes
git push --all
# or
git push --all <remote-name>
```