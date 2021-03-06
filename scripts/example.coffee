# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md
child_process = require('child_process')

module.exports = (robot) ->

  robot.respond /calendario/i, (msg) ->
    child_process.exec 'cal -h', (error, stdout, stderr) ->
      msg.send(error)
      msg.send(stderr)
      msg.send(stdout)



  robot.hear /badger/i, (msg) ->
    msg.send "Badgers? BADGERS? WE DON'T NEED NO STINKIN BADGERS"

  robot.hear /workflow/i, (msg) ->
    msg.send "Entra ai que vc descobre https://github.com/sthouse/openship/wiki/Nosso-Workflow"

  # robot.hear /Farah/i, (msg) ->
  #   msg.send "Farah foi invocado na conversa! \n 'É só fazer um javinha' \n 'Coloca um if ai.' "

  # robot.hear /openbot[^:]/i, (msg) ->
  #   msg.send "alguém me chamou?"

  robot.respond /open the (.*) doors/i, (msg) ->
    doorType = msg.match[1]
    if doorType is "pod bay"
      msg.reply "I'm afraid I can't let you do that."
    else
      msg.reply "Opening #{doorType} doors"

  robot.hear /frases do Farah/i, (msg) ->
    msg.reply "Dicionario Faraniano. \n Até o momento temos: \n #{robot.brain.get('farah_says')}"

  robot.respond /frase do Farah (.*)/i, (msg) ->
    says = robot.brain.get('farah_says') || ""
    robot.brain.set 'farah_says', "#{says} \n #{msg.match[1]}"
    msg.reply "OK, a frase foi salva no nosso dicionario Faraniano. \n Até o momento temos: \n #{robot.brain.get('farah_says')}"

  robot.respond /zerar frases/i, (msg) ->
    robot.brain.set 'farah_says', ""
    msg.send "Ok, Envie novas frases e concorra a uma conversa de 1h com o Farah ao vivo!"

  robot.hear /I like pie/i, (msg) ->
    msg.emote "makes a freshly baked pie"

  lulz = ['lol', 'rofl', 'lmao']

  robot.respond /lulz/i, (msg) ->
    msg.send msg.random lulz

  robot.topic (msg) ->
    msg.send "#{msg.message.text}? That's a Paddlin'"


  enterReplies = ['Hi', 'Target Acquired', 'Firing', 'Hello friend.', 'Gotcha', 'I see you']
  leaveReplies = ['Are you still there?', 'Target lost', 'Searching']

  robot.enter (msg) ->
    msg.send msg.random enterReplies
  robot.leave (msg) ->
    msg.send msg.random leaveReplies

  answer = process.env.HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING

  robot.respond /what is the answer to the ultimate question of life/, (msg) ->
    unless answer?
      msg.send "Missing HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING in environment: please set and try again"
      return
    msg.send "#{answer}, but what is the question?"

  robot.respond /you are a little slow/, (msg) ->
    setTimeout () ->
      msg.send "Who you calling 'slow'?"
    , 60 * 1000

  annoyIntervalId = null

  robot.respond /annoy me/, (msg) ->
    if annoyIntervalId
      msg.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
      return

    msg.send "Hey, want to hear the most annoying sound in the world?"
    annoyIntervalId = setInterval () ->
      msg.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
    , 1000

  robot.respond /unannoy me/, (msg) ->
    if annoyIntervalId
      msg.send "GUYS, GUYS, GUYS!"
      clearInterval(annoyIntervalId)
      annoyIntervalId = null
    else
      msg.send "Not annoying you right now, am I?"


  robot.router.post '/hubot/chatsecrets/:room', (req, res) ->
    room   = req.params.room
    data   = JSON.parse req.body.payload
    secret = data.secret

    robot.messageRoom room, "I have a secret: #{secret}"

    res.send 'OK'

  robot.error (err, msg) ->
    robot.logger.error "DOES NOT COMPUTE"

    if msg?
      msg.reply "ta de sacanagem"

  robot.respond /have a soda/i, (msg) ->
    # Get number of sodas had (coerced to a number).
    sodasHad = robot.brain.get('totalSodas') * 1 or 0

    if sodasHad > 4
      msg.reply "I'm too fizzy.."

    else
      msg.reply 'Sure!'

      robot.brain.set 'totalSodas', sodasHad+1

  robot.respond /sleep it off/i, (msg) ->
    robot.brain.set 'totalSodas', 0
    robot.respond 'zzzzz'
