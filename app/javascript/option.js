$(function () {
  $('.option').on('keyup', function (e) {
    console.log('aaaa');
    var name = $.trim($(this).val());
    $.ajax({
      type: 'GET',
      url: '/api/car_wash_option_search',
      data:  { name: name },
      dataType: 'json'
    }).done(function (data) {
      $('.js-options li').remove();
      $(data).each(function(i,option) {
        $('.js-options').append(`
          <li>${option.name}</li>
        `);
      });
    })
  });
});