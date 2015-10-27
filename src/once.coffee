# Helper to call given function once
# =================================================
# This methods will wrap a given function. Afterwards it will only run once
# also if called multiple times.

debug = require('debug')('async:once')
chalk = require 'chalk'
util = require 'util'

functionId = 0

# Throw an error
# -------------------------------------------------
# If it is called a second time an error will be thrown.
module.exports.throw = (context, func) ->
  unless func
    func = context
    context = undefined
  # check parameters
  unless typeof func is 'function'
    throw new Error "Argument func is not a function!"
  # flags
  called = false
  func.__id ?= ++functionId
  debug "wrapper ##{func.__id}: created for #{chalk.grey func}"
  if context
    debug "wrapper ##{func.__id}: using specific context"
  # return wrapper function
  ->
    # throw error after first call
    debug "wrapper ##{func.__id}: called"
    if called
      debug "wrapper ##{func.__id}: called again issuing an error"
      throw new Error "This function should only be called once."
    # run real function
    called = true
    func.apply context, arguments

# Skip execution
# -------------------------------------------------
# If it is called a second time execution is skipped and an error will be returned.
# You may use the error or not.
module.exports.skip = (context, func) ->
  unless func
    func = context
    context = undefined
  # check parameters
  unless typeof func is 'function'
    throw new Error "Argument func is not a function!"
  # flags
  called = false
  func.__id ?= ++functionId
  debug "wrapper ##{func.__id}: created for #{chalk.grey func}"
  if context
    debug "wrapper ##{func.__id}: using specific context"
  # return wrapper function
  ->
    # get callback parameter
    cb = arguments[arguments.length-1]
    # throw error after first call
    if called
      debug "wrapper ##{func.__id}: skipped because already called"
      err = new Error "This function should only be called once."
      return cb err if typeof cb is 'function'
      return err
    debug "wrapper ##{func.__id}: called"
    # run real function
    called = true
    func.apply context, arguments

# Only once atime
# -------------------------------------------------
# If it is called a second time it will return only after the first call
# has finished. This makes only sense with asynchronous functions.
module.exports.time = (context, func) ->
  unless func
    func = context
    context = undefined
  # check parameters
  unless typeof func is 'function'
    throw new Error "Argument func is not a function!"
  # flags
  started = false # if the function has already started
  listeners = []  # callbacks waiting
  next = [] # list for the next round
  func.__id ?= ++functionId
  debug "wrapper ##{func.__id}: created for #{chalk.grey func}"
  if typeof context is 'object' and Object.keys(context).length
    debug "wrapper ##{func.__id}: using specific context #{chalk.grey util.inspect context}"
  # return wrapper function
  ->
    # get callback parameter
    args = [].slice.call arguments
    cb = args.pop() ? {}
    # add to listeners
    if started
      debug "wrapper ##{func.__id}: called but waiting"
      next.push cb
      return
    else
      debug "wrapper ##{func.__id}: called"
      listeners.push cb
    # add the wrapper callback
    started = true
    args.push ->
      debug "wrapper ##{func.__id}: done with result #{chalk.grey util.inspect arguments}"
      # start sending back and reopening method
      started = false
      work = [].slice.call listeners
      listeners = []
      # call all listeners
      for cb in work
        debug "wrapper ##{func.__id}: inform listener"
        cb.apply context, arguments
      # rerun if more to do
      if next.length
        debug "wrapper ##{func.__id}: restart"
        listeners = next
        next = []
        func.apply context, args
    # run real function
    func.apply context, args

# Wait if just running
# -------------------------------------------------
# If it is called a second time it will return only after the first call
# has finished. This makes only sense with asynchronous functions.
module.exports.wait = (context, func) ->
  unless func
    func = context
    context = undefined
  # check parameters
  unless typeof func is 'function'
    throw new Error "Argument func is not a function!"
  # flags
  started = false # if the function has already started
  done = false    # if the function has already ended
  listeners = []  # callbacks waiting
  results = []    # the results stored for further calls
  func.__id ?= ++functionId
  debug "wrapper ##{func.__id}: created for #{chalk.grey func}"
  if context
    debug "wrapper ##{func.__id}: using specific context"
  # return wrapper function
  ->
    # get callback parameter
    args = [].slice.call arguments
    cb = args.pop() ? {}
    # return if already done
    if done
      debug "wrapper ##{func.__id}: called again -> send result"
      return cb.apply context, results
    # add to listeners
    listeners.push cb
    if started
      debug "wrapper ##{func.__id}: called again while running"
      return
    debug "wrapper ##{func.__id}: called"
    # add the wrapper callback
    started = true
    args.push ->
      debug "wrapper ##{func.__id}: done"
      # store results
      done = true
      results = [].slice.call arguments
      # call all listeners
      for cb in listeners
        debug "wrapper ##{func.__id}: inform listener"
        cb.apply context, results
      listeners = null
    # run real function
    func.apply context, args

