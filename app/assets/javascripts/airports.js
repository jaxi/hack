$(function(){

  $('.container .input-group.date').datepicker({
    startDate: $.datepicker.formatDate('yyyy-mm-dd', new Date()),
    format: "yyyy-mm-dd",
    autoclose: true,
    todayHighlight: true
  });

  $(".container").on('click', '.wishlist', function(e){
    e.preventDefault();

    var form = $(this).closest('form');
    var queries = $.map( form.find('.search-query'), function( query, index ) {
      return $(query).val();
    }).filter(function(q){
      return q != ""
    });

    var name = form.find('#name').val();
    var start_at = form.find('#start_at').val();

    $.post("/wishlists", {
      cities: queries,
      name: name,
      start_at: start_at
    });
  });

  $(".search-form-group").sortable({
    update: function(){
      console.log('updated!');
    }
  });

  $("a.clear-text").on('click', function(e){
    e.preventDefault();
    $(this).closest('.input-group').find('input').val('');
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