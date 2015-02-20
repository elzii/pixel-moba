map = require "./maps/normal/config.json"
hero = require "./heroes/armless/config.json"
skin = hero.skins.default
cursors = undefined
tween = undefined
heroObject = undefined

preload = ->
  game.load.image "background", "maps/normal/#{map.map.background.image}"
  game.load.spritesheet "hero", "heroes/armless/#{skin.spritesheet}", skin.width, skin.height, skin.frameCount

  for terrain in map.map.terrain
    game.load.image terrain.name, "maps/normal/#{terrain.image}"

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
  game.world.setBounds -(map.map.size[0] / 2), -(map.map.size[1] / 2), (map.map.size[0] / 2), (map.map.size[1] / 2)
  game.add.tileSprite -(map.map.size[0] / 2), -(map.map.size[1] / 2), (map.map.size[0] / 2), (map.map.size[1] / 2), "background"
  game.input.mousePointer.x = 400
  game.input.mousePointer.y = 300

  heroObject = game.add.sprite (-800 + 400), (-600 + 300), "hero"

  heroObject.animations.add "idle", skin.animations.idle.frames, skin.animations.idle.frameRate, true
  heroObject.animations.add "move", skin.animations.moving.frames, skin.animations.moving.frameRate, true
  heroObject.animations.play "idle"

  game.input.onDown.add moveHero, this

  i = 0
  while i < 100
    game.add.sprite game.world.randomX, game.world.randomY, "tree"
    game.add.sprite game.world.randomX, game.world.randomY, "rock"
    i++

  cursors = game.input.keyboard.createCursorKeys()

update = ->
  x = game.input.mousePointer.x
  y = game.input.mousePointer.y

  if game.input.activePointer.withinGame
    if cursors.up.isDown or y < 50
      game.camera.y -= 4
    else if cursors.down.isDown or y > 550
      game.camera.y += 4
    if cursors.left.isDown or x < 50
      game.camera.x -= 4
    else if cursors.right.isDown or x > 750
      game.camera.x += 4

render = ->
  game.debug.cameraInfo game.camera, 32, 32

game = new (Phaser.Game)(800, 600, Phaser.CANVAS, "phaser-example",
  preload: preload
  create: create
  update: update
  render: render)
