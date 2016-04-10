# JS Interop Benchmarks

Performed on a 2013 MBP, 2.8G.

## JSContext

Each operation run 1000 times in measureBlock.

* JS to Swift
	* String Return: 6 microseconds (4% stddev)
	* Dictionary/Object Return: 17 microseconds (7% stddev)
* JS calling Swift
	* closure: 15 microseconds (7% stddev)
	* class method
		* with no args: 13 microseconds (4% stddev)
			* returning array of 1000 dictionaries: 514 microseconds (2% stddev)
			* throwing exception: 23 microseconds (6% stddev)
		* with 1 arg
			* returning string: 16 microseconds (20% stddev)
			* returning Swift Object: 20 microseconds (4% stddev)
			* class method and chaining method call returning string: 23 microseconds (5% stddev)
		* with 2 args and returning string: 19 microseconds (4% stddev)

