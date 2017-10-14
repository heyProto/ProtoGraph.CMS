function readURL(input) {
  if (input.files && input.files[0]) {
    var reader = new FileReader();
    reader.onload = function (e) {
      if (JCropInstance) {
        JCropInstance.destroy();
        $("#cropbox").attr('src', "");
        $('#cropbox').attr('style', "");
      }
      $(".protograph-new-image").css('display', 'block');
      $('#image_name').val(input.files[0].name.replace(/\.[^/.]+$/, ""));
      $("#cropbox").attr('src', e.target.result);
      $('#cropbox').Jcrop({
        setSelect: [0, 0, 420, 420],
        onSelect: update,
        onChange: update,
        boxHeight: 350,
        boxWidth: 500,
        aspectRatio: ($('#aspectRatioMenu li.item.active').data().width / $('#aspectRatioMenu li.item.active').data().height)
      }, function(){ JCropInstance = this});
    }
    reader.readAsDataURL(input.files[0]);
  } else {
    $("#cropbox").attr('src', "");
    $('#image_name').val("");
  }
};

var gcd = function(a, b) {
  if ( ! b) {
    return a;
  }
  return gcd(b, a % b);
};

function update(coords) {
  if (!$('.jcrop-holder .protograph-crop-tooltip').length) {
    $('.jcrop-holder').append('<div class="protograph-crop-tooltip"></div>');
  }

  $('#image_crop_x').val(coords.x);
  $('#image_crop_y').val(coords.y);
  $('#image_crop_w').val(coords.w);
  $('#image_crop_h').val(coords.h);

  if ($('#new_image_submit_button').hasClass('protograph-disabled-button')) {
    $('#new_image_submit_button').removeClass('protograph-disabled-button');
  }

  var str = "",
    width = Math.round(coords.w),
    height = Math.round(coords.h),
    aspectWidth = width / gcd(width, height),
    aspectHeight = height / gcd(width, height);

  if (coords.w > 0 && coords.h > 0) {
    str += (width + ' x ' + height);
    str += "  ";
    str += ('(' + Math.round(aspectWidth) + ':' + Math.round(aspectHeight) + ')');
  } else {
    str += ( width + ' x ' + height);
  }

  $('.protograph-crop-tooltip').html(str);
};

$(document).ready(function () {
  $('#aspectRatioMenu li.item').on('click', function (e) {
    if ($(this).attr("disabled") === "disabled"){
      return false;
    }
    var ref = $(this),
      data,
      aspectRatio;

    ref
      .addClass('active')
      .siblings('.item')
        .removeClass('active');

    data = ref.data();
    if (data.height > 0 && data.width > 0) {
      aspectRatio = data.width / data.height;
    } else {
      aspectRatio = 0;
    }

    $('#cropbox').Jcrop({
      setSelect: [0, 0, 420, 420],
      onSelect: update,
      onChange: update,
      boxHeight: 350,
      boxWidth: 500,
      aspectRatio: aspectRatio
    },function(){ JCropInstance = this});

    e.preventDefault();
  });

  $('#new_image').submit(function () {
    $('#ui_dimmer').addClass('active');
    return true;
  });

  $("#new_image").on('ajax:success', function (e, data, status, xhr) {
    var resonse = e.detail[0];
    $('#image_url_container').css('display', "block");
    $('#photo_url').val(resonse.data.image_url);
    $('#photo_url').focus();
    $('#photo_url').select();
    $('#ui_dimmer').removeClass('active');
  }).on('ajax:error', function (e, xhr, status, error) {
    var resonse = e.detail[0];
    showAllValidationErrors(resonse.errors);
    $('#ui_dimmer').removeClass('active');
    $('#image_url_container').css('display', "block");
  });

  $('#protograph_image_bank_button').on('click', function () {
    $('#new_image')[0].reset();
    $('#image_url_container').css('display', "none");
    if (JCropInstance) {
      JCropInstance.destroy();
    }
    $('#aspectRatioMenu li.item.active').removeClass('active');
    $('#aspectRatioMenu li.item:first').addClass('active');
    $('#image_container').css('display', 'none');
  });
});