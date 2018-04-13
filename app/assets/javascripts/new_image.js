 $(document).on('turbolinks:load', function() {
    // Init ColorThief
    var colorThief = new ColorThief(),
      jCropInstance;

    $( "#new_image" ).submit(function( event ) {
      var img = $("#preview_image")[0];
      if(img){
          dom_colour = colorThief.getColor(img)
          $("#image_dominant_colour").val(JSON.stringify(dom_colour))
          pal_colours = colorThief.getPalette(img)
          $("#image_colour_palette").val(JSON.stringify(pal_colours))
      }
    });

    var gcd = function(a, b) {
      if (!b) return a;
      return gcd(b, a % b);
    };

    var updateCropCoords = function (coords) {
      $('#image_crop_x').val(coords.x);
      $('#image_crop_y').val(coords.y);
      $('#image_crop_w').val(coords.w);
      $('#image_crop_h').val(coords.h);
      updateTooltip(coords);
    }

    var validateFile = function (file) {
      let valid_files = [ "image/png", "image/jpeg" ];
      if (file.size <= 512000 && (valid_files.indexOf(file.type) >= 0)) return true;
      return false;
    }

    var resetDefaults = function () {
      if (jCropInstance) jCropInstance.destroy();
      $(".proto-invalid-image, .proto-image-loader").css('display', 'none');
      $("#proto_image_bank_create_image").removeClass("proto-disable-item");
      $("#preview_image").attr('src', "");
      $('#image_name').val("");
    }

    var updateTooltip = function (coords) {
      var str = "",
          width = Math.round(coords.w),
          height = Math.round(coords.h),
          aspectWidth = width / gcd(width, height),
          aspectHeight = height / gcd(width, height);

      if (!$('#new_image .jcrop-holder .protograph-crop-tooltip').length) {
        $('#new_image .jcrop-holder').append('<div class="protograph-crop-tooltip"></div>');
      }

      if (coords.w > 0 && coords.h > 0) {
        str += (width + ' x ' + height);
        str += "  ";
        str += ('(' + Math.round(aspectWidth) + ':' + Math.round(aspectHeight) + ')');
      } else {
        str += ( width + ' x ' + height);
      }

      $('.protograph-crop-tooltip').html(str);
    };

    var readURL = function (input) {
      $("#proto_image_bank_create_image").addClass("proto-disable-item")
      if (input.files && input.files[0] && validateFile(input.files[0])) {
        $(".proto-image-loader").css('display', 'block');
        var reader = new FileReader();
        reader.onload = function (e) {
          $('#image_name').val(input.files[0].name.replace(/\.[^/.]+$/, ""));
          var image = new Image();
          image.src = e.target.result;
          image.onload = function () {
            var width = this.naturalWidth,
              height = this.naturalHeight;

            $('#image_image_w').val(width);
            $('#image_image_h').val(height);

            if (<%= @site.is_smart_crop_enabled %>) {
              // Fire the API to get smart croped coordinates.
              $('#proto_image_bank_image_field').addClass('proto-disable-item');
              $.ajax({
                url: "/api/v1/smartcrop",
                method: "post",
                headers: {
                  "Content-Type": "application/json"
                },
                data: JSON.stringify({
                  image_blob: e.target.result,
                  crop_options: { width: 1260, height: 756}
                })
              }).done(function(response) {
                let data = response.message.data;
                $(".proto-image-loader").css('display', 'none');
                $("#preview_image").attr('src', e.target.result);
                $("#proto_image_bank_create_image, #proto_image_bank_image_field").removeClass("proto-disable-item");
                $('#preview_image').Jcrop({
                  setSelect: [data.x, data.y, (data.x + data.width), (data.y + data.height)],
                  onSelect: updateCropCoords,
                  onChange: updateCropCoords,
                  boxHeight: height,
                  boxWidth: width,
                  trueSize: [width, height],
                  aspectRatio: (data.width/data.height)
                }, function () {
                  jCropInstance = this;
                });
              }).fail(function(xhr) {
                $(".proto-image-loader").css('display', 'none');
                $(".proto-invalid-image").html("Error smart cropping the image. Try uploading the image again.");
                $(".proto-invalid-image").css('display', 'block');
                $('#proto_image_bank_image_field').removeClass('proto-disable-item');
              });
            } else {
              // If not then check the aspect ratio of the image.
              if ((width % 5 === 0) && (height % 3 === 0)) {
                // Show the preview and allow to upload.
                $(".proto-image-loader").css('display', 'none');
                $("#preview_image").attr('src', e.target.result);
                $("#proto_image_bank_create_image").removeClass("proto-disable-item");
              } else {
                $(".proto-image-loader").css('display', 'none');
                $("#preview_image").attr('src', e.target.result);
                $('#preview_image').Jcrop({
                  setSelect: [0, 0, 1260, 430],
                  onSelect: updateCropCoords,
                  onChange: updateCropCoords,
                  boxHeight: height,
                  boxWidth: width,
                  trueSize: [width, height],
                  aspectRatio: 5/3
                }, function () {
                  jCropInstance = this;
                });
                // Show the cropper with 5:3 selected.
              }
            }
            return true;
          };
        }
        reader.readAsDataURL(input.files[0]);
      } else {
        resetDefaults();
        $(".proto-invalid-image").css('display', 'block');
      }
    };

    //On Change of file input.
    $("#proto_image_bank_image_field").on("change", function (event) {
      resetDefaults();
      readURL(this)
    });
 });