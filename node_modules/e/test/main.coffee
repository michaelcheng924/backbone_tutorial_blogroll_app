should = require 'should'
require 'mocha'
e = require '../index'

describe 'e', ->
  beforeEach -> e.middleware = []

  it '#() should autopopulate', (done) ->
    e.use (err) ->
      should.exist err
      should.exist err.message
      err.message.should.equal "NO"
      should.exist err.fileName
      err.fileName.should.equal __filename
      should.exist err.context
      done()
    e "NO"

  describe 'middleware', ->
    it '#use()', (done) ->
      e.use (err) ->
        should.exist err
        should.exist err.message
        err.message.should.equal "NO"
        should.exist err.fileName
        should.exist err.context
        done()
      e "NO"

  describe '#logger()', ->
    it 'should log an error properly', (done) ->
      e.use e.logger './test/test.txt'
      e.use -> done()
      e "NO"

  ### Screws up mocha
  describe '#console', ->
    it 'should log an error properly', (done) ->
      e.use e.console
      e.use -> done()
      e "NO"

  describe '#global()', ->
    it 'should handle a global error properly', (done) ->
      e.use -> done()
      throw "NO"
  ###

  describe '#control()', ->
    it 'should control with an error properly', (done) ->
      good = (err) ->
        should.exist err
        done()
      bad = -> throw new Error 'Code reached'
      fn = e.control good, bad
      fn "NO", "test"

    it 'should control without an error properly', (done) ->
      bad = -> throw new Error 'Code reached'
      e.use bad
      fn = e.control bad, (val) ->
        should.exist val
        done()
      fn null, "test"

  describe '#wrap()', ->
    it 'should wrap with an error properly', (done) ->
      e.use (err) ->
        should.exist err
        done()
      fn = e.wrap -> throw new Error 'Code reached'
      fn "NO", "test"

    it 'should wrap without an error properly', (done) ->
      e.use -> throw new Error 'Code reached'
      fn = e.wrap (val) ->
        should.exist val
        done()
      fn null, "test"

  describe '#handle()', ->
    it 'should wrap with an error properly', (done) ->
      fn = e.handle (err, val) ->
        should.exist err
        should.exist val
        done()
      fn "NO", "test"

    it 'should wrap without an error properly', (done) ->
      e.use -> throw new Error 'Code reached'
      fn = e.handle (err, val) ->
        should.not.exist err
        should.exist val
        done()
      fn null, "test"
