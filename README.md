Package: alinex-async
=================================================

[![Build Status] (https://travis-ci.org/alinex/node-async.svg?branch=master)](https://travis-ci.org/alinex/node-async)
[![Dependency Status] (https://gemnasium.com/alinex/node-async.png)](https://gemnasium.com/alinex/node-async)

This package will extend the async module with more useful functions. The package
will help in structuring in asynchronous programming.

- easy functions
- makes code more readable

It is one of the modules of the [Alinex Universe](http://alinex.github.io/node-alinex)
following the code standards defined there.



Install
-------------------------------------------------

To use this module you should install it as any other node modules:

    > npm install alinex-async --save

[![NPM](https://nodei.co/npm/alinex-async.png?downloads=true&stars=true)](https://nodei.co/npm/alinex-async/)


Usage
-------------------------------------------------

Now it can be used like the normal [async](https://github.com/caolan/async)
module:

    var async = require 'alinex-async'


Run function once
-------------------------------------------------

The once-part contains of different implementations which decide what will
happen on the second call.

### once.skip

A function may be wrapped with the once method:

    var fn = async.once.skip(function(a, b, cb) {
      return cb(null, a + b);
    });

And now you can call the function as normal but on the second call it will
return imediately without running the code:

    fn(2, 3, function(err, x) {
      // x will now be 5
      fn(2, 3, function(err, x) {
        // err will now be set
      });
    });

You may use this helper in case of initialization (wait) there a specific
method have to run once before any other call can succeed. Or then events
are involved and an error event will trigger the callback and the end event will
do the same.

### once.throw

throw an error if it is called a second time

### once.atime

only run it once at a time but response all calls with the result

### once.wait

the second call will get return with the same result


License
-------------------------------------------------

Copyright 2015 Alexander Schilling

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

>  <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
