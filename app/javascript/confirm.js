$(".js-consent").on("change", function() {
  if ($(".js-consent").prop('checked') === true) {
    $('.disabled_button').removeClass('disabled');
  } else {
    $('.disabled_button').addClass('disabled');
  }
});
