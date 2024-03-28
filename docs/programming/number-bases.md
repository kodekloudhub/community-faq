# Number Bases - Binary, Octal, Hex

Computers are binary systems. They're powered by electricity driving transistor gates. Therefore they only understand two states:

1. Power flowing: `on`, `true`, `1`
1. No power: `off`, `false`, `0`

Thus computers count in 2's. This is known as the Binary system or Base 2. All values internally in the computer's CPU and memory are binary.

You are all familiar with how we count normally in multiples of 10. This is called Base 10 and your elementary maths will have taught you how to do artihmetic with 1's, 10's, 100's etc. with simple sums like

```text
   HTU
   276
 +  34
   ---
   310
```

We have the digits 0 to 9, then we carry to the tens column and start over. This is powers of 10.

## Binary

Now in binary there are only 2 values, 0 and 1. Therefore in binary math we have a 1's column, then a 2's column, then 4's, 8's, 16's etc. Binary is frequently used as literals in programming when we want to perform 'bitwise' operations such as logic [truth tables](https://en.wikipedia.org/wiki/Truth_table).

So how do we represent `35` in binary? This is done by successive divisions by powers of 2, starting with the highest power of 2 that will divide into the number, and working down taking remainders and applying the same technique on the remainders till we reach zero.

So starting with `35`, the highest power of 2 that will divide into it is `2^5` or `32`

```text
35 / 32 = 1 r 3
```

So we have a `1` in the 32's column.

Moving on, we cannot divide the remainder 3 by 16, 8 or 4 therefore we have 0 in those three columns. We can however divide it by 2

```text
3 / 2 = 1 r 1
```

So there is 1 in the 2's column and we have the remainder 1 which is 1 in the 1's column.

Result: `100011` - This is the binary representation of `35`

To write binary literals in code, we have special syntax:

Python:
```python
a = 35
b = 0b100011
print(a == b)

True
```

Golang:
```go
package main

import (
	"fmt"
)

func main() {
	a := 35
	b := 0b100011
	fmt.Println(a == b)
}
```
> Output
`true`

Obviously if we are talking about large decimal numbers e.g. the largest single integer that a CPU register can hold which is `18,446,744,073,709,551,615` then its binary representation is ridiculously long!<br/>
`1111 1111 1111 1111 1111 1111 1111 1111 1111 1111 1111 1111 1111 1111 1111 1111`

GPU registers (on your graphics card) are twice or even 4 times as wide, leading to binary numbers that are off the page!

This leads us to other number bases that are based on powers of 2 which makes it easier to write numbers that are based on binary in shorter forms.

## Octal

Octal is a Base 8 scheme, which means each digit column is a power of 8, meaning that it will hold the digits 0-7 then carry to the next column. Thus our columns are 1's, 8's, 64's, 512's.

So the conversion is as per binary, but this time start with the highest power of 8 that will divide into the number

```text
35 / 8 = 4 r 3
```

So we have 4 in the 8's column.

No power of 8 will divide into 3 therefore that leaves 3 in the 1's column

Result: `43` - This is the octal representation of `35`

To write binary literals in code, we have special syntax:

Python:
```python
a = 35
b = 0o43
print(a == b)

True
```

Golang:
```go
package main

import (
	"fmt"
)

func main() {
	a := 35
	b := 0o43
	fmt.Println(a == b)
}
```
> Output
`true`

Taking our huge number, the octal version is<br/>`1 777 777 777 777 777 777 777`

Writing the hex octal digits alongside the binary version, you can see how one converts to the other

```text
1 111 111 111 111 111 111 111 111 111 111 111 111 111 111 111 111 111 111 111 111 111
1   7   7   7   7   7   7   7   7   7   7   7   7   7   7   7   7   7   7   7   7   7
```

Count the `7`s

It is infrequently used in programming, but it's most common use is with the Linux `chmod` command where the 3 permissions you can set are expressed as a number:

| Permission | Octal representation |
|------------|----------------------|
| `---`        | 0 |
| `--x`        | 1 |
| `-w-`        | 2 |
| `-wx`        | 3 |
| `r--`        | 4 |
| `r-x`        | 5 |
| `rw-`        | 6 |
| `rwx`        | 7 |

So to set the permission `rwxr-xr-x` on a file, it would be `chmod 755 <file>`

# Hexadecimal

This is the most frequently used scheme when we want to represent something as binary, for instance memory page sizes, values for CPU registers, disk allocation units etc. Remember these are all binary stores, and it's much easier to represent numbers like 4KiB, 1MiB (not their base 10 equivalents) as hex.

Hex is a Base 16 scheme, which means each digit column is a power of 16, meaning that it will hold the digits 0-what? then carry to the next column. Thus our columns are 1's, 16's, 256's, 4096's.

`0-what?` - eh? We run out of numbers after 9, so what do we use to represent the numbers `10` thru `15`? We take letters of the alphabet `a` thru `f`, thus `a` is 10, `b` is 11 thru to `f` is 15. Hex is case insensitive so you can equally use capitals.

So the conversion is as per binary, but this time start with the highest power of 16 that will divide into the number. Let's use 62 this time so you can see the letters in action

```text
62 / 16 = 1 r 14
```

So we have 1 in the 16's column.

No power of 16 will divide into 14 therefore that leaves 14 in the 1's column, which is represented by the letter `e`

Result: `1e` - This is the hex representation of `62`

To write hex literals in code, we have special syntax:

Python:
```python
a = 62
b = 0x1e
print(a == b)

True
```

Golang:
```go
package main

import (
	"fmt"
)

func main() {
	a := 62
	b := 0x1e
	fmt.Println(a == b)
}
```
> Output
`true`

Again, the big number, the hex version is `FFFF FFFF FFFF FFFF`

Writing the hex digits alongside the binary version, you can see how one converts to the other

```text
1111 1111 1111 1111 1111 1111 1111 1111 1111 1111 1111 1111 1111 1111 1111 1111
   F    F    F    F    F    F    F    F    F    F    F    F    F    F    F    F
```

Count the `F`s

When buying a computer, it's memory size is usually quoted in GB, but is actually GiB as a memory chip is binary and must have a power of 2 amount of storage. Therefore your 16GB laptop has 2^30 bytes of storage = `1,073,741,824` bytes, which in Hex is `0x40000000` - a nice round looking number!

See https://simple.wikipedia.org/wiki/Gibibyte

