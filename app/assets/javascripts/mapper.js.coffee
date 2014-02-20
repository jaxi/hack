class @MapApp.Mapper
  constructor: (cssSelector) ->
    @cssSelector = cssSelector
    @map = null
    @bounds = new MapApp.MapBounds

  addCoordinates: (latitude, longitude) ->
    @bounds.add(latitude, longitude)

  render: =>
    @map = new MapApp.Map(@cssSelector, @bounds)
    @map.build()