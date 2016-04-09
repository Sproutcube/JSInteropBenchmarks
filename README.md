# JS Interop Benchmarks

Performed on a 2013 MBP, 2.8G.

## JSContext

Each operation run 1000 times in measureBlock.

* JS to Swift String Return: 6 microseconds (4% stddev)
* JS to Swift Dictionary/Object Return: 17 microseconds (7% stddev)
* JS calling Swift class method and returning string: 23 microseconds (20% stddev)
* JS calling Swift class method and returning Swift Object: 26 microseconds
* JS calling Swift class method and chaining method call returning string: 34 microseconds
* JS Calling Swift class method and returning array of 1000 dictionaries: 552 microseconds
