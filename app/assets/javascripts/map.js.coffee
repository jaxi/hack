class @MapApp.Map
  constructor: (cssSelector, bounds) ->
    @googleMap = new google.maps.Map($(cssSelector)[0], @_mapOptions())
    @bounds = bounds

    $(window).on 'resize', =>
      google.maps.event.trigger(@googleMap, 'resize')
      @_updateCenter()

  build: ->
    @_updateCenter()
    @_plotCoordinates()

  _updateCenter: ->
    # @googleMap.fitBounds @bounds.googleLatLngBounds
    # @googleMap.setCenter @bounds.getCenter()

  _plotCoordinates: ->
    for latLng in @bounds.latLngs
      new google.maps.Marker(position: latLng, map: @googleMap)

  _mapOptions: ->
    zoom: 4
    center: new google.maps.LatLng(52.5167, 13.3833)
    mapTypeId: google.maps.MapTypeId.MAP