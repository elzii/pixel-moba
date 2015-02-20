map = require "./maps/normal/config.json"
cursors = undefined

preload = ->
  game.load.image "background", "maps/normal/#{map.map.background.image}"

  for terrain in map.map.terrain
    game.load.image terrain.name, "maps/normal/#{terrain.image}"

create = ->
  #  Modify the world and camera bounds
  game.world.setBounds -(map.map.size[0] / 2), -(map.map.size[1] / 2), (map.map.size[0] / 2), (map.map.size[1] / 2)
  game.add.tileSprite -(map.map.size[0] / 2), -(map.map.size[1] / 2), (map.map.size[0] / 2), (map.map.size[1] / 2), "background"
  game.input.mousePointer.x = 400
  game.input.mousePointer.y = 300

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
