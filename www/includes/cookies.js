$(document).on("shiny:connected", function(){
  var newUser = Cookies.get("new_user");
  if(newUser === "false") return;
  Shiny.setInputValue("new_user", true);
  Cookies.set("new_user", false);
});