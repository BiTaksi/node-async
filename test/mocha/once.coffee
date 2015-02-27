chai = require 'chai'
expect = chai.expect
require('alinex-error').install()

async = require '../../src/index'

describe "once", ->

  describe "default", ->

    it "should call function with callback", (done) ->
      fn = async.once (cb) ->
        time = process.hrtime()
        setTimeout ->
          cb null, time[1]
        , 1000
      fn (err, x) ->
        expect(x, 'result').to.exist
        done()

    it "should run once with two parallel calls", (done) ->
      fn = async.once (cb) ->
        time = process.hrtime()
        setTimeout ->
          cb null, time[1]
        , 1000
      async.parallel [ fn, fn ], (err, results) ->
        expect(err, 'error').to.not.exist
        expect(results[0], 'same result').to.equal results[1]
        done()

    it "should return immediately on the second call", (done) ->
      fn = async.once (cb) ->
        time = process.hrtime()
        setTimeout ->
          cb null, time[1]
        , 1000
      async.series [ fn, fn ], (err, results) ->
        expect(err, 'error').to.not.exist
        expect(results[0], 'different result').to.equal results[1]
        done()

  describe "onceThrow", ->

    it "should call function with return", ->
      fn = async.onceThrow (a, b) -> a + b
      x = fn 2, 3
      expect(x, 'result').to.equal 5

    it "should call function with callback", ->
      fn = async.onceThrow (a, b, cb) -> cb a + b
      fn 2, 3, (x) ->
        expect(x, 'result').to.equal 5

    it "should throw error on second call", ->
      fn = async.onceThrow (a, b) -> a + b
      x = fn 2, 3
      expect( ->
        x = fn 3, 4
      , 'second call'
      ).to.throw Error

  describe "onceSkip", ->

    it "should call function with return", ->
      fn = async.onceSkip (a, b) -> a + b
      x = fn 2, 3
      expect(x, 'result').to.equal 5

    it "should call function with callback", ->
      fn = async.onceSkip (a, b, cb) -> cb a + b
      fn 2, 3, (x) ->
        expect(x, 'result').to.equal 5

    it "should return error on second call", ->
      fn = async.onceSkip (a, b) -> a + b
      x = fn 2, 3
      expect(x, 'result').to.equal 5
      x = fn 2, 3
      expect(x, 'second call').to.be.instanceof Error

    it "should callback error on second call", ->
      fn = async.onceSkip (a, b, cb) -> cb a + b
      fn 2, 3, (x) ->
        expect(x, 'result').to.equal 5
        fn 2, 3, (x) ->
          expect(x, 'second call').to.be.instanceof Error

  describe "onceTime", ->

    it "should call function with callback", (done) ->
      fn = async.onceTime (cb) ->
        time = process.hrtime()
        setTimeout ->
          cb null, time[1]
        , 1000
      fn (err, x) ->
        expect(x, 'result').to.exist
        done()

    it "should run once with two parallel calls", (done) ->
      fn = async.onceTime (cb) ->
        time = process.hrtime()
        setTimeout ->
          cb null, time[1]
        , 1000
      async.parallel [ fn, fn ], (err, results) ->
        expect(err, 'error').to.not.exist
        expect(results[0], 'same result').to.equal results[1]
        done()

    it "should run twice with two serial calls", (done) ->
      @timeout 5000
      fn = async.onceTime (cb) ->
        time = process.hrtime()
        setTimeout ->
          cb null, time[1]
        , 1000
      async.series [ fn, fn ], (err, results) ->
        expect(err, 'error').to.not.exist
        expect(results[0], 'different result').to.not.equal results[1]
        done()
