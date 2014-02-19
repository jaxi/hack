class @MapApp.CurrentLocation
  @DEFAULT_LOCATION = 'Edinburgh, UK'

  constructor: (deferredResolution) ->
    @deferredResolution = deferredResolution || (defer) =>
      navigator.geolocation.getCurrentPosition(
        @_reverseGeocodeLocation(defer), defer.reject
      )

  getLocation: (callback) =>
    successCallback = (value) -> callback(value)
    failureCallback = (value) -> callback(MapApp.CurrentLocation.DEFAULT_LOCATION)

    $.Deferred(@deferredResolution).then(successCallback, failureCallback)

  _reverseGeocodeLocation: (deferred) =>
    (geoposition) =>
      reverseGeocoder = new MapApp.ReverseGeocoder(
        geoposition.coords.latitude,
        geoposition.coords.longitude
      )
      reverseGeocoder.location(deferred)