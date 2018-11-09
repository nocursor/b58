# Base Fifty Eight

Base Fifty Eight (B58) is an Elixir library for transparently encoding and decoding Base58 and Base58 checked binaries.

The following alphabets are fully supported for standard and checked encoding and decoding:

* BTC
* Flickr 
* Ripple

If by some unholy magic, an additional alphabet is required, please leave an issue and it can be easily added.

## Features

* Base58 and Base58Check encode/decode for all supported alphabets
    * BTC, Flickr, Ripple
* Support for Base58Check encoding and decoding both versioned and unversioned data
    * Version byte may be specified explicitly, extracted, or inferred
    * Checksum calculation per Base58Check spec using sha-256 double hash
* Proper handling for encoding and decoding leading zeroes
    * Data is not lost or corrupted
    * No strange behaviors or surprises when adding new alphabets    
* Binary in, Binary out clean interface
* Transparent encoding and decoding for all alphabets and types of encoding
    * You will always be able to reverse encoding with decoding, including zero bytes
* Explicit handling for versioned and unversioned binaries when dealing with Base58Check
    * Encoding or Decode a binary with or without the version bytes included
* Test coverage
* Consistent functional interface that easily supports piping
* Consistent design with Elixir core `Base` module
* Glorious documentation

Additionally, the following miscellaneous design-related features are present:

* No external dependencies
* Compile-time generated matching and optimizations for speed
* Attention to binary optimization
* Easy to add new alphabets with a single compile-time update
* Designed for additional encoding/decoding options should feature requests or needs arise
* Pragmatic attention to ease-of-use
    * Rather than having a combinatorial explosion for the number of alphabets, all alphabets share the same functional interface
    * Adding new alphabets does not place burden on programmers
    * Performance still maintained without resorting to bad decisions that impact encoding and decoding

## Usage

Base58 Encode a Binary (default bitcoin/IPFS alphabet):

```elixir
B58.encode58("Happy trees happily encode")
"3DYrnueGqPGpJ2tCbbkATC71LBK1kRGm9g9z"

# default for all alphabet options is always bitcoin, but we can specify it too
B58.encode58("Happy trees happily encode", alphabet: :btc)
"3DYrnueGqPGpJ2tCbbkATC71LBK1kRGm9g9z"
```

Base58 Encode a Binary using the Flickr alphabet:

```elixir
B58.encode58("Happy trees happily encode", alphabet: :flickr)
"3dxRMUDgQogPi2TcAAKasc71kbj1KqgL9F9Z"
```

Base58 Encode a Binary using the Ripple alphabet:

```elixir
B58.encode58("Happy trees happily encode", alphabet: :ripple)
"sDYi8ueGqPGFJptUbbkwTUfrLBKrkRGm9g9z"
```

Base58 Decode our original Base58 binary encoded with bitcoin:

```elixir
B58.decode58!("3DYrnueGqPGpJ2tCbbkATC71LBK1kRGm9g9z")
"Happy trees happily encode"
```

Base58 Decode our original Base58 binary encoded with bitcoin, but with error handling:

```elixir
B58.decode58("3DYrnueGqPGpJ2tCbbkATC71LBK1kRGm9g9z")
{:ok, "Happy trees happily encode"}

# fails if the encoded string is invalid in some way
# lets add a 0 at the end to break it since it is not part of the bitcoin alphabet
B58.decode58("3DYrnueGqPGpJ2tCbbkATC71LBK1kRGm9g9z0", alphabet: :btc)           
{:error, "non-alphabet digit found: \"0\" (byte 48)"}
```

Base58Check encoding works in a similar way to Base58 for all functions, but requires a version byte:

```elixir
B58.encode58_check!("Why is Jack always so Hungry", 0)
"16tCsFCTp3ADeU8WsCt36HFYwg3kiBKtBXUBmU6KAQBsA"

B58.encode58_check!("Why is Jack always so Hungry", 0, alphabet: :btc)
"16tCsFCTp3ADeU8WsCt36HFYwg3kiBKtBXUBmU6KAQBsA"
```

Base58Check takes the same alphabets too:

```elixir
B58.encode58_check!("Why is Jack always so Hungry", 0, alphabet: :ripple)
"1atU1EUTFswDe73W1UtsaHEYAgsk5BKtBX7Bm7aKwQB1w"

B58.encode58_check!("Why is Jack always so Hungry", 0, alphabet: :flickr)
"16TcSfcsP3adDt8vScT36hfxWF3KHbjTbwtbLt6japbSa"
```

Base58Check can use version bytes a few ways:

