io = require 'socket.io'
_ = require 'underscore'
class DisplayServer
  server: null
  clients: []
  images: [
    "http://lorempixel.com/400/200/fashion/1"
    "http://lorempixel.com/400/200/fashion/2"
    "http://lorempixel.com/400/200/fashion/3"
    "http://lorempixel.com/400/200/fashion/4"
    "http://lorempixel.com/400/200/fashion/5"
  ]
  
  init: =>
    @server = new io()
    @server.listen 3000
    @server.on 'connection', @logConnection
    setInterval @showImage, 5000

    
  logConnection: (socket) =>
    #clientId = socket.client.id
    @clients.push socket
    console.log 'new client connected', socket.client.id
#    @server.emit 'event', "new user #{socket.client.id} connected, total count #{@clients.length}"
    @server.emit 'images', @images
    
    socket.emit 'event', 'I like you'
    
    
  showImage: =>
    num = _.random 0, @images.length - 1
    console.log 'show image', num, "; client count #{@clients.length}"
    @server.emit 'showImage', num
    
server = new DisplayServer()
server.init()
