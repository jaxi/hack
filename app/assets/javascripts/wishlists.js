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
});