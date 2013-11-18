express = require 'express'
saver = require './saver'
db = require './db'

app = express()

database = db()
database.on 'load', ->
  app.listen 1127
  console.log 'Listening on port 1127'

app.use express.json()
app.use express.urlencoded()
app.use express.methodOverride()
app.use app.router
app.use (err, req, res, next) ->
  res.send 500, "Bad things happened:<br/> #{err.message}"

app.post '/post', (req, res, next) ->
  saver.saveRequest req, database, (err, filename) ->
    return next err if err?

    console.log 'saved', filename
    res.end()