```elixir
B58.encode58_check!("Chip Clip sounds less cool in other languages", "m", alphabet: :btc)   
"2M5paPVxJK1G77Dm9GLXfyXmHsB8L32U2NDy12GfYxrg181WQzkx52nDnc9BMcuahPEJA"

B58.encode58_check!("Chip Clip sounds less cool in other languages", ?m, alphabet: :btc)  
"2M5paPVxJK1G77Dm9GLXfyXmHsB8L32U2NDy12GfYxrg181WQzkx52nDnc9BMcuahPEJA"

B58.encode58_check!("Chip Clip sounds less cool in other languages", 42, alphabet: :btc)
"XCkzrRJxzqYE9tFeaWPsKeY4m1Fxm34CEe4repib7cLiGFjM7Dzf6ubruT68QZiUE5hC"

# we can also try to pass some bad version info that violates the Base58Check version constraints
B58.encode58_check!("Chip Clip sounds less cool in other languages", 42424242, alphabet: :btc)
# raise ** (ArgumentError) version must be a single byte binary or unsigned integer, data must be a binary.

# And we can use our trust error handling version too
B58.encode58_check("Chip Clip sounds less cool in other languages", 42424242)                 
{:error,
 "version must be a single byte binary or unsigned integer, data must be a binary."}
```

Base58Check can be encoded with a version byte already present.
All calls with an explicit version byte are prefixed with `version` so there is no confusion and not error-prone:

```elixir
# notice the "m" byte in front
B58.version_encode58_check!("mChip Clip sounds less cool in other languages")      
"2M5paPVxJK1G77Dm9GLXfyXmHsB8L32U2NDy12GfYxrg181WQzkx52nDnc9BMcuahPEJA"

# same but specifying the alphabet too explicitly
B58.version_encode58_check!("mChip Clip sounds less cool in other languages", alphabet: :btc)      
"2M5paPVxJK1G77Dm9GLXfyXmHsB8L32U2NDy12GfYxrg181WQzkx52nDnc9BMcuahPEJA"

# of course we can also construct a binary too ourselves
B58.version_encode58_check!(<<42, "Chip Clip sounds less cool in other languages">>, alphabet: :btc)
"XCkzrRJxzqYE9tFeaWPsKeY4m1Fxm34CEe4repib7cLiGFjM7Dzf6ubruT68QZiUE5hC"
```

Likewise, Base58Check can be decoded much like Base58.
The big difference is how the version byte is returned.

```elixir
B58.decode58_check!("2M5paPVxJK1G77Dm9GLXfyXmHsB8L32U2NDy12GfYxrg181WQzkx52nDnc9BMcuahPEJA")                                                                       
{"Chip Clip sounds less cool in other languages", "m"}

B58.decode58_check!("2M5paPVxJK1G77Dm9GLXfyXmHsB8L32U2NDy12GfYxrg181WQzkx52nDnc9BMcuahPEJA", alphabet: :btc)                                                                       
{"Chip Clip sounds less cool in other languages", "m"}
```

The `version` prefixed calls can be used to include the version byte:

```elixir
B58.version_decode58_check!("2M5paPVxJK1G77Dm9GLXfyXmHsB8L32U2NDy12GfYxrg181WQzkx52nDnc9BMcuahPEJA")
"mChip Clip sounds less cool in other languages"

# This is quite nice as we can use it for piping too, and as you can see it keeps things fully transparent
# We can also pipe in the alphabet easily wherever
 B58.version_decode58_check!("2M5paPVxJK1G77Dm9GLXfyXmHsB8L32U2NDy12GfYxrg181WQzkx52nDnc9BMcuahPEJA") 
 |> B58.version_encode58_check!() 
 |> B58.version_decode58_check!(alphabet: :btc)
"mChip Clip sounds less cool in other languages"
```

Base58Check includes a checksum. Let's tamper with our encoded bytes to make it fail:

```elixir
B58.encode58_check!("Bank Details Poorly Handled by Bitcoin Startup", 42, alphabet: :btc)   
"3JJAcmj3WdhuKTNRAHx1Yjg4XorKHxPoAA8uokfDz9DGFw456jADxtLp6DEP5zTKsM3zq9"

# Let's change that J in second position to a D because we are an evil hacker who hates J
B58.decode58_check!("3DJAcmj3WdhuKTNRAHx1Yjg4XorKHxPoAA8uokfDz9DGFw456jADxtLp6DEP5zTKsM3zq9")
# raises ** (ArgumentError) Invalid checksum.

# Fortunately, we can also use our trusty error/reason tuples too
# Notice the lack of a `!`
B58.decode58_check("3DJAcmj3WdhuKTNRAHx1Yjg4XorKHxPoAA8uokfDz9DGFw456jADxtLp6DEP5zTKsM3zq9") 
{:error, "Invalid checksum."}

# The `version` prefixed functions behave the same
B58.version_decode58_check("3DJAcmj3WdhuKTNRAHx1Yjg4XorKHxPoAA8uokfDz9DGFw456jADxtLp6DEP5zTKsM3zq9")
{:error, "Invalid checksum."}
```

