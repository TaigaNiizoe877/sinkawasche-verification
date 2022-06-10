$(function() {
  changeMenuField();
  addMenuField();
  deleteMenuField();

  // $(".js-changeCustomer").on("change", function(e){
  //   $(".js-changeWorkingLocation").children().remove();
  //   $.ajax({
  //     url: '/api/working_location',
  //     type: 'GET',
  //     dataType: 'json',
  //     data: { customer_id: e.target.value },
  //   }).done(function(data){
  //     $(".js-changeWorkingLocation").append(`
  //       <option>選択してください</option>
  //       ${data.map(location => `
  //         <option value=${location.id}>${location.prefecture}${location.address_first}${location.address_second}(${location.building})</option>
  //       `).join("")}
  //     `);
  //   });
  // });

  $(".js-changeDatetime").on("change", function(){
    $(".js-changeOptions").children().remove();
    var res_id = $(".js-getId").val();
    var workingLocation = $(".js-getWorkingLocation").val();
    var startAt = $(".js-getStartAt").val();
    var endAt = $(".js-getEndAt").val();
    $.ajax({
      url: '/api/assignable_staff_list',
      type: 'GET',
      dataType: 'json',
      data: { start_at: startAt, end_at: endAt, working_location_id: workingLocation, res_id: res_id },
    }).done(function(data) {
      $(".js-changeOptions").append(`
        <option>選択してください</option>
        ${data.map(staff => 
          `<option value=${staff.id}>${staff.family_name} ${staff.name}</option>`
        ).join("")}
      `)
    })
  });

  $(".js-autoCulcFlag").on("change", function(){
    if ($(this).val() == "true"){
      $(".js-toggleReadOnly").attr("readonly", true);
    } else {
      $(".js-toggleReadOnly").attr("readonly", false);
    };
  });
});

function carSizeData() {
  var result = $.ajax({
    url: '/api/car_size_list',
    type: 'GET',
    dataType: 'json',
    async: false,
  }).responseJSON;
  return result;
};

function carModelData(carMakerId) {
  var result = $.ajax({
    url: '/api/car_model_list',
    type: 'GET',
    dataType: 'json',
    data: { 'car_maker_id': carMakerId },
    async: false,
  }).responseJSON;
  return result;
};

function menuAndOptionData(carSizeId) {
  var result = $.ajax({
    url: '/api/menu_and_option_list',
    type: 'GET',
    dataType: 'json',
    data: { 'car_size_id': carSizeId },
    async: false,
  }).responseJSON;
  return result;
};

const reservationMenuHTML = (menuCount, visibleMenuCount) => `
  <div class="card col-sm-12 shadow p-3 mb-2 bg-body rounded js-parentTarget">
    <div class="card-header bg-white border-bottom">
      <div class="card-title d-inline-flex flex-row align-items-center mt-2">
        <span class="js-changeText text-dark fs-4">予約車${visibleMenuCount + 1}台目</span>
        <input type="hidden" class="js-infoDestroyFlag" value="0" name="reservation[reservation_infos_attributes][${menuCount + 1}][_destroy]">
        <input type="hidden" class="js-carCount" value=${menuCount + 1}>
      </div>
    </div>
    <div class="card-body fs-6 ps-5">
      <div class="col-sm-6 pb-2">
        <label class="pb-2">車サイズ</label>
        <div class="form-radio">
          ${carSizeData().map((size, index) => `
            <input type="radio" class="form-check-input shadow-sm mx-1 mb-1 js-changeSize" value=${size[0]} ${index == 0 ? "checked='checked'" : ""} name="reservation[reservation_infos_attributes][${menuCount + 1}][car_size_id]" id="reservation[reservation_infos_attributes][${menuCount + 1}][car_size_id][${size[0]}]">
            <label class="form-check-label text-uppercase pe-2" for="reservation[reservation_infos_attributes][${menuCount + 1}][car_size_id][${size[0]}]">${size[1]}</label>
          `).join("")}
        </div>
      </div>
      <div class="col-sm-6 pb-2">
        <label class="pb-2">洗車コース</label>
        <div class="form-radio js-changeMenuField">
          ${menuAndOptionData(1)[0]['wash_menu'].map((menu, index) => `
            <div class="js-toggleShow">
              <input type="radio" class="form-check-input shadow-sm mx-1 mb-1 js-toggleDisabled" value=${menu.id} ${index == 0 ? "checked='checked'" : ""} name="reservation[reservation_infos_attributes][${menuCount + 1}][car_wash_menu_id]" id="reservation[reservation_infos_attributes][${menuCount + 1}][car_wash_menu_id][${menu.id}]">
              <label class="form-check-label text-uppercase pe-2" for="reservation[reservation_infos_attributes][${menuCount + 1}][car_wash_menu_id][${menu.id}]">${menu.name}/¥${menu.price.toLocaleString()}</label>
            </div>
          `).join("")}
        </div>
      </div>
      <div class="col-sm-6 pb-2">
        <label class="pb-2">車種名</label>
        <input class="form-control" name="reservation[reservation_infos_attributes][${menuCount + 1}][car_model_name]">
      </div>
      <div class="col-sm-8 pb-2">
        <label class="pb-2">洗車オプション</label>
        <div class="form-checkbox js-changeOptionField">
          ${menuAndOptionData(1)[0]['wash_option'].map((option, index) => `
            <div class="js-toggleShow">
              <input type="hidden" class="js-destroyFlag" value="0" name="reservation[reservation_infos_attributes][${menuCount + 1}][reservation_car_wash_options_attributes][${index}][_destroy]">
              <input type="checkbox" class="form-check-input shadow-sm mx-1 mb-1 js-optionCount" value=${option.id} ${index == 0 ? "checked='checked'" : ""} name="reservation[reservation_infos_attributes][${menuCount + 1}][reservation_car_wash_options_attributes][${index}][car_wash_option_id]" id="reservation[reservation_infos_attributes][${menuCount + 1}][reservation_car_wash_options_attributes][${index}][car_wash_option_id][${option.id}]">
              <label class="form-check-label text-uppercase pe-2" for="reservation[reservation_infos_attributes][${menuCount + 1}][reservation_car_wash_options_attributes][${index}][car_wash_option_id][${option.id}]">${option.name}/¥${option.price.toLocaleString()}</label>
            </div>
          `).join("")}
        </div>
      </div>
      <div class="d-flex justify-content-end pt-1">
        <div class="btn js-addMenuField">
          <i class="bi bi-plus-square text-primary fs-2"></i>
        </div>
        <div class="btn js-deleteMenuField">
          <i class="bi bi-dash-square text-secondary fs-2"></i>
        </div>
      </div>
    </div>
  </div>
`;

