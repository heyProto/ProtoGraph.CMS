$(document).on('turbolinks:load', function (e) {
    $("input:file").on('change', function() {
      if (validate_file($(this)[0].files[0].type, $(this).attr("accept"))) {
        $(this).parents('form').submit();
      } else {
        generate_notify({text: `Invalid file type.`, notify: "error"})
        return false;
      }
    });

    $(".browse_file").on('click', function(event){
      $(this).siblings('div.file').children("input").click();
      event.preventDefault();
    });
  });
  var validate_file = function(file_type, accepted_type) {
    return (accepted_type.split(",").indexOf(file_type) >= 0)
  }