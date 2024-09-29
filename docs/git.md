# Git

## Add multiple remotes

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

## Push error devcontainer

Git push may fail with the following error message:

```plaintext
git@github.com: Permission denied (publickey).
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.
```

A possible solution is running the following on the **host** terminal:

```bash
ssh-add -l
# The agent has no identities.

ssh-add ~/.ssh/github_key # or any other github ssh key
# Identity added: /home/user/.ssh/github_key (user@host)
```

Then try to push again.
