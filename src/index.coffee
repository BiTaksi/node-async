# Startup script
# =================================================


# Node Modules
# -------------------------------------------------

# include base modules
async = require 'async'
# internal modules and helpers
once = require './once'
mapof = require './mapof'

# Export combined library
# -------------------------------------------------
module.exports = async

module.exports.once = once.wait
module.exports.onceSkip = once.skip
module.exports.onceThrow = once.throw
module.exports.onceTime = once.time

module.exports.mapOf = mapof.mapOf
module.exports.mapOfLimit = mapof.mapOfLimit
module.exports.mapOfSeries = mapof.mapOfSeries

