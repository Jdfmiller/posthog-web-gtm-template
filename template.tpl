___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "PostHog Web",
  "brand": {
    "id": "brand_dummy",
    "displayName": "",
    "thumbnail": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADwAAAAoCAMAAACVZWnNAAAABGdBTUEAALGPC/xhBQAAAAFzUkdCAK7OHOkAAAAJcEhZcwAACxMAAAsTAQCanBgAAAA5UExURUdwTPm9KvZOAAAAAAAAAAAAAB1K//ZOAB1K//q+KgAAAAAAAPm+KgAAAB1K/x1K//VOAPm9KwAAAEJGd1QAAAAPdFJOUwBgaNSgfWh/gH9QIG+339QREekAAADxSURBVEjH7dXdCoMwDIbhqNXW6tbE+7/Y1f58OFBbdyAMzFFOHlTygkTP/NUMQ97aNm9zU4mdM2lj1mkTGWtx1gwttdpBM7TUagfN0FKrHTRDS6120AwttdpAa+jxZq2hR+hyYUkztEBXFBY1Qws00VQszESctUBTv/TFwkzESQs0qeVMO2iGFugVn2gHzdD5Tk0T8LHGlQ2urDdXDvhQFxqJ+EedcFHvFpbxvi4UtuLX60gXCvO4I5/Kvi4U5rEisuHN1XS9sMXaLn24stPVwrbT7UQyoLAWhc0obDtf+J1wLsz/NlJh4bfRnz75mXvmAzWXK+KJCyBXAAAAAElFTkSuQmCC"
  },
  "description": "Places the PostHog web snippet (https://posthog.com/docs/libraries/js) via GTM.\n\nAllows for the configuration of \nAPI key \u0026 Region",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "projectToken",
    "simpleValueType": true,
    "displayName": "Project API key",
    "notSetText": "API key required",
    "help": "Place your API key here, found in  \"Settings \u003e General \u003e Project ID\"",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "defaultsDate",
    "displayName": "Defaults Date",
    "simpleValueType": true,
    "defaultValue": "2025-05-24"
  },
  {
    "type": "RADIO",
    "name": "ukeuHost",
    "displayName": "Project Region",
    "radioItems": [
      {
        "value": "https://us.i.posthog.com",
        "displayValue": "us"
      },
      {
        "value": "https://eu.i.posthog.com",
        "displayValue": "eu"
      }
    ],
    "simpleValueType": true,
    "help": "Found in \"Settings \u003e General \u003e Project ID \u003e Project region\". Alternatively, review your URL subdomain for posthog - it should be \"eu\" or \"us\".",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const injectScript = require('injectScript');
const setInWindow = require('setInWindow');
const callInWindow = require('callInWindow');
const copyFromWindow = require('copyFromWindow');
const log = require('logToConsole');
const token = data.projectToken;
const apiHost = data.ukeuHost;
const defaults = '2025-05-24';  
const personProfiles = 'identified_only'; 

if (!token || !apiHost) {
  log('PostHog Template Error: Missing token or apiHost');
  data.gtmOnFailure();
  return;
}

if (copyFromWindow('posthog.__SV')) {
  log('PostHog already initialized');
  data.gtmOnSuccess();
  return;
}

setInWindow('posthog', [], false);
setInWindow('posthog._i', [], false);
setInWindow('posthog.__SV', 1, true);

const stubMethods = [
  "init", "capture", "identify", "alias", "people", "reset", "set_config", "get_distinct_id",
  "onFeatureFlags", "isFeatureEnabled", "getFeatureFlag", "getFeatureFlagPayload"
];

let posthog = copyFromWindow('posthog') || [];

stubMethods.forEach(function (method) {
  posthog[method] = function () {
    callInWindow('posthog.push', [method].concat([].slice.call(arguments)));
  };
});

posthog.people = posthog.people || {};
setInWindow('posthog', posthog, true);
setInWindow('posthog.people', {}, false);

callInWindow('posthog._i.push', [
  token,
  {
    api_host: apiHost,
    defaults: defaults,
    person_profiles: personProfiles,
    debug: true 
  },
  'posthog' 
]);

let scriptUrl;

if (typeof apiHost === 'string' && apiHost.indexOf('.i.posthog.com') !== -1) {
  scriptUrl = apiHost.replace('.i.posthog.com', '-assets.i.posthog.com') + '/static/array.js';
} else if (typeof apiHost === 'string') {
  scriptUrl = apiHost + '/static/array.js';
} else {
  log('PostHog Template Error: apiHost is not a string');
  data.gtmOnFailure();
  return;
}

injectScript(scriptUrl, function () {
  log('PostHog library loaded');
  data.gtmOnSuccess();
}, function () {
  log('PostHog library failed to load');
  data.gtmOnFailure();
});


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "posthog"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "posthog._i"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "posthog.push"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "posthog.init"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "posthog.__SV"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "posthog.people"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "posthog._i.push"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://*.posthog.com/"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 17/06/2025, 23:02:03


