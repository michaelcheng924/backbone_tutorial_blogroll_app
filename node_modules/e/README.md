## Information

<table>
<tr>
<td>Package</td><td>e</td>
</tr>
<tr>
<td>Description</td>
<td>Error management and utilities</td>
</tr>
<tr>
<td>Node Version</td>
<td>>= 0.4</td>
</tr>
</table>

## Usage

```coffee-script
e = require 'e'

# Configure middleware
e.use e.console # log to console
e.use e.logger '/var/log/errors.log' # log to file
e.use e.mongo 'mongodb://server.com/errors' # log to database
e.use (err) ->
  # Custom error handling here
  # The error object passed to middleware has been extended
  console.log err.fileName, err.functionName, err.lineNumber, err.context
  console.log err.level, err.levelName

# Handle all process errors to prevent crash (not good practice)
e.global()

# Change the stacktrace frame limit (default: 10)
e.limit Infinity

# Throw errors
e.debug 'some debugging'
e.low 'not that bad'
e 'Something bad happened'
e.high 'something pretty bad happened'
e.severe 'Something REALLY bad happened'

# Utilities
# .wrap will handle an error with e or call your callback
fs.readFile 'file.txt', e.wrap (contents) ->
  # do something

# .handle will handle an error with e and call your callback
fs.readFile 'file.txt', e.handle (err, contents) ->
  # do something
```

## Examples

You can view further examples in the [example folder.](https://github.com/wearefractal/e/tree/master/examples)

## LICENSE

(MIT License)

Copyright (c) 2012 Fractal <contact@wearefractal.com>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
