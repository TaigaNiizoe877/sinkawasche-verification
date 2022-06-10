// 新規作成と編集画面でのボタン
$(document).ready(function() {
  $("#top_submit_btn").click(function(e){
    $('#submit_btn').trigger('click');
  })
});