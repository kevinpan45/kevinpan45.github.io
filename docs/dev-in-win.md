## Windows Terminal

### lrzsz Alternative

[lrzsz](https://github.com/microsoft/terminal/issues/1602) is not supported in Windows Terminal. The alternative is to use [trzsz](https://github.com/trzsz/trzsz).

1. Install trzsz on Server

https://trzsz.github.io/go

2. Install trzsz on Windows Terminal

https://trzsz.github.io/ssh

3. Use trzsz

use `tssh` to remote host

```bash
# execute then select file to upload
trz
# specify file path to download
tsz <file path>
```