Use GitHub Copilot in Shell

***Test on Ubuntu24.04***

1. Install GitHub CLI

```shell
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

apt update

apt install gh

gh auth login
```

2. Install GitHub Copilot

refer to 
- [Installing GitHub Copilot in the CLI](https://docs.github.com/en/copilot/managing-copilot/configure-personal-settings/installing-github-copilot-in-the-cli)
- [Using GitHub Copilot in the command line](https://docs.github.com/en/copilot/using-github-copilot/using-github-copilot-in-the-command-line)

```shell
gh extension install github/gh-copilot

# explain
gh copilot explain "sudo apt-get"

# suggest
gh copilot suggest "Undo the last commit"
```

