
jQuery( document ).ready(function() {

});

jQuery('input#company_subdomain').focus();
var jSubmit = jQuery('form input[type=submit]');
disable_password_field();
jQuery('#company_owner_attributes_email').focus(function () {
    //alert(jQuery('#company_owner_attributes_login').val());
  if (jQuery('#company_owner_attributes_login').val() == ""){
    disable_password_field();
      //alert('hi');
  }
  else{
    enable_password_field();
      //alert('hi');
  }
});
jQuery("#company_owner_attributes_password").passStrengthener(
{
  userid: "#company_owner_attributes_login",
  strengthCallback:function(score, strength){
  }
});
function disable_password_field()
{
  jQuery("#company_owner_attributes_password").attr('disabled', 'disabled');
  jQuery("#company_owner_attributes_password_confirmation").attr('disabled', 'disabled');
}
function enable_password_field()
{
  jQuery("#company_owner_attributes_password").removeAttr('disabled');
  jQuery("#company_owner_attributes_password_confirmation").removeAttr('disabled');
}