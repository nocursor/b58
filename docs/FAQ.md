# FAQ

There are a lot of common issues I have noticed between Base58 libraries. I'm listing a few here, please read these to save yourself headaches and wasting time opening non-issues.

## Trimming

The C++ implementation of Base58 found in Bitcoin trims an input string. I believe that you should control your input string. Moreover, forcing extra trimming logic into every encode or decode I think is a mistake when it adds a small, but still noticeable overhead when comparing languages like C++ or Rust to Elixir.

If you find you're getting the incorrect results, maybe you forgot to trim the leading part of your string.

## Hex Strings

As mentioned in these docs, this library expects a binary string. If your string has been previously hex encoded, you should decode it first use `Base.decode16!/1`. Alternatively, if you control your code, another option is to use `:binary.encode_unsigned/1` and write your hex string using hex notation, ex `0xff |> :binary.encode_unsigned()`

## Other Types of Strings

Again, same thing follows. A string that was once "hello" is a binary in Elixir. If it was encoded using a method such as Base32, it will still be a binary, but it is no longer the same binary as "hello". You can easily prove this by iterating the bytes, or doing something as simple as "to_charlist()" and looking at the data.

## Results that Don't Match Examples

Once again, encoding is primarily the issue. This library takes the stance of using a single representation for encoding and decoding. Many other libraries will show you an example and not explain the result is Base16, Base32, or some other encoding. If in doubt, try use the `Base` module to encode or decode accordingly between formats.

## Will You Support Dynamic/Arbitrary Alphabets?

Only if you can make a compelling case with an accompanying design that would not break the existing one. I am not aware of any real use-cases for this. Dynamic alphabets are simply not fast enough for my use-cases in Elixir at runtime, which is why all supported alphabets have compile time character encoding support. Lookups on such alphabets are typically going to be slow. Moreover, adding such alphabets would require changes to the public interface of this library or some extra options wrangling and branching I want to avoid.

I am however very open to adding new alphabets if there are others in wide-use.  

## Are you interested in Bitcoin, IPFS, Crypto Currencies, or Blockchains

No.

If you want to pay me money to be interested, I am always interested in being payed to create things as long as they are ethical, legal, and moral.

I created this library because I wish to use it for various purposes unrelated to the above that would benefit from Base58 encoding.

## What other usages are there for Base58/Base58Check encoding outside IPFS, Crypto Currencies, and Blockchain?

* Clear encoding without ambiguous characters. 
* See the Base58 reasons in the original Bitcoin source. They are not unique to Bitcoin usage.
* URL Shorteners
* Gopher and other protocols with limits on URL-like constructs
    * Some older protocols and technologies have character limits
    * There is someone using Base58 to shorten Gopher URLs for a [proxy](https://gopher.floodgap.com/gopher/)
* Base58Check is useful for cases when you want a version and checksum
    * This is good for eliminating some of the nasty edge-cases in other encodings
* Projects such as [Multibase](https://github.com/multiformats/multibase) require Base58
    * Anything that wants to support lots of `BaseXX` encodings will inevitably need Base58
    
## Why Shouldn't I Include Some Characters in my custom Base58 alphabet?

* Many of these characters pose problems for selecting text with the built-in facilities in an OS
* Humans commonly mistake "0" for "O" and other issues
* Putting a "0" creates ambiguity for the case of leading zeroes, breaking the leading "1" conversion of Base58
* Other people have thought more about alphabets than you

## Drawbacks of Base58 and Base58Check?

* Slower than many other methods due to the following
    * SHA-256 double hash for Base58Check
    * Version and checksum binary concatenation for Base58Check
    * Div and Mod operations for both
        * CRC + tables is an approach that can be used to reduce this overhead, but is not necessarily a benefit or easily done in certain languages without even more overhead
* Can't handle zeroes in alphabet, but by design if you are obeying the original intentions. It's possible to work around this but requires edge handling for those alphabets.
* Additional dependency on crypto functionality if using Base58Check
* Other encodings may compress better or produce shorter strings if size is a concern for you


## How do I convert between Base58/Base58Check alphabets?

If you want to convert between a Base58 string encoded with the Bitcoin alphabet to the Ripple alphabet for example, then you have a few options:

* Decode the string using this library, then re-encode it. Simple, easy, always works, can go between formats.
* Roll a conversion function yourself by hand. I don't recommend this as it's really not worth it.

I do not really feel it is a good idea to add lots of functions in the format of `x_to_y` and `y_to_x` and `y_to_z`. It would be possible to pass in keywords instead with a single conversion function, but I think how to handle this is best left to the consumer and outside the scope of a library.

## Why Bitcoin, Ripple, and Flickr alphabets?

These alphabets are very common and in real-world usage.

## Can you add the IPFS alphabet?

There is not reason to do this as it uses the same alphabet as Bitcoin. I have seen libraries that add additional function or duplicate alphabets to make a distinction. This is unnecessary overhead and cognitive load. Moreover, if IPFS changes alphabets, it has bigger problems.

## Why did you name this library Base Fifty Eight?

The other names were taken. Top-level namespacing doesn't seem to be enough of a "thing" in Elixir. Don't blame me.