If we are truly lazy or want some error checking, we can use this library to version our binaries too:

```elixir
B58.version_binary("Bad Startup Idea", 255)                                  
<<255, 66, 97, 100, 32, 83, 116, 97, 114, 116, 117, 112, 32, 73, 100, 101, 97>>

B58.version_binary("Bad Startup Idea", "X") 
"XBad Startup Idea"
```

Let's suppose we want to work with something more fancy like Bitcoin (I accept your wealth if you have any to spare).
We can work our way through the example in the [Bitcoin wiki](https://en.bitcoin.it/wiki/Technical_background_of_version_1_Bitcoin_addresses) like so:

```elixir
# Suppose we have a RIPEMD-160 hashed public key like f54a5851e9372b87810a8e60cdd2e7cfd80b6e31
# You can do the previous steps with the erlang `crypto` module if you wish, but it's out of scope here
# Let's version it with zero for the BTC network, then encode it. 
# As sane humans, we do this if starting from such a string:
Base.decode16!("f54a5851e9372b87810a8e60cdd2e7cfd80b6e31", case: :lower) |>  B58.encode58_check!(0)                 
"1PMycacnJaSqwwJqjawXBErnLsZ7RkXUAs"

# We could also do this if we had it as an integer like so
# Notice the hex syntax for Elixir. Be careful doing this when working with leading zeroes though as `:binary.encode_unsigned/1` will use the smallest representation.
0xf54a5851e9372b87810a8e60cdd2e7cfd80b6e31 |> :binary.encode_unsigned() |>  B58.encode58_check!(0) 
"1PMycacnJaSqwwJqjawXBErnLsZ7RkXUAs"

# DO NOT DO THIS. 
# I am quite positive someone will file an issue after doing this, thus I warn you here for later posterity.
# Suppose we are unintelligent people. 
# This could never happen, but StackOverflow and other examples in the wild whisper to me
# Notice how the result is completely wrong. Why? We're encoding a hex string, which is not a plain binary.
B58.encode58_check!("f54a5851e9372b87810a8e60cdd2e7cfd80b6e31", 0)
"1aES43oGwSz1ve4QREaEbvpnkqjWbohSsRPM6whcwAA8eQ8efC7oieTtucMiN"

# DO NOT DO THIS
# Likewise, someone will inevitably do this despite warnings
# Notice the leading zero in the source data, and the resulting corrupted data due to the lack of a leading zero
0x0f54a5851e9372b87810a8e60cdd2e7cfd80b6e31 |> :binary.encode_unsigned() |>  B58.version_encode58_check!() 
"PMycacnJaSqwwJqjawXBErnLsZ7N9KgRw"

# Instead, do this
versioned_binary = Base.decode16!("f54a5851e9372b87810a8e60cdd2e7cfd80b6e31", case: :lower) |> B58.version_binary(0)
# Do a bunch of other stuff in between, for whatever twisted reason, finally doing this
B58.version_encode58_check!(versioned_binary)
"1PMycacnJaSqwwJqjawXBErnLsZ7RkXUAs"

# You could also do this, but you might as well use `encode58_check/3` and pass a zero for the version.
Base.decode16!("f54a5851e9372b87810a8e60cdd2e7cfd80b6e31", case: :lower) |> B58.version_binary(0) |> B58.version_encode58_check!()
"1PMycacnJaSqwwJqjawXBErnLsZ7RkXUAs"
```

Finally, suppose you have decoded some data and are wondering why it doesn't look your friendly internet example. 
The problem is often format related, for example perhaps the final answer was in hex. We always keep things in plain Elixir binaries (UTF-8)

```elixir
# Given some address like this, we get this.
B58.decode58!("16UjcYNBG9GTK4uq2f7yYEbuifqCzoLMGS")
<<0, 60, 23, 110, 101, 155, 234, 15, 41, 163, 233, 191, 120, 128, 193, 18, 177,
  179, 27, 77, 200, 38, 38, 129, 135>>

# That doesn't look like what uncle crypto told me I should get. Why?
B58.decode58!("16UjcYNBG9GTK4uq2f7yYEbuifqCzoLMGS") |> Base.encode16(case: :lower)
# Much better
"003c176e659bea0f29a3e9bf7880c112b1b31b4dc826268187"
```

Please pay attention to the following at all times to avoid mistakes and self-induced pain:

* Know your source data encoding. This is usually UTF-8, Latin-1, Base16, Base32, or Base64 these days
* Convert your source data to a universal input format, using the Elixir `Base` module and `decode` functions to decode it typically.
* Use the correct alphabet for encoding and decoding. You cannot encode in one alphabet and decode in another properly.
* Know your intended destination format when checking your results. If your result is another format, again typically use the Elixir `Base` module and `encode` functions to encode it.
* Pay attention to your source format when using integers. You will lose leading zeroes if you rely on anything that tries to convert to the smallest representation, such as `:binary.encode_unsigned/2`
* Decide up front whether you will pass version or unversioned data. Use the `version` prefixed functions for dealing with cases where you want things to include a version by default.

See the [API]([https://hexdocs.pm/basefiftyeight](https://hexdocs.pm/basefiftyeight)) docs for more examples.

## Installation

Base Fifty Eight is available via [Hex](https://hex.pm/packages/basefiftyeight). The package can be installed by adding `basefiftyeight` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:basefiftyeight, "~> 0.1.0"}
  ]
end
```

API Documentation can be found at [https://hexdocs.pm/basefiftyeight](https://hexdocs.pm/basefiftyeight).

## Why

There are several Elixir Base58 libraries as well as implementations buried in Bitcoin, IPFS, and other technologies that use Base58. I reviewed many of these libraries, Benchmarked them, and tested them. No, I will not name names.

Among the many issues across implementations and languages I consistently identified included:

* Conversions of characters and codes that were O(n) or worse
* Lack of support for 0-prefixed binaries or incorrect handling
    * Leading zeroes cause bugs in alternative alphabets if added to many implementations with naive assumptions about decoding
* Weird assumptions about input and output formats that do not match real-world use-cases
* Unnecessary binary allocations
* Unoptimized binary handling
    * Compiling with `ERL_COMPILER_OPTIONS=bin_opt_info` listed additional issues in some cases
* Limited alphabet support
    * I require the ability to support multiple with easy extensibility
    * I do not want call overhead passing in an alphabet that must be parsed at runtime
* Unable to round-trip encoding and decoding, i.e. bugs    
* Lack of or incorrect Base58 check encoding, including failure to round-trip
* Obtuse or inconsistent APIs that worked with types that add overhead or don't make sense for fast encoding/decoding
* NIF dependencies - I want a clean VM for things that can be done in Elixir, not to mention some of these approaches were actually slower
* General performance issues
    * Caused by binary handling, concatenation, abuse of Enum/List (find, find_index, at, etc.) on binaries, failure to leverage TCO, etc.
* Overflow issues
    * Typically caused by using built-in pow function
* Incorrect conversions
    * Integers becoming floats, for example as a result of not using integer division
* Many libraries only implement one of encoding or decoding, I need both ways
* Input and output ambiguity
    * Lack of clarity and documentation regarding if the expectation is a hex encoded string, a utf-8 binary string, or something else
    * Some libraries encode one way and decode another, creating further confusion
    * Some libraries try to be "smart" and try/fail with hex encoding, which adds unnecessary overhead
    * Base58Check libraries conflate regular binaries with versioned binaries or do not specify which the library is accepting

Rather than trying to resolve all these issues via pull requests and possibly asking authors to further extract code, I decided to create a clean implementation that is closer aligned to the existing `Base` module in Elixir's core.

## Goals

* Use best practices handling binaries and large numbers
* Avoid extra memory allocations and overhead when possible and within reason
* Consistent performance behavior for long and short binaries
* Avoid external dependencies
* Keep API as consistent as possible with existing Elixir core `Base` module
* Minimize runtime pattern-matching overhead for encoding and decoding, especially with different alphabets
    * Avoid making code overly generic at the expense of runtime performance, instead look to compile-time solutions
* Ensure adding new alphabets is reasonably painless
* Create functions with documentation
    * Avoid generating functions that can't easily be documented without compile-time annoyances such as extra loops for macro fragments to please the doc gods
* Be pragmatic
    * Accept some sugar trade-offs where benchmarking shows negligible performance impacts    

## Issues

Please see the [FAQ](docs/FAQ.md) in the `docs` folder before filing an issue. Further, there is a discussion of common issues and concerns there.