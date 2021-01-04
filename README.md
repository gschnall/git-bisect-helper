##  Git Bisect Helper
- A simple helper script, for git bisect, to find the commit with a bug faster

![screenshot](./readme_screenshot_1.png?raw=true "git bisect helper")

## Dependencies

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

MIT LicenseCopyright (C) <2020> <Gabe Schnall>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
