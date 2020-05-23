# wolfram-alpha-cli
> A console tool for the Wolfram|Alpha API written in Nim

## Build
- Install [Nim](https://nim-lang.org/install.html)
- `nim c -d:release wa.nim` to compile the file
- Execute the compiled file with `./wa <query>` , or add it to your PATH and simply run `wa <query>`

## Configuration
The usage of the Wolfram|Alpha API requires an AppID.

To get one, follow this link http://products.wolframalpha.com/api/, click on "Get API Access" and create an account.
By default free accounts get 2000 API calls per month.

When you have an AppID, put it into a file `.wolfram_appid` in your home directory.



## Example
```
$ wa answer to the question of life, the universe and everything
Input interpretation:
        Answer to the Ultimate Question of Life, the Universe, and Everything
Result:
        42
        (according to the book The Hitchhiker's Guide to the Galaxy, by Douglas Adams)
```
