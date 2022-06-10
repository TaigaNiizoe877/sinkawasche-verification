
$('#copyAddress').on('click', function() {
  const postal_code = $("input[name='w_postal_code']").val();
  const pref = $("input[name='w_prefecture']").val();
  const address_1 = $("input[name='w_address_1']").val();
  const address_2 = $("input[name='w_address_2']").val();
  const building = $("input[name='w_building']").val();
  $("input[name='postal_code']").val(postal_code);
  $("input[name='prefecture']").val(pref);
  $("input[name='address_1']").val(address_1);
  $("input[name='address_2']").val(address_2);
  $("input[name='building']").val(building);
  console.log("building");
});