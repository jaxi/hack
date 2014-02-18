$(function(){

  $(".search-query").typeahead({
    source: function(query, process){
      return $.get('/airports/autocomplete',
        {query: $(".search-query").val()}, function(data){
          result = $.map( data, function( val, i ) {
            return val.airport_name + " Airport, " + val.city_name;
          });
          return process(result);
        });
    }
  });
});