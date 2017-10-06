function generate_notify(config) {

  if (!config.text) {
    config.text = "Oops something went wrong.";
  }
  if (!config.notify) {
    config.notify = "success";
  }

  if (!config.position) {
    config.position = "bottomRight";
    //top - topLeft - topCenter - topRight - center - centerLeft - centerRight - bottom - bottomLeft - bottomCenter - bottomRight
  }
  if(!config.timeout){
    config.timeout = 3000;
  }

  $.noty.closeAll();
  var n = noty({
      text        : config.text,
      type        : config.notify,
      dismissQueue: false,
      closeWith   : ['click','timeout'],
      maxVisible  : 10,
      layout      : config.position,
      theme       : 'defaultTheme',
      timeout     : config.timeout,
      animation: {
        open: {height: 'toggle'},
        close: {height: 'toggle'},
        easing: 'swing',
        speed: 1000
    },
  });
  return n;
}

function showAllValidationErrors(errors) {
  var con = { notify: "error"};
  $.noty.closeAll();
  switch(errors.constructor) {
    case Array:
      for (var i = 0; i < errors.length; i++) {
        con.text = errors[i];
        generate_notify(con);
      }
      break;
    case Object:
      for (i in errors) {
        con.text = errors[i];
        generate_notify(con);
      }
      break;
    case String:
      con.text = errors;
      generate_notify(con);
      break;
  }
}