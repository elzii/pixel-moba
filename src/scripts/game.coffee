map = require "./maps/normal/config.json"
hero = require "./heroes/armless/config.json"
mapModule = require "./scripts/mapModule"
skin = hero.skins.default
startPosition = [60, (map.map.size[1] - skin.height - 60)]
cursors = undefined
tween = undefined
heroObject = undefined

preload = ->
  game.load.spritesheet "hero", "heroes/armless/#{skin.spritesheet}", skin.width, skin.height, skin.frameCount

  mapModule.preload map, game

# game.physics.arcade.distanceToPointer( is broking atm
distanceToPointer = (displayObject, pointer) ->
  @dx = displayObject.x - pointer.worldX
  @dy = displayObject.y - pointer.worldY

  return Math.sqrt(@dx * @dx + @dy * @dy)

moveHero = (pointer) ->
  if tween and tween.isRunning
    tween.stop()

  heroObject.animations.play "move"

  y = pointer.worldY - skin.height
  x = pointer.worldX

  if heroObject.x > x
    x += (skin.width / 2)

    if heroObject.scale.x is 1
      heroObject.scale.x = -1
  if heroObject.x < x
    x -= (skin.width / 2)

    if heroObject.scale.x is -1
      heroObject.scale.x = 1

  duration = (distanceToPointer(heroObject, pointer) / hero.base.movement_speed) * 1000
  tween = game.add.tween heroObject
    .to {x: x, y: y}, duration, Phaser.Easing.Linear.None, true

  tween.onComplete.add ->
    heroObject.animations.play "idle"

create = ->
  #  Modify the world and camera bounds
  game.world.setBounds 0, 0, map.map.size[0], map.map.size[1]
  game.scale.scaleMode = Phaser.ScaleManager.RESIZE
  game.camera.x = 0
  game.camera.y = 4000
  game.input.mousePointer.x = startPosition[0]
  game.input.mousePointer.y = startPosition[1]

  mapModule.create map, game

  heroObject = game.add.sprite startPosition[0], startPosition[1], "hero"

  heroObject.animations.add "idle", skin.animations.idle.frames, skin.animations.idle.frameRate, true
  heroObject.animations.add "move", skin.animations.moving.frames, skin.animations.moving.frameRate, true
  heroObject.animations.play "idle"

  game.input.onDown.add moveHero, this


  cursors = game.input.keyboard.createCursorKeys()

update = ->
  x = game.input.mousePointer.x
  y = game.input.mousePointer.y
  gameWidth = game.camera.game.width
  gameHeight = game.camera.game.height

  if game.input.activePointer.withinGame
    if cursors.up.isDown or y < 50
      game.camera.y -= 4
    else if cursors.down.isDown or y > (gameHeight - 50)
      game.camera.y += 4
    if cursors.left.isDown or x < 50
      game.camera.x -= 4
    else if cursors.right.isDown or x > (gameWidth - 50)
      game.camera.x += 4

render = ->
  game.debug.cameraInfo game.camera, 32, 32

game = new (Phaser.Game)(800, 600, Phaser.WEBGL, "phaser-example",
  preload: preload
  create: create
  update: update
  render: render)
