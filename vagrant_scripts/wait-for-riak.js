var async = require('async')
var request = require('request')
var q = require('q')
var config = require('config')
var inspect = require('eyespect').inspector()

module.exports = function waitForRiak() {
  var complete
  var deferred = q.defer()
  var riakPort = config.ports.riak_http.host
  var url = 'http://localhost:' + riakPort + '/ping'
  async.until(isComplete, poll, finalCB)
  return deferred.promise

  function isComplete() {
    return complete
  }

  function finalCB(err) {
    if (err) {
      return deferred.reject(err)
    }
    deferred.resolve()
  }

  function poll(cb) {
    inspect(url, 'ping riak at url')
    request(url, requestCB)

    function requestCB(err, res, body) {
      if (err) {
        setTimeout(cb, 1000)
        return
      }
      inspect(body, 'ping riak body')
      if (res && res.statusCode === 200) {
        complete = true
        return cb()
      }
      setTimeout(cb, 1000)
    }
  }
}

