$(function(){
  console.log("hello world");
  $("#airport-search").typeahead({
    source: function(query, process){
      return $.get('/airports/autocomplete',
        {query: $("#airport-search").val()}, function(data){
          result = $.map( data, function( val, i ) {
            return val.airport_name + " Airport, " + val.city_name;
          });
          return process(result);
        });
    }
  });
});