# Push error devcontainer

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
