#!/usr/bin/env node

var config = require('config')
var path = require('path')
var fs = require('fs')
var mu = require('mustache')
var filePath = path.join(__dirname, 'templates/riak.conf.ejs')
var source = fs.readFileSync(filePath)
var template = mu.render(source, config)
console.log(template)

