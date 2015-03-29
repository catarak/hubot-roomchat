# Hubot Dependencies
{Robot, Adapter, TextMessage, EnterMessage, LeaveMessage, Response} = require 'hubot'

# Irc library
Irc = require('irc')

# Logger
Log = require('log')
logger = new Log process.env.HUBOT_LOG_LEVEL or 'info'

class RoomchatBot extends Adapter
  send: (envelope, strings...) ->
    target = @_getTargetFromEnvelope envelope

    #target doesn't exist, oops
    unless target
      return logger.error "ERROR: Not sure who to send to. envelope=", envelope

    for str in strings
      logger.debug "#{target} #{str}"
      @bot.say target, str

  reply: (envelope, strings...) ->
    for str in strings
      @send envelope.user, "#{envelope.user.name}: #{str}"

  run: ->
    self = @

    #do some stuff to join roomchat
    @bot = bot

    self.emit "connected"
  
  # Private
  _getTargetFromEnvelope: (envelope) ->
    user = null
    room = null
    target = null

    if envelope.reply_to
      user = envelope
    else
      # expand envelope
      user = envelope.user
      room = envelope.room

    if user
      # most common case - we're replying to a user in a room
      if user.room
        target = user.room
      # allows user to be an id string
      else if user.search?(/@/) != -1
        target = user
    else if room
      # this will happen if someone uses robot.messageRoom(jid, ...)
      target = room

    target



exports.use = (robot) ->
  new RoomchatBot robot