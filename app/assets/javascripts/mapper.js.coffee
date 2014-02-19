class @MapApp.Mapper
  constructor: (cssSelector) ->
    @cssSelector = cssSelector
    @map = null
    @bounds = new MapApp.MapBounds

  addCoordinates: (latitude, longitude) ->
    if !_.isEmpty(latitude) and !_.isEmpty(longitude)
      @bounds.add(latitude, longitude)

  render: =>
    @map = new MapApp.Map(@cssSelector, @bounds)
    @map.build()