const menuFieldHTML = (carNum, carSizeId) => `
  ${menuAndOptionData(carSizeId)[0]['wash_menu'].map((menu, index) => `
    <div class="js-toggleShow">
      <input class="form-check-input js-toggleDisabled shadow-sm mx-1 mb-1" type="radio" value="${menu.id}" ${index == "0" ? "checked='checked'" : ''} name="reservation[reservation_infos_attributes][${carNum}][car_wash_menu_id]" id=reservation[reservation_infos_attributes][${carNum}][car_wash_menu_id][${menu.id}]">
      <label class="form-check-label pe-2" for="reservation[reservation_infos_attributes][${carNum}][car_wash_menu_id][${menu.id}]">${menu.name + "/¥" + menu.price.toLocaleString()}</label>
    </div>
  `).join("")}
`;

const optionFieldHTML = (carNum, optionNum, carSizeId) => `
  ${menuAndOptionData(carSizeId)[0]['wash_option'].map((option, index) => `
    <div class="js-toggleShow">
      <input type="hidden" value="0" class="js-destroyFlag" name="reservation[reservation_infos_attributes][${carNum}][reservation_car_wash_options_attributes][${optionNum + index}][_destroy]">
      <input class="form-check-input shadow-sm mx-1 mb-1 js-optionCount" type="checkbox" value="${option.id}" name="reservation[reservation_infos_attributes][${carNum}][reservation_car_wash_options_attributes][${optionNum + index}][car_wash_option_id]" id="reservation[reservation_infos_attributes][${carNum}][reservation_car_wash_options_attributes][${optionNum + index}][car_wash_option_id][${option.id}]">
      <label class="form-check-label pe-2" for="reservation[reservation_infos_attributes][${carNum}][reservation_car_wash_options_attributes][${optionNum + index}][car_wash_option_id][${option.id}]">${option.name + "/¥" + option.price.toLocaleString()}</label>
    </div>
  `).join("")}
`;

function changeMenuField() {
  // size変更時にmenu&optionを変更する
  $(".js-changeSize").on("change", function(e) {
    var carNum = $(this).parents(".js-parentTarget").find(".js-carCount").val();
    var optionNum = $(this).parents(".js-parentTarget").find(".js-optionCount").length + 1;
    $(this).parents(".js-parentTarget").find(".js-toggleShow").each(function(){ $(this).children().hide() });
    $(this).parents(".js-parentTarget").find(".js-destroyFlag").each(function(){ $(this).val("1") });
    $(this).parents(".js-parentTarget").find(".js-toggleDisabled").each(function(){ $(this).prop("disabled", true)});
    $(this).parents(".js-parentTarget").find(".js-changeMenuField").append(menuFieldHTML(carNum, e.target.value));
    $(this).parents(".js-parentTarget").find(".js-changeOptionField").append(optionFieldHTML(carNum, optionNum, e.target.value));
  });
};

function addMenuField() {
  $(".js-addMenuField").off("click");
  $(".js-addMenuField").on("click", function() {
    var allCarNum = $(".js-parentTarget").length;
    var visibleCarNum = $(".js-parentTarget:visible").length;
    $(this).parents(".js-parentTarget").after(reservationMenuHTML(allCarNum, visibleCarNum));
    $(".js-parentTarget").find(".js-deleteMenuField").prop("disabled", false);
    $(".js-parentTarget:visible").find(".js-changeText").each(function(index){
      $(this).text(`予約車${index + 1}台目`);
    });
    changeMenuField();
    addMenuField();
    deleteMenuField();
  });
};

function deleteMenuField() {
  $(".js-deleteMenuField").on("click", function() {
    var visibleCarNum = $(".js-parentTarget:visible").length;
    if (visibleCarNum > "1") {
      $(this).parents(".js-parentTarget").hide();
      $(this).parents(".js-parentTarget").find(".js-infoDestroyFlag").each(function(){
        $(this).val("1");
      });
      $(".js-parentTarget:visible").find(".js-changeText").each(function(index){
        $(this).text(`予約車${index + 1}台目`);
      });
    };
  });
};