var config = require('config')
var _ = require('lodash-node')
var ports = config.ports

module.exports = function getArgs(ip, joinIP) {
  var portsString = generatePortsString()
  var args = portsString.split(' ')
  args.unshift('run')

  args.push('-e')
  args.push('RIAK_NODE_NAME=riak@' + ip)
  if (joinIP) {
    args.push('-e')
    args.push('RIAK_JOIN_NODE=riak@' + joinIP)
  }
  args.push('-t')
  args.push('riak')
  return args
}

function generatePortsString() {
  var portValues = _.values(ports)
  var portsRange = _.range(config.range_start, config.range_end)
  portsRange = portsRange.map(buildPairs)


  portValues = portValues.concat(portsRange)
  return portValues.map(stringifyPortMapping).join(' ')
}

function stringifyPortMapping(item) {
  var host = item.host
  var dest = item.dest
  var output = '-p ' + host + ':' + dest
  return output
}

function buildPairs(port) {
  return {
    host: port,
    dest: port
  }
}

