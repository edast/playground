io = require 'socket.io-client'

class DisplayClient
  socket: null
  images: []
  
  constructor: (@opts = {}) ->
    #console.log 'construct', io
    @opts.host or= 'localhost'
    @opts.port or= 3000
    
  init: =>
    @socket = new io "http://#{@opts.host}:#{@opts.port}"
    @socket.on 'connect', =>
      console.log 'connected!!!'
      @socket.on 'event', @onEvent
      @socket.on 'images', @onImages
      @socket.on 'showImage', @onShowImage
      @socket.on 'disconnect', @onDisconnect
 
  onShowImage: (num) =>
    console.log "show image #{@images[num]}"
    if document?
      img = document.getElementById "displayImage"
      img.src = @images[num]
    
  onImages: (images) =>
    @images = images
    console.log 'my images', toString.call(images)

  onEvent: (msg) ->
    console.log msg
  
  onDisconnect: =>
    console.log 'got disconnected :('
    @socket.close()
    
client = new DisplayClient
client.init()


