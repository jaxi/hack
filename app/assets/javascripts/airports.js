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
    var budget = form.find('#budget').val();

    $.post("/wishlists", {
      cities: queries,
      name: name,
      start_at: start_at,
      budget: budget
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
          return process(data);
        });
    }
  });

  $('.search-query').on('focusout', function () {
    var airport = $(this).val();
    var that = $(this);
    $.get('/airports/geocode', {airport: airport}, function(result){
      console.log(result);
      that.data("latitude", result.latitude);
      that.data("longitude", result.longitude);

      var mapper = new MapApp.Mapper('#map');

      $('.search-query').each(function(index, element) {
        mapper.addCoordinates(
          $(element).data('latitude'),
          $(element).data('longitude')
        );
      });

      mapper.render();
    });
  });
});