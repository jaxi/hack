$(function(){

  function pollingCharge(){
    var uncompleted = $.map($('.uncompleted'),
      function(value, index){
        return $(value).data('id');
      });
    if(uncompleted.length > 0){
      $.post("/wishlists/polling_charge/", { uncompleted: uncompleted}, function(result){
        $.map(result, function(content, index){
          $("#uncompleted-" + content.id).replaceWith(content.html);
        });
      });
    }
  };

  setInterval(pollingCharge, 5000);

  $('.container').on('click', '.tell-me-ical', function(e){
    console.log("yes");
    e.preventDefault();
    var ical = $(this).data('secret');
    $(this).closest("div").replaceWith('<div class="alert alert-warning fade in">'
      + '<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>Here it is '
      + '<a href="' + ical + '">' + ical + '</a>'
      + ' You should really keep it secret!</div>');
  });
});