$(function(){

  $(".search-form-group").sortable({
    update: function(){
      console.log('updated!');
    }
  });

  $("a.clear-text").on('click', function(e){
    e.preventDefault();
    $(this).closest('.input-group').find('#query').val('');
  });

  $(".search-query").typeahead({
    source: function(query, process){
      return $.get('/airports/autocomplete',
        {query: query}, function(data){
          return process(data.result);
        });
    }
  });
});