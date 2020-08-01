##  Git Bisect Helper
- A simple helper script for using git bisect to find the first commit with a bug

## Dependencies (You need to install fzf)

The only dependency is fzf 

- MacOs
 - `brew install fzf`
- Other
  - `git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf`
  - `cd ~/.fzf`
  - `./install`

## Install / Download

```
curl https://raw.githubusercontent.com/gschnall/git-bisect-helper/master/git_bisect.sh > git_bisect.sh
```

## Running it

```bash
$ ./git_bisect.sh 
$ sh git_bisect.sh
```

## License

MIT
