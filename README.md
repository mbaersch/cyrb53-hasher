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

