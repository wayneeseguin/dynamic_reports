// DYNAMIC_REPORTS.JS
// Required javascript include file for jQuery supported subreport display

$(function() {

  $('a.sub_report_link').live('click',
  function() {

      row = $(this).closest('.report_row')

      $(this).closest('table').find('.subreport_row').hide();
      row.show();
      $.ajax({
          url: this.href,
          success: function(response) {
              num_cols = row.find('td').size();
              str = "<tr class='subreport_row'><td colspan='" + num_cols + "' class='subreport'><div class='subreport_close'>[close]</div>" + response + "</td></tr>";
              row.after(str);
          }
      })

      return false;
  })

  $('.subreport_close').live('click',function() {
      $(this).closest('.subreport_row').hide();
  })
  
  $('.subreport_close').live('mouseover',function(){
       $(this).addClass('close-hover');
   }).live('mouseout',function(){
           $(this).removeClass('close-hover');
       })
  
})
