chai = require 'chai'
expect = chai.expect
async = require '../../src/index'

describe "each", ->

  it "should work for multiple successful runs", (done) ->
    async.each [1,2,3], (n,cb) ->
      cb()
    , (err) ->
      expect(err, 'error').to.not.exist
      done()

  it "should fail if at least one run fails", (done) ->
    async.each [1,2,3], (n,cb) ->
      return cb true unless n<3
      cb()
    , (err) ->
      expect(err, 'error').to.exist
      done()
