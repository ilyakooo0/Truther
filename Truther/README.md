#  Truther

Makes a truth table for the given boolean function


## Usage

```
truther "a * c (+) b"
```

```
a | b | c | F
-------------
0 | 0 | 0 | 0
0 | 0 | 1 | 0
0 | 1 | 0 | 1
0 | 1 | 1 | 1
1 | 0 | 0 | 0
1 | 0 | 1 | 1
1 | 1 | 0 | 1
1 | 1 | 1 | 0
```

## Available functions

- `+`/`or`
- `(+)`/`xor`/`/=`
- `*`/`and`/`&`
- `=>`
- `=/>`
- `<=`
- `</=`
- `o`/`nor`
- `=`/`<=>`
- `|`/`nand`
