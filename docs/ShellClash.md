# ShellClash

Official website:

- [GitHub](https://github.com/juewuy/ShellCrash)
- [Blog](https://juewuy.github.io/)

## Install ShellClash

[Install in Linux](https://github.com/juewuy/ShellCrash/blob/dev/README_CN.md#%E5%9C%A8%E7%BA%BF%E5%AE%89%E8%A3%85)

## Customize Rules

Create `/etc/ShellCrash/yamls/rules.yaml` to customize rules.

**Sample to bypass local network: \*.home**

```yaml
- DOMAIN-SUFFIX,*.home,DIRECT
```