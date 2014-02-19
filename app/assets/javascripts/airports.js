$(function(){

  $(".container").on('click', '.wishlist', function(e){
    e.preventDefault();
    var form = $(this).closest('form');
    var queries = $.map( form.find('.search-query'), function( query, index ) {
      return $(query).val();
    });
    $.post("/wishlists", { cities: queries }, function(data, event, error){
      console.log(data.wishlist);
    })
  });

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