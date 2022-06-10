// select用ajax
function staffShiftList(day, staff_id) {
  var result = $.ajax({
    url: '/api/staff_shift_model_list',
    type: 'GET',
    dataType: 'json',
    data: { 'start_at': day, 'staff_id': staff_id},
    async: false,
  }).responseJSON;
  return result;
};

const myModal = document.getElementById('exampleModal')

const modalFieldHTML = (wday_num, wday, day, date, staff_id) => `
  <table>
    <thead>
      <tr>
        <th>${wday}</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td class="day wday-${wday_num} start-date current-month h-100">
          <div class="inner pb-2">
            <div class="text-black-50 mb-4">${day}</div>
            <div class="m-0 mb-2">
              ${staffShiftList(date, staff_id).map(model => `
                  <a class="btn btn-outline-info mb-2 rounded p-1 mx-2" href="/staff_shifts/bulk_input?&staff_id=${model.staff_id}&start_date=${model.start_date}" style="text-decoration: none; display: block;">${model.staff_name}<br>${model.start_end}</a>
              `).join("")}
            </div>
          </div>
        </td>
      </tr>
    </tbody>
  </table>
`;

myModal.addEventListener('hidden.bs.modal', (event) => {
  $('.target').children().remove();
})

myModal.addEventListener('shown.bs.modal', (event) => {
  var button = $(event.relatedTarget);
  var day = button.data('day');
  var wday_num = button.data('wdayNum');
  var wday = button.data('wday');
  var date = button.data('date');
  var staff_id = button.data('staff');
  
  //Ajaxの処理はここに
  $('.target').children().remove();
  $('.target').append(modalFieldHTML(wday_num, wday, day, date, staff_id));
})
