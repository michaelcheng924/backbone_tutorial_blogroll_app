e = (err, level=2, callee=arguments.callee) ->
  return unless err?
  err = new Error if err.message then err.message else err
  stack = e.stack callee
  if stack and stack[0]
    #err.frames = stack
    err.fileName = stack[0].getFileName()
    err.functionName = stack[0].getFunctionName()
    err.lineNumber = stack[0].getLineNumber()
    err.columnNumber = stack[0].getColumnNumber()
    err.context = stack[0].getThis()
  err.level = level
  err.levelName = e.levels[level]
  middle err for middle in e.middleware

e.debug = (msg) -> e msg, 0, arguments.callee
e.low = (msg) -> e msg, 1, arguments.callee
e.normal = (msg) -> e msg, 2, arguments.callee
e.high = (msg) -> e msg, 3, arguments.callee
e.severe = (msg) -> e msg, 4, arguments.callee

e.levels = ["DEBUG", "LOW", "NORMAL", "HIGH", "SEVERE"] # TODO: Make these better
e.middleware = []
e.use = (fn) -> e.middleware.push fn

# Call error handler if err exists in first arg
# Call wrapped fn if err doesnt exist
e.wrap = (fn) ->
  callee = arguments.callee
  (err, args...) ->
    if err?
      e err, null, callee
    else
      fn args...
    return

# Same as e.wrap but for killing async control flow
e.control = (cb, fn) ->
  callee = arguments.callee
  (err, args...) ->
    if err?
      cb err
      e err, null, callee
    else
      fn args...
    return

# Call error handler if err exists in first arg
# Call wrapped fn
e.handle = (fn) ->
  callee = arguments.callee
  (args...) ->
    e args[0], null, callee if args[0]?
    fn args...

# Change stackTraceLimit - higher = more verbose
e.limit = (n) -> Error.stackTraceLimit = n

# Handle all global errors
e.global = -> process.on 'uncaughtException', e

# Grab raw stack frames from V8
e.stack = (callee=arguments.callee) ->
  stacko = {}
  orig = Error.prepareStackTrace
  Error.prepareStackTrace = (_, stack) -> stack
  Error.captureStackTrace stacko, callee
  frames = stacko.stack
  Error.prepareStackTrace = orig
  return frames

# Included middleware
e.console = (err) ->
  contents = "[#{err.levelName}][#{new Date()}] - #{err.message}"
  if err.level > 0
    contents += " thrown in #{err.fileName}" if err.fileName?
    contents += "\r\n#{err.stack}"
  console.log contents

e.logger = (file) ->
  (err) ->
    fs = require 'fs'
    try
      contents = fs.readFileSync file
    catch e
      contents = " -- Error Log -- "
    contents += "\r\n[#{err.levelName}][#{new Date()}] - #{err.message}"
    if err.level > 0
      contents += " thrown in #{err.fileName}" if err.fileName?
      contents += "\r\n#{err.stack}"
    fs.writeFileSync file, contents

e.mongo = (db) ->
  (err) ->
    mongo = require 'mongodb'
    # TODO

module.exports = e
