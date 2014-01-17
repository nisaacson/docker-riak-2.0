#!/usr/bin/env node

var argv = require('optimist').demand(['host-ip']).argv
var ip = argv['host-ip']
var spawn = require('child_process').spawn
var inspect = require('eyespect').inspector()
var waitForRiak = require('./wait-for-riak')
var containerRunArgs = require('./container-run-args')

run().then(cleanExit).done()

function cleanExit() {
  inspect('riak server online')
  process.exit(0)
}

function run() {
  var args = containerRunArgs(ip)
  inspect(args, 'args')
  var child = spawn('docker', args, {})
  child.stdout.setEncoding('utf8')
  child.stderr.setEncoding('utf8')
  // child.stdout.pipe(process.stdout)
  // child.stderr.pipe(process.stderr)
  child.on('exit', exitHandler)
  var timeoutInMilliseconds = 10 * 1000
  return waitForRiak().timeout(timeoutInMilliseconds)

  function exitHandler(code) {
    inspect(code, 'run exit code')
    process.exit(1)
  }
}

