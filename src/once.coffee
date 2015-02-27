# Helper to call given function once
# =================================================
# This methods will wrap a given function. Afterwards it will only run once
# also if called multiple times.

# Throw an error
# -------------------------------------------------
# If it is called a second time an error will be thrown.
module.exports.throw = (func, context) ->
  # check parameters
  unless typeof func is 'function'
    throw new Error "Argument func is not a function!"
  # flags
  called = false
  # return wrapper function
  ->
    # throw error after first call
    if called
      throw new Error "This function should only be called once."
    # run real function
    called = true
    func.apply context, arguments

# Skip execution
# -------------------------------------------------
# If it is called a second time execution is skipped and an error will be returned.
# You may use the error or not.
module.exports.skip = (func, context) ->
  # check parameters
  unless typeof func is 'function'
    throw new Error "Argument func is not a function!"
  # flags
  called = false
  # return wrapper function
  ->
    # get callback parameter
    cb = arguments[arguments.length-1]
    # throw error after first call
    if called
      err = new Error "This function should only be called once."
      return cb err if typeof cb is 'function'
      return err
    # run real function
    called = true
    func.apply context, arguments

# Only once atime
# -------------------------------------------------
# If it is called a second time it will return only after the first call
# has finished. This makes only sense with asynchronous functions.
module.exports.atime = (func, context) ->
  # check parameters
  unless typeof func is 'function'
    throw new Error "Argument func is not a function!"
  # flags
  started = false # if the function has already started
  listeners = []  # callbacks waiting
  # return wrapper function
  ->
    # get callback parameter
    args = [].slice.call arguments
    cb = args.pop() ? {}
    # add to listeners
    listeners.push cb
    return if started
    # add the wrapper callback
    started = true
    args.push ->
      # start sending back and reopening method
      started = false
      work = [].slice.call listeners
      listeners = []
      # call all listeners
      for cb in work
        cb.apply null, arguments
    # run real function
    func.apply context, args

# Wait if just running
# -------------------------------------------------
# If it is called a second time it will return only after the first call
# has finished. This makes only sense with asynchronous functions.
module.exports.wait = (func, context) ->
  # check parameters
  unless typeof func is 'function'
    throw new Error "Argument func is not a function!"
  # flags
  started = false # if the function has already started
  done = false    # if the function has already ended
  listeners = []  # callbacks waiting
  results = []    # the results stored for further calls
  # return wrapper function
  ->
    # get callback parameter
    args = [].slice.call arguments
    cb = args.pop() ? {}
    # return if already done
    return cb.apply null, results if done
    # add to listeners
    listeners.push cb
    return if started
    # add the wrapper callback
    started = true
    args.push ->
      # store results
      done = true
      results = [].slice.call arguments
      # call all listeners
      cb.apply null, results for cb in listeners
      listeners = null
    # run real function
    func.apply context, args

