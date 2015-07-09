Package: alinex-async
=================================================

[![Build Status](https://travis-ci.org/alinex/node-async.svg?branch=master)](https://travis-ci.org/alinex/node-async)
[![Coverage Status](https://coveralls.io/repos/alinex/node-async/badge.svg)](https://coveralls.io/r/alinex/node-async)
[![Dependency Status](https://gemnasium.com/alinex/node-async.png)](https://gemnasium.com/alinex/node-async)

This package will extend the async module with more useful functions. The package
will help in structuring in asynchronous programming.

- easy functions
- makes code more readable
- helps against the callback hell

This is not a complete new module but more an extension to the
[async](https://github.com/caolan/async) library by caolan. I decided to
wrap it instead of fork it to let the development of both parts be more independent.
So I don't need to update this library to get bugfixes of the core.

The changes to the core async are:

- added once... methods
- added mapOf... methods

> It is one of the modules of the [Alinex Universe](http://alinex.github.io/code.html)
> following the code standards defined in the [General Docs](http://alinex.github.io/node-alinex).


Install
-------------------------------------------------

[![NPM](https://nodei.co/npm/alinex-async.png?downloads=true&downloadRank=true&stars=true)
 ![Downloads](https://nodei.co/npm-dl/alinex-async.png?months=9&height=3)
](https://www.npmjs.com/package/alinex-async)

The easiest way is to let npm add the module directly to your modules
(from within you node modules directory):

``` sh
npm install alinex-async --save
```

And update it to the latest version later:

``` sh
npm update alinex-async --save
```

Always have a look at the latest [changes](Changelog.md).


Usage
-------------------------------------------------

Now it can be used like the normal [async](https://github.com/caolan/async)
module:

``` coffee
async = require 'alinex-async'
```

Now you may use one of the following methods. All relevant functions are
documented whether they belong to this module directly or to the wrapped
async class.


Collections
-------------------------------------------------

### each

Applies the function parallel to each element of array:

``` coffee
async.each [1..5], (v, cb) ->
  # do something with element `v`
  cb()
, (err) ->
  # come here after all elements are processed or one element failed
  # maybe check for errors
```

It will immediately skip all runs if any one sends an error back and calls the
resulting function with the error first occurred.

### eachLimit

Also run processing of each element in parallel but limit the maximum parallel
runs to prevent overload. If the maximum number of parallel runs is reached the
rest will wait till any run finishes.

``` coffee
# set num to the number of parallel runs
async.eachLimit [1..5], num, (v, cb) ->
  # do something with element `v`
  cb()
, (err) ->
  # come here after all elements are processed or one element failed
  # maybe check for errors
```

### eachSeries

The same as above but do each element one after the other.

``` coffee
# set num to the number of parallel runs
async.eachSeries [1..5], (v, cb) ->
  # do something with element `v`
  cb()
, (err) ->
  # come here after all elements are processed or one element failed
  # maybe check for errors
```

If one run will return an error all further elements won'T be processed.

### forEachOf

Like [each](#each), except that it iterates over objects, and passes the key as
the second argument to the iterator.

``` coffee
async.forEachOf obj, (v, k, cb) ->
  # do something with element `k: v`
  cb()
, (err) ->
  # come here after all elements are processed or one element failed
  # maybe check for errors
```

It will immediately skip all runs if any one sends an error back and calls the
resulting function with the error first occurred.

### forEachOfLimit

Also run processing of forEachOf element in parallel but limit the maximum parallel
runs to prevent overload. If the maximum number of parallel runs is reached the
rest will wait till any run finishes.

``` coffee
# set num to the number of parallel runs
async.forEachOfLimit obj, num, (v, k, cb) ->
  # do something with element `k: v`
  cb()
, (err) ->
  # come here after all elements are processed or one element failed
  # maybe check for errors
```

### forEachOfSeries

The same as above but do forEachOf element one after the other.

``` coffee
# set num to the number of parallel runs
async.forEachOfSeries obj, (v, k, cb) ->
  # do something with element `k: v`
  cb()
, (err) ->
  # come here after all elements are processed or one element failed
  # maybe check for errors
```

If one run will return an error all further elements won'T be processed.

### map

Applies the function parallel to each element of array like each but will return
an array of the results:

``` coffee
async.map [1..5], (v, cb) ->
  # do something with element `v`
  cb null, v + 1
, (err, results) ->
  # come here after all elements are processed or one element failed
  # if no failure occurred the results array will have:
  # [2..6] in this example
```

It will immediately skip all runs if any one sends an error back and calls the
resulting function with the error first occurred.

### mapLimit

Like with map this will give the same results but only run a maximum of limited
parallel calls. If the maximum number of parallel runs is reached the
rest will wait till any run finishes.

``` coffee
# set num to the number of parallel runs
async.mapLimit [1..5], num, (v, cb) ->
  # do something with element `v`
  cb null, v + 1
, (err) ->
  # come here after all elements are processed or one element failed
  # if no failure occurred the results array will have:
  # [2..6] in this example
```

### mapSeries

And this method will run all calls each after the other one in series. But also
the results array will be the same in the end.

``` coffee
async.mapSeries [1..5], (v, cb) ->
  # do something with element `v`
  cb null, v + 1
, (err) ->
  # come here after all elements are processed or one element failed
  # if no failure occurred the results array will have:
  # [2..6] in this example
```

### mapOf

Like [map](#map), except that it iterates over objects, and passes the key as
the second argument to the iterator.

``` coffee
obj = {one:1, two:2, three:3}
async.mapOf obj, (v, k, cb) ->
  # do something with element `k: v`
  cb null, v + 1
, (err, result) ->
  # come here after all elements are processed or one element failed
  # if no failure occurred the result object will have:
  # {one:2, two:3, three:4} in this example
```

It will immediately skip all runs if any one sends an error back and calls the
resulting function with the error first occurred.

### mapOfLimit

Like with map this will give the same results but only run a maximum of limited
parallel calls. If the maximum number of parallel runs is reached the
rest will wait till any run finishes.

``` coffee
# set num to the number of parallel runs
obj = {one:1, two:2, three:3}
async.mapOfLimit obj, num, (v, k, cb) ->
  # do something with element `k: v`
  cb null, v + 1
, (err, result) ->
  # come here after all elements are processed or one element failed
  # if no failure occurred the result object will have:
  # {one:2, two:3, three:4} in this example
```

### mapOfSeries

And this method will run all calls each after the other one in series. But also
the results array will be the same in the end.

``` coffee
obj = {one:1, two:2, three:3}
async.mapOfSeries obj, (v, k, cb) ->
  # do something with element `k: v`
  cb null, v + 1
, (err, result) ->
  # come here after all elements are processed or one element failed
  # if no failure occurred the result object will have:
  # {one:2, two:3, three:4} in this example
```

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
### timesSeries


Function wrapper
-------------------------------------------------

The following functions are used to wrap functions to give them more functionality.
You will get a resulting function which can be called any time.

In all of the following methods you may give an optional context to use as first
parameter. So to call it from class do so like:

``` coffee
class = Test
  init: async.once this, (cb) ->
    # method...
    cb null, @status
```

That allows your function to access class members and methods. Keep in mind to use
`=>` if you use sub functions.

If you use it in `module.exports` then do it as follows:

``` coffee
module.exports =
  anyMethod: (cb) ->
  # and so on

module.exports.init = async.once module.exports, (cb) ->
  # method...
  @anyMethod cb
```

Like you see above you have to declare this method separately so that the `async.once`
method can access the now already defined module.exports object.

### once

The second and later calls will return with the same result:

``` coffee
fn = async.once (cb) ->
  time = process.hrtime()
  setTimeout ->
    cb null, time[1]
  , 1000
```

Use this to make some initializations which only have to run once but neither
function may start because it is not done:

``` coffee
async.parallel [ fn, fn ], (err, results) ->
  # same as with `once.atime` it will come here exactly after the
  # first call finished because the second one will get the
  # result the same time
  # results here will be the same integer, twice
  fn (err, result) ->
    # and this call will return imediately with the previous result
```

### onceSkip

A function may be wrapped with the once method:

``` coffee
fn = async.onceSkip (a, b, cb) -> cb null, a + b
```

And now you can call the function as normal but on the second call it will
return imediately without running the code:

``` coffee
fn 2, 3, (err, x) ->
  // x will now be 5
  fn 2, 9, (err, x) ->
    // err will now be set on the second call
```

You may use this helper in case of initialization (wait) there a specific
method have to run once before any other call can succeed. Or then events
are involved and an error event will trigger the callback and the end event will
do the same.

### onceThrow

Throw an error if it is called a second time:

``` coffee
fn = async.onceThrow (a, b, cb) -> cb null, a + b
```

If you call this method multiple times it will throw an exception:

``` coffee
fn 2, 3, (err, x) ->
  # x will now be 5
  fn 2, 9, (err, x) ->
    # will neither get there because an exception is thrown above
```

### onceTime

Only run it once at a time, queue following requests and send them the result
of the next run. All calls get the same result, but then the process is already
started it will list the following calls for the next round. This assures that
their result is from the newest data set because you may changed something
while the first run was already working.

``` coffee
fn = async.onceTime (cb) ->
  time = process.hrtime()
  setTimeout ->
    cb null, time[1]
  , 1000
```

And now you may call it multiple times but it will not run more than once
simultaneously. But all simultaneous calls will get the same result.

``` coffee
async.parallel [ fn, fn ], (err, results) ->
  # will come here exactly after the first call finished (because the
  # second will do so the same time)
  # results here will be the same integer, twice
```


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
