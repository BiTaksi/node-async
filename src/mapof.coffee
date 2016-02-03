async = require 'async'

# Helper to use map methods on objects
# =================================================
# This methods will do the same as the map method but works on objects instead
# of arrays.

module.exports.mapOf = (obj, iterator, cb) ->
  # check the object
  return cb new Error "mapOf only works on objects" unless typeof obj is 'object'
  # map over object keys
  keys = Object.keys obj
  async.map keys, (key, cb) ->
    # call iterator with value and key
    iterator obj[key], key, cb
  , (err, results) ->
    return cb err if err
    # combine the results into an object again
    map = {}
    for num in [0..keys.length-1]
      map[keys[num]] = results[num]
    cb null, map

module.exports.mapOfLimit = (obj, limit, iterator, cb) ->
  # check the object
  return cb new Error "mapOf only works on objects" unless typeof obj is 'object'
  # map over object keys
  keys = Object.keys obj
  async.mapLimit keys, limit, (key, cb) ->
    # call iterator with value and key
    iterator obj[key], key, cb
  , (err, results) ->
    return cb err if err
    # combine the results into an object again
    map = {}
    for num in [0..keys.length-1]
      map[keys[num]] = results[num]
    cb null, map

module.exports.mapOfSeries = (obj, iterator, cb) ->
  # check the object
  return cb new Error "mapOf only works on objects" unless typeof obj is 'object'
  # map over object keys
  keys = Object.keys obj
  async.mapSeries keys, (key, cb) ->
    # call iterator with value and key
    iterator obj[key], key, cb
  , (err, results) ->
    return cb err if err
    # combine the results into an object again
    map = {}
    for num in [0..keys.length-1]
      map[keys[num]] = results[num]
    cb null, map
