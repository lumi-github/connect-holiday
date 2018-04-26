function update_pref(val, controller_name)
{
    console.log("enter update_pref value is");
    console.log(val);
    
    if (controller_name == 'event') {
      $.ajax({
        type: "POST",
        url: "/events/change_prefecture",
        data: {pref_id: val, controller_name: controller_name},
  //      success: function(data) {
  //        alert("success");
  //        return true;
  //      },
        error: function(data) {
          alert("errror");
          return false;
        }
      });
    } else {
      $.ajax({
        type: "POST",
        url: "/users/change_prefecture",
        data: {pref_id: val, controller_name: controller_name},
  //      success: function(data) {
  //        alert("success");
  //        return true;
  //      },
        error: function(data) {
          alert("errror");
          return false;
        }
      });      
    }
}