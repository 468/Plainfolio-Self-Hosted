$(document).on('page:change', function (){
// slidetoggle settings on click

$(".settings-slide").click(function(){
    $(this).closest('.column-content').find('.column-settings').slideToggle();
});

$("#portfolio-settings-btn").click(function(){
    $("#portfolio-settings").slideToggle();
});

// inner slidetoggles for appended forms

$(document).on('click','#edit-portfolio-font',function(){
    $(this).closest('.column-content').find('#portfolio-font-form').slideToggle();
});

$(document).on('click','#password-settings',function(){
    $(this).closest('.column-content').find('#password-settings-form').slideToggle();
});

$(document).on('click','.edit-column-colors',function(){
    $(this).closest('.column-content').find('.column-colors-form').slideToggle();
});

$(document).on('click','#url-settings',function(){
    $(this).closest('.column-content').find('#url-settings-form').slideToggle();
});

$(document).on('click','.edit-entries-per-page',function(){
    $(this).closest('.column-content').find('.entries-per-page-form').slideToggle();
});

$(document).on('click','#output-settings',function(){
    $(this).closest('.column-content').find('#output-settings-form').slideToggle();
});


// init minicolors
$('#portfolio_background_color').minicolors();
$('input[name="column[text_color]"]').minicolors();
$('input[name="column[background_color]"]').minicolors();
$('input[name="tag[text_color]"]').minicolors();
$('input[name="tag[background_color]"]').minicolors();

// show password text box when checkbox checked
$('#portfolio_passworded').change(function() {
    if(this.checked) {
      $('#portfolio-password-form').slideDown();
    }
    else if(!(this.checked)) {
      $('#portfolio-password-form').slideUp();
    }     
});

$('#portfolio_pdf_enabled').change(function() {
    if(this.checked) {
      $('#pdf-button').fadeIn();
    }
    else if(!(this.checked)) {
      $('#pdf-button').fadeOut();
    }     
});

$('#portfolio_rss_enabled').change(function() {
    if(this.checked) {
      $('#rss-button').fadeIn();
    }
    else if(!(this.checked)) {
      $('#rss-button').fadeOut();
    }   
});

// entry dragging and dropping

$('.entry').draggable({
  revert: "invalid" ,
  cancel : 'a',
  containment: 'window',
  helper: function(){
    $copy = $(this).clone();
    $copy.height(100).width(250).css('overflow','hidden').css('border', '1px dotted #111').css('padding', '5px');
    return $copy;},
  appendTo: '.portfolio',
  scroll: false
});

$('.column').droppable({
  hoverClass: "drop-hover",
  accept: '.entry',
  drop: function(event, ui) {
    var entry_title = ui.draggable.attr("id").split(/-(.+)?/)[1];
    var column_id = $(this).attr('id').split('-')[1];
    $.ajax({
      url: window.location.pathname + '/' + entry_title + '/change_column',
      type: 'POST',
      data: { entry: { column: parseInt(column_id) } },
      success: function (response) {
        location.reload(); 
      },
      error: function (response) {
        location.reload(); 
      }
    });
  }
})

});