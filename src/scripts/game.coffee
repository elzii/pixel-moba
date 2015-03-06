map = require "./maps/normal/config.json"
hero = require "./heroes/armless/config.json"
skin = hero.skins.default
startPosition = [60, (map.map.size[1] - skin.height - 60)]
cursors = undefined
tween = undefined
heroObject = undefined

preload = ->
  game.load.spritesheet "hero", "heroes/armless/#{skin.spritesheet}", skin.width, skin.height, skin.frameCount

  for terrain in map.map.terrain
    spritePath = "maps/normal/"

    if terrain.frameCount
      game.load.spritesheet terrain.name, (spritePath + terrain.image), terrain.width, terrain.height, terrain.frameCount
    else
      game.load.image terrain.name, (spritePath + terrain.image)

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
  game.camera.y = map.map.size[1] - 600
  game.input.mousePointer.x = startPosition[0]
  game.input.mousePointer.y = startPosition[1]

  for layout in map.map.layout
    sprite = null

    # what type of layout are we talking here?
    if layout.type is "line"
      i = layout.start

      while i <= layout.end
        if layout.direction is "y"
          sprite = game.add.sprite layout.static, i, layout.terrain
        else if layout.direction is "x"
          sprite = game.add.sprite i, layout.static, layout.terrain

        i += layout.margin
    else if layout.type is "area"
      sprite = game.add.tileSprite layout.x, layout.y, layout.width, layout.height, layout.terrain
    else if layout.type is "spot"
      sprite = game.add.sprite layout.x, layout.y, layout.terrain

    # lets see if there are more to do
    if layout.extra
      for extra in layout.extra
        if extra.type is "angle"
          sprite.angle = extra.degrees
        else if extra.type is "animate"
          sprite.animations.add "ani", extra.frames, extra.frameRate, extra.loop
          sprite.animations.play "ani"

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
