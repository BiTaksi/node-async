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
  debug "throw ##{func.__id}: created for #{chalk.grey func}"
  if context
    debug "throw ##{func.__id}: using specific context"
  # return throw function
  ->
    # throw error after first call
    debug "throw ##{func.__id}: called"
    if called
      debug "throw ##{func.__id}: called again issuing an error"
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
  debug "skip ##{func.__id}: created for #{chalk.grey func}"
  if context
    debug "skip ##{func.__id}: using specific context"
  # return skip function
  ->
    # get callback parameter
    cb = arguments[arguments.length-1]
    # throw error after first call
    if called
      debug "skip ##{func.__id}: skipped because already called"
      err = new Error "This function should only be called once."
      return cb err if typeof cb is 'function'
      return err
    debug "skip ##{func.__id}: called"
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
  debug "time ##{func.__id}: created for #{chalk.grey func}"
  if typeof context is 'object' and Object.keys(context).length
    debug "time ##{func.__id}: using specific context #{chalk.grey util.inspect context}"
  # return time function
  nfunc = ->
    # get callback parameter
    args = [].slice.call arguments
    cb = args.pop() ? {}
    idargs = util.inspect(args[0..]).replace /\n\s*/g, ' '
    # add to listeners
    if started
      debug "time ##{func.__id}: #{chalk.grey idargs} called but waiting"
      next.push [idargs, args, cb]
      return
    else
      debug "time ##{func.__id}: #{chalk.grey idargs} called"
      listeners.push cb
    started = true
    # add the time callback
    args.push ->
      debug "time ##{func.__id}: #{chalk.grey idargs} done with result #{chalk.grey util.inspect arguments}"
      # start sending back and reopening method
      started = false
      work = [].slice.call listeners
      listeners = []
      # call all listeners
      for cb in work
        debug "time ##{func.__id}: #{chalk.grey idargs} inform listener"
        cb.apply context, arguments
      # rerun if more to do
      if next.length
        [id, args, cb] = next.shift()
        debug "time ##{func.__id}: #{chalk.grey id} restart"
        args.push cb
        nfunc.apply this, args
#      if next.length
#        waiting = []
#        id = null
#        args = null
#        cb = null
#        for entry in next
#          if listeners.length == 0
#            [id, args, cb] = entry
#          else
#            waiting.push entry
#        next = waiting
#        debug "time ##{func.__id}: #{chalk.grey id} restart"
#        args.push cb
#        func.apply context, args
    # run real function
    func.apply context, args
  nfunc

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
  debug "wait ##{func.__id}: created for #{chalk.grey func}"
  if context
    debug "wait ##{func.__id}: using specific context"
  # return wait function
  ->
    # get callback parameter
    args = [].slice.call arguments
    cb = args.pop() ? {}
    # return if already done
    if done
      debug "wait ##{func.__id}: called again -> send result"
      return cb.apply context, results
    # add to listeners
    listeners.push cb
    if started
      debug "wait ##{func.__id}: called again while running"
      return
    debug "wait ##{func.__id}: called"
    # add the wait callback
    started = true
    args.push ->
      debug "wait ##{func.__id}: done"
      # store results
      done = true
      results = [].slice.call arguments
      # call all listeners
      for cb in listeners
        debug "wait ##{func.__id}: inform listener"
        cb.apply context, results
      listeners = null
    # run real function
    func.apply context, args
