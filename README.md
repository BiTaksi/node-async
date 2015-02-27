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

    async = require 'alinex-async'

Now you may use one of the following methods.


Collections
-------------------------------------------------

### each
### eachLimit
### eachSeries
### map
### mapLimit
### mapSeries
### filter
### reject


Control flow
-------------------------------------------------

### series
### parallel
### parallelLimit
### whilst
### doWhilst
### until
### doUntil
### forever
### waterfall
### applyEach
### applyEachSeries
### queue
### priorityQueue
### retry
### times
###timesSeries


Function wrapper
-------------------------------------------------

### once

The second and later calls will return with the same result:

      fn = async.once (cb) ->
        time = process.hrtime()
        setTimeout ->
          cb null, time[1]
        , 1000

Use this to make some initializations which only have to run once but neither
function may start because it is not done:

      async.parallel [ fn, fn ], (err, results) ->
        // same as with `once.atime` it will come here exactly after the
        // first call finished because the second one will get the
        // result the same time
        // results here will be the same integer, twice
        fn (err, result) ->
          // and this call will return imediately with the previous result

### onceSkip

A function may be wrapped with the once method:

    fn = async.onceSkip (a, b, cb) -> cb null, a + b

And now you can call the function as normal but on the second call it will
return imediately without running the code:

    fn 2, 3, (err, x) ->
      // x will now be 5
      fn 2, 9, (err, x) ->
        // err will now be set on the second call

You may use this helper in case of initialization (wait) there a specific
method have to run once before any other call can succeed. Or then events
are involved and an error event will trigger the callback and the end event will
do the same.

### onceThrow

Throw an error if it is called a second time:

    fn = async.onceThrow (a, b, cb) -> cb null, a + b

If you call this method multiple times it will throw an exception:

    fn 2, 3, (err, x) ->
      // x will now be 5
      fn 2, 9, (err, x) ->
        // will neither get there because an exception is thrown above

### onceTtime

Only run it once at a time but response all calls with the result:

    fn = async.onceTime (cb) ->
      time = process.hrtime()
      setTimeout ->
        cb null, time[1]
      , 1000

And now you may call it multiple times but it will not run more than once
simultaneously. But all simultaneous calls will get the same result.

    async.parallel [ fn, fn ], (err, results) ->
      // will come here exactly after the first call finished (because the
      // second will do so the same time)
      // results here will be the same integer, twice



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