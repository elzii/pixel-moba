module.exports =
  preload: (map, game) ->
    for terrain in map.map.terrain
      spritePath = "maps/normal/"

      if terrain.frameCount
        game.load.spritesheet terrain.name, (spritePath + terrain.image), terrain.width, terrain.height, terrain.frameCount
      else
        game.load.image terrain.name, (spritePath + terrain.image)
  create: (map, game) ->
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
