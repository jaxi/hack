$(function(){

  $("a.clear-text").on('click', function(e){
    e.preventDefault();
    $(this).closest('.input-group').find('#query').val('');
  });

  $(".search-query").typeahead({
    source: function(query, process){
      return $.get('/airports/autocomplete',
        {query: query}, function(data){
          result = $.map( data, function( val, i ) {
            return val.airport_name + " Airport, " + val.city_name;
          });
          return process(result);
        });
    }
  });
});