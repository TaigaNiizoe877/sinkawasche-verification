$(function() {
  changeMenuField();
  addMenuField();
  deleteMenuField();
});

// select用ajax
function carSizeData() {
  var result = $.ajax({
    url: '/api/car_size_list',
    type: 'GET',
    dataType: 'json',
    async: false,
  }).responseJSON;
  return result;
};

function carMakerData() {
  var result = $.ajax({
    url: '/api/car_maker_list',
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

const selectMenuHTML = (menuCount) => `
  <div class="card shadow rounded js-childTarget mt-1">
    <div class="card-header bg-white border-bottom border-info">
      <div class="card-title d-inline-flex flex-row align-items-center mt-2">
        <i class="bi bi-check2-square fs-6 text-success me-1"></i>
        <span class="text-dark fst-italic fs-5" style="text-shadow: 1px 1px 2px orange">車のサイズ、車種</span>
      </div>
    </div>
    <div class="card-body">
      <div class="mb-4">
        <label class="fst-italic fw-bold text-dark border-bottom border-warning mb-2">
          車のサイズを選択してください
          <span class="text-danger ms-2">※必須</span>
          <br>
          <a class="link-info" data-bs-target="#sizeModal" data-bs-toggle="modal" type="button">サイズについてはこちら</a>
        </label>
        <div class="form-group mt-2 row">
          ${carSizeData().map((size, index) => `
            <div class="mb-1">
              <input class="form-check-input shadow-sm me-1 mb-1 js-changeSize" type="radio" value="${size[0]}" ${index == 0 ? "checked='checked'" : ''} name="reservation[${menuCount}][car_size_id]" id="reservation_${menuCount}_car_size_id_${size[0]}">
              <label class="form-check-label text-uppercase me-2" for="reservation_${menuCount}_car_size_id_${size[0]}">${size[1]}</label>
            </div>
          `).join("")}
        </div>
      </div>
      <div class="mb-4">
        <label class="fst-italic fw-bold text-dark border-bottom border-warning mb-2">車種を選択してください</label>
        <div class="row row-cols-1 row-cols-md-4">
          <div class="col-md-4 me-1">
            <select class="form-select shadow-sm mt-2 js-changeMaker" name="reservation[${menuCount}][car_maker_id]" id="reservation_${menuCount}_car_maker_id">
              <option value="">選択してください</option>
              ${carMakerData().map(maker => `
                <option value="${maker[0]}">${maker[1]}</option>
              `).join("")}
            </select>
          </div>
          <div class="col-md-4 me-1">
            <select class="form-select shadow-sm mt-2 js-changeModel" name="reservation[${menuCount}][car_model_id]" id="reservation_${menuCount}_car_model_id">
              <option value="">選択してください</option>
              ${carModelData().map(model => `
                <option value="${model[0]}">${model[1]}</option>
              `).join("")}
            </select>
          </div>
        </div>
      </div>
      <div class="mb-2">
        <label class="fst-italic fw-bold text-dark border-bottom border-warning mb-2">お持ちの車が見当たらない場合はこちらへ入力してください（わかる方のみ）</label>
        <div class="row mt-2">
          <div class="form-group col-md-8">
            <input class="form-control shadow-sm" type="text" name="reservation[${menuCount}][car_model_name]" id="reservation_${menuCount}_car_model_name">
          </div>
        </div>
      </div>
    </div>
    <div class="card-header bg-white border-bottom border-info">
      <div class="card-title d-inline-flex flex-row align-items-center mt-2">
        <i class="bi bi-check2-square fs-6 text-success me-1"></i>
        <span class="text-dark fst-italic fs-5" style="text-shadow: 1px 1px 2px orange">ご希望のメニュー</span>
        <div class="p-form__selectedFields"></div>
      </div>
    </div>
    <div class="card-body">
      <div class="mb-4">
        <label class="fst-italic fw-bold text-dark border-bottom border-warning mb-2">
          洗車メニューを選択してください
          <span class="text-danger ms-2">※必須</span>
        <br>
        <a class="link-info" data-bs-target="#menuModal" data-bs-toggle="modal" type="button">メニュー詳細はこちら</a>
        </label>
        <div class="form-group ms-2 mt-2">
          <div class="js-changeMenuField row">
            ${menuAndOptionData(1)[0]['wash_menu'].map((menu, index) => `
              <div class="p-0">
                <input class="form-check-input shadow-sm mx-1 mb-1" type="radio" value="${menu.id}" ${index == "0" ? "checked='checked'" : ''} name="reservation[${menuCount}][car_wash_menu_id]" id="reservation_${menuCount}_car_wash_menu_id_${menu.id}">
                <label class="form-check-label p-0" for="reservation_${menuCount}_car_wash_menu_id_${menu.id}">${menu.name + " (¥" + menu.price.toLocaleString() + ")"}</label>
              </div>
              <div class="mx-2 mb-1">
                <span>${menu.memo ? menu.memo : ""}</span>
              </div>
            `).join("")}
          </div>
        </div>
      </div>
      <div class="mb-4">
        <label class="fst-italic fw-bold text-dark border-bottom border-warning mb-2">オプションメニューを選択してください</label>
        <br>
        <a class="link-info" data-bs-target="#optionModal" data-bs-toggle="modal" type="button">オプション詳細はこちら</a>
        <div class="form-group ms-2 mt-2">
          <div class="js-changeOptionField row">
            ${menuAndOptionData(1)[0]['wash_option'].map((option, index) => `
              <div class="p-0">
                <input class="form-check-input shadow-sm mx-1 mb-1" type="checkbox" value="${option.id}" name="reservation[${menuCount}][car_wash_option_ids][${index}][id]" id="reservation_${menuCount}_car_wash_option_id_${option.id}">
                <label class="form-check-label p-0" for="reservation_${menuCount}_car_wash_option_id_${option.id}">${option.name + " (¥" + option.price.toLocaleString() + ")"}</label>
              </div>
              <div class="mx-2 mb-1">
                <span>${option.memo ? option.memo : ""}</span>
              </div>
            `).join("")}
          </div>
        </div>
      </div>
      <div class="mb-2">
        <label class="fst-italic fw-bold text-dark border-bottom border-warning">追加はこちらからしてください</label>
        <div class="btn ms-2 js-addMenuField"><i class="bi bi-plus-square text-primary fs-4"></i></div>
        <div class="btn js-deleteMenuField"><i class="bi bi-dash-square text-secondary fs-4"></i></div>
      </div>
    </div>
  </div>
`;

const modelFieldHTML = (carMakerId) => `
  <option value="">選択してください</option>
  ${carModelData(carMakerId).map(model => `
    <option value="${model[0]}">${model[1]}</option>
  `).join("")}
`;

const menuFieldHTML = (menuCount, carSizeId) => `
  ${menuAndOptionData(carSizeId)[0]['wash_menu'].map((menu, index) => `
    <div class="p-0">
      <input class="form-check-input shadow-sm mx-1 mb-1" type="radio" value="${menu.id}" ${index == "0" ? "checked='checked'" : ''} name="reservation[${menuCount}][car_wash_menu_id]" id="reservation_${menuCount}_car_wash_menu_id_${menu.id}">
      <label class="form-check-label p-0" for="reservation_${menuCount}_car_wash_menu_id_${menu.id}">${menu.name + " (¥" + menu.price.toLocaleString() + ")"}</label>
    </div>
    <div class="mx-2 mb-1">
      <span>${menu.memo ? menu.memo : ""}</span>
    </div>
  `).join("")}
`;

const optionFieldHTML = (menuCount, carSizeId) => `
  ${menuAndOptionData(carSizeId)[0]['wash_option'].map((option, index) => `
    <div class="p-0">
      <input class="form-check-input shadow-sm mx-1 mb-1" type="checkbox" value="${option.id}" name="reservation[${menuCount}][car_wash_option_ids][${index}][id]" id="reservation_${menuCount}_car_wash_option_id_${option.id}">
      <label class="form-check-label p-0" for="reservation_${menuCount}_car_wash_option_id_${option.id}">${option.name + " (¥" + option.price.toLocaleString() + ")"}</label>
    </div>
    <div class="mx-2 mb-1">
      <span>${option.memo ? option.memo : ""}</span>
    </div>
  `).join("")}
`;

function changeMenuField() {
  // maker変更時にcarModelを変更する
  $(".js-changeMaker").on("change", function(e) {
    $(this).parents(".js-childTarget").find(".js-changeModel").children().remove();
    $(this).parents(".js-childTarget").find(".js-changeModel").append(modelFieldHTML(e.target.value));
  });

  // size変更時にmenu&optionを変更する
  $(".js-changeSize").on("change", function(e) {
    var menuNumber = $(".js-parentTarget").find(".js-childTarget").length;
    $(this).parents(".js-childTarget").find(".js-changeMenuField").children().remove();
    $(this).parents(".js-childTarget").find(".js-changeOptionField").children().remove();
    $(this).parents(".js-childTarget").find(".js-changeMenuField").append(menuFieldHTML(menuNumber, e.target.value));
    $(this).parents(".js-childTarget").find(".js-changeOptionField").append(optionFieldHTML(menuNumber, e.target.value));
  });
};

// selectMenu追加
function addMenuField() {
  $(".js-addMenuField").off("click");
  $(".js-addMenuField").on("click", function() {
    var menuNumber = $(".js-parentTarget").find(".js-childTarget").length + 1;
    $(this).parents(".js-childTarget").after(selectMenuHTML(menuNumber));
    $(".js-parentTarget").find(".js-deleteMenuField").prop("disabled", false);
    changeMenuField();
    addMenuField();
    deleteMenuField();
  });
}
// selectMenu削除
function deleteMenuField() {
  $(".js-deleteMenuField").on("click", function() {
    var menuNumber = $(".js-parentTarget").find(".js-childTarget").length;
    if (menuNumber > "1") {
      $(this).parents(".js-childTarget").remove();
    }
  });
}