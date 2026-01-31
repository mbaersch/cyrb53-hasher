___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "cyrb53 Hasher",
  "description": "hash strings using a cyrb53 implementation (standard ascii characters only)",
  "categories": [
    "UTILITY"
  ],
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "dataStr",
    "displayName": "Data String",
    "simpleValueType": true
  },
  {
    "type": "TEXT",
    "name": "seed",
    "displayName": "Seed (optional)",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      },
      {
        "type": "NON_NEGATIVE_NUMBER"
      }
    ],
    "defaultValue": 0
  },
  {
    "type": "CHECKBOX",
    "name": "output64",
    "checkboxText": "64-bit Output",
    "simpleValueType": true,
    "defaultValue": true
  }
]


___SANDBOXED_JS_FOR_SERVER___

//no String.prototype.charCodeAt in Sandbox :(
function charCodeAt(str) {
  const asciiString = ' !"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~';
  const asciiOffset = 32;
  return asciiString.indexOf(str) + asciiOffset;
}

  
//polyfills for other missing String / Math standard methods...
function imul(a, b) {
  var aHi = (a >>> 16) & 65535;
  var aLo = a & 65535;
  var bHi = (b >>> 16) & 65535;
  var bLo = b & 65535;
  return ((aLo * bLo) + (((aHi * bLo + aLo * bHi) << 16) >>> 0) | 0);
}

function padStart(str,targetLength,padString) {
  targetLength = targetLength>>0; 
  padString = padString || ' ';
  if (str.length > targetLength) {
    return str;
  } else {
    targetLength = targetLength-str.length;
    if (targetLength > padString.length) {
      const count = targetLength / padString.length;
      for (let i = 0; i < count; i++) {
        padString += padString;
      }
    }
    return padString.slice(0,targetLength) + str;
  }
}

//cyrb53, adjusted for the limited JavaScript Sandbox capabilites  
//find original function at https://stackoverflow.com/a/52171480
function cyrb53(str, seed, fullOutput) {
  seed = seed || 0;
  let h1 = 3735928559 ^ seed, h2 = 1103547991 ^ seed;
  for (let i = 0, ch; i < str.length; i++) {
    ch = charCodeAt(str[i]);
    h1 = imul(h1 ^ ch, 2654435761);
    h2 = imul(h2 ^ ch, 1597334677);
  }
  h1 = imul(h1 ^ (h1>>>16), 2246822507) ^ imul(h2 ^ (h2>>>13), 3266489909);
  h2 = imul(h2 ^ (h2>>>16), 2246822507) ^ imul(h1 ^ (h1>>>13), 3266489909);
  
  if (fullOutput == true)
    return padStart((h2>>>0).toString(16), 8,'0') + padStart((h1>>>0).toString(16), 8,'0');
  else 
    return 4294967296 * (2097151 & h2) + (h1>>>0);
}

return cyrb53(data.dataStr, data.seed, data.output64);


___TESTS___

scenarios:
- name: check example values from Stack Overflow answer
  code: |-
    let variableResult = runCode({dataStr: 'a', seed: 0, output64: true});
    assertThat(variableResult).isEqualTo('501c2ba782c97901');
    variableResult = runCode({dataStr: 'b', seed: 0, output64: true});
    assertThat(variableResult).isEqualTo('459eda5bc254d2bf');
    variableResult = runCode({dataStr: 'revenge', seed: 0, output64: true});
    assertThat(variableResult).isEqualTo('fbce64cc3b748385');
    variableResult = runCode({dataStr: 'revenue', seed: 0, output64: true});
    assertThat(variableResult).isEqualTo('fb1d85148d13f93a');
    variableResult = runCode({dataStr: 'revenue', seed: 1, output64: true});
    assertThat(variableResult).isEqualTo('76fee5e6598ccd5c');
    variableResult = runCode({dataStr: 'revenue', seed: 2, output64: true});
    assertThat(variableResult).isEqualTo('1f672e2831253862');
    variableResult = runCode({dataStr: 'revenue', seed: 3, output64: true});
    assertThat(variableResult).isEqualTo('2b10de31708e6ab7');
    variableResult = runCode({dataStr: 'ESCP Business School', seed: 0, output64: false});
    assertThat(variableResult).isEqualTo(4069707626304993);
    variableResult = runCode({dataStr: 'ESCP Business School', seed: 0, output64: true});
    assertThat(variableResult).isEqualTo("000e7560a567d5e1");


___NOTES___

Created on 30.12.2021, 12:43:38


