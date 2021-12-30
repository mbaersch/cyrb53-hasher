# cyrb53-hasher
Custom Variable Template for Server-Side Google Tag Manager to hash any string using cyrb53. This variable needs a string as input and calculates a hash based on the function on Stack Overflow described at https://stackoverflow.com/a/52171480. 

**Note**: As the GTM JS Sandbox does not support all methods that are uses in the orignal function, the template uses some polyfills and has to make compromises regarding the supported set of characters. That means, that all parts consisting of unknown characters besides the standard ASCII set will lead to the same result. If a string can not avoid including characters that are not part of the following string, the distribution will suffer - and lead to a result that does not match the outcome of the original function. If you need to compare hashes on the receiving side, an adjusted cyrb53 version similar to this variable implementation must be used. 

## Supported Characters
```
const asciiString = ' !"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~';
```
## Parameters

| Parameter      | Description |
| :---        |    :----:   |
| Data String | the string to be hashed. If a salt is used, it has to be already added to the value | 
| Seed      | alters the hash similar to the original function       |
| 64-bit Output   | Changes the hash format. Uncheck to get the result of the initial example function. With the option checked, the function uses a alternative hash format from the comments  |

## Tests

The tests included in the template check the sample results from the answer on Stack Overflow. Quote: 
```
"501c2ba782c97901" = cyrb53("a")
"459eda5bc254d2bf" = cyrb53("b")
"fbce64cc3b748385" = cyrb53("revenge")
"fb1d85148d13f93a" = cyrb53("revenue")
```

You can optionally supply a seed (unsigned integer, 32-bit max) for alternate streams of the same input:

```
"76fee5e6598ccd5c" = cyrb53("revenue", 1)
"1f672e2831253862" = cyrb53("revenue", 2)
"2b10de31708e6ab7" = cyrb53("revenue", 3)
```
