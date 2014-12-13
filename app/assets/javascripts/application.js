jQuery.noConflict();
jQuery.ajaxSetup({
  'beforeSend':  function(xhr) {
    xhr.setRequestHeader("Accept", "text/javascript")
  }
})

jQuery.fn.submitWithAjax = function() {
  jQuery(this).submit(function() {
    jQuery.post(jQuery(this).attr("action"), jQuery(this).serialize(), null, "script" );
    return false;
  })
};

jQuery(document).ajaxSend(function(event, request, settings) {
  if (typeof(AUTH_TOKEN) == "undefined") return;
  settings.data = settings.data || "";
  settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
});

function set_datepicker(){
  jQuery('input.datebalks').datepicker({
    dateFormat:'dd M yy',
    showOn: "both",
    buttonImage: "/images/calendar.gif",
    buttonImageOnly: true,
    nextText: "",
    prevText: ""
  });
}

jQuery.fn.hide_show = function(){
  if (jQuery(this).is(":checked"))
  {
    jQuery("input#company_pdf_password").parents('li').show();
    jQuery("input#company_default_employee_pdf_password").parents('li').show();
  }
  else
  {
    jQuery("input#company_pdf_password").parents('li').hide();
    jQuery("input#company_default_employee_pdf_password").parents('li').hide();
  }
};

jQuery.fn.tableKeyStrokes = function(options){
  settings = jQuery.extend({
    highlighterclass: 'shortcut-highlight',
    finder: '>td:first, >th:first',
    linkfinder: 'a:first'
  },options);
  table = this.eq(0);
  first_tr = table.children('tbody').children('tr:first');
  first_tr.find(settings.finder).addClass(settings.highlighterclass);
  ftr = first_tr;
  jQuery(document).bind('keydown', 'right', function() {
    if(ftr.next('tr').length > 0) {
      ftr.find(settings.finder).removeClass(settings.highlighterclass);
      ftr = ftr.next();
      ftr.find(settings.finder).addClass(settings.highlighterclass);
    }
  });
  jQuery(document).bind('keydown', 'left', function() {
    if(ftr.prev('tr').length > 0) {
      ftr.find(settings.finder).removeClass(settings.highlighterclass);
      ftr = ftr.prev();
      ftr.find(settings.finder).addClass(settings.highlighterclass);
    }
  });
  jQuery(document).bind('keydown', 'return', function() {
    link = ftr.find(settings.linkfinder);
    if (link.length > 0) {
      window.open(link.eq(0).attr('href'), target = "_self");
    }
  });
};

jQuery(document).ready(
  function()
  {
    alert('hi');
    jQuery('form').highlight();
    jQuery('.flash-msg p span.close a').click(function() {
      jQuery(this).parent().parent().parent().fadeOut('slow');
      return false;
    });
    jQuery('.main-nav').singleDropMenu({
      timer: 1000,
      parentMO: 'ddmenu-hover',
      childMO: 'ddchildhover'
    });
    jQuery('.get_with_ajax').click(function(){
      jQuery.getScript(jQuery(this).attr('href'));
      return false;
    });
    jQuery('input.subdomain').blur(function(){
      var subdomain = jQuery(this).val().toLowerCase();
      jQuery(this).val(subdomain);
      if(subdomain.length == 0){
        jQuery('h4#subdomain').addClass("error");
        jQuery('#subdomain_msg').html("cannot be blank");
        return false;
      }
      else{
        jQuery.getJSON("/accounts/check_subdomain",{
          subdomain: subdomain
        }, function(json) {
          jQuery('h4#subdomain').removeClass();
          jQuery('h4#subdomain').addClass(json.status);
          if (json.status != "available") {
            jQuery('#subdomain_msg').html("is " +json.message)
            jQuery('input.subdomain').focus();
          } else {
            jQuery('#subdomain_msg').html("");
          }
        });
      }
    });
    set_datepicker();

    jQuery('table.list').tableKeyStrokes();

    jQuery(document).bind('keydown',
                          {combi:'H', disableInInput: true},
                          function() {
        jQuery("#shortkeys_help").show();
      }
    );
  if(shortcuts != undefined){
    jQuery.each(shortcuts,function(i, val){
      jQuery(document).bind('keydown',{
        combi: i,
        disableInInput: true
      }, function() {
        window.open(val[0], target = "_self");
      });
    });
    }
    jQuery('ul.droptrue').sortable({
      connectWith: 'ul',
      items: 'li',
      scroll: true,
      opacity: 0.5
    });

    jQuery("#img_loader").hide();
    jQuery('#submit').click(function(){
      jQuery('#success_notice').hide()
      jQuery('#submit').hide();
      jQuery("#img_loader").show();
      jQuery.ajax({
        type: 'post',
        data: jQuery('ul#selected').sortable('serialize'),
        url: '/company_allowance_heads',
        complete: function(){
          jQuery('#submit').show();
          jQuery("#img_loader").hide();
          jQuery('#success_notice').show().fadeOut(3000);
        }
      });
      //handle the click
      return false; //cancel the browser's traditional event.
    });


    jQuery(".checklist .checkbox-select").click(
      function(event){
        event.preventDefault();
        jQuery(this).parent().addClass("selected");
        jQuery(this).parent().find(":checkbox").attr("checked","checked");
      }
      );

    jQuery(".checklist .checkbox-deselect").click(
      function(event){
        event.preventDefault();
        jQuery(this).parent().removeClass("selected");
        jQuery(this).parent().find(":checkbox").removeAttr("checked");
      }
      );

    jQuery(".checklist .act_as_radio_button").click(
      function(event){
        event.preventDefault();
        jQuery(this).parent().siblings().find(":checkbox").removeAttr("checked");
        jQuery(this).parent().siblings().removeClass("selected");
      }
      );

    jQuery('.flash-msg').fadeOut(8000); /* Auto fade out the flash msg */
    /*jQuery('input#create_salary_sheet').click(function(){
      jQuery("form#sheet_form").submitWithAjax();
      jQuery().ajaxStart(function(){
        jQuery('td.cando').html("<img src='../images/ajax-loader.gif'></img>");
      })
    });*/

    /*jQuery('.salary_sheet_actions').hide();
    jQuery('.cando').hover(function () {
      jQuery('.salary_sheet_actions').fadeIn(10);
      },
      function () {
        jQuery('.salary_sheet_actions').fadeOut(10);
    });*/

    jQuery('#card a[rel]').each(function(){
      jQuery(this).qtip({
        content:{
          url: jQuery(this).attr('rel'),
          title:{
            text: false
          }
        },
        position: {
          corner: {
            target: 'bottomMiddle'
          },
          adjust: {
            screen: true
          }
        },
        show: {
          solo: true
        },
        hide: {
          fixed: true
        },
        style: {
          name: 'light',
          padding: 0,
          border: {
            width: 4,
            radius: 0,
            color: '#CCC'
          },
          width: 275,
          classes: {
            title: 'card-header',
            content: 'card-info'
          }
        }
      })
    });

    jQuery('#feedback_btn').click(function(){
      feedback_widget.show(); return false;
    })
    jQuery('ul#employee_accordion').accordion();

    jQuery.pushup.show();

    jQuery('#change_locale').click(function(){
      jQuery('#locale').submit();
      return false;
    });
    jQuery("input#company_want_protected_pdf").click(function(){
      jQuery(this).hide_show();
    });
    jQuery("input#company_want_protected_pdf").hide_show();
    jQuery("span#close").click(function(){
      jQuery("div#shortkeys_help").hide();
    });

    jQuery(document).bind('keydown', 'esc', function()
    {
      jQuery("div#shortkeys_help").hide();
    });
    jQuery('.salary_sheet_options').dropdown();
   });
//end of document.ready function

// Adapted into a real plugin from
// <http://javascript-array.com/scripts/jquery_simple_drop_down_menu/>

jQuery.fn.dropdown = function (options) {
  var settings = jQuery.extend({
    timeout: 0.2
  }, options);
  var closetimer = null;
  var ddmenuitem = null;

  jQuery(this).children('li').hover(dropdown_open, dropdown_timer);
  document.onclick = dropdown_close;

  function dropdown_open()
  {
    dropdown_canceltimer();
    dropdown_close();
    ddmenuitem = jQuery('ul', this).css('display', 'block');
  }

  function dropdown_close() {
    if (ddmenuitem) {
      ddmenuitem.css('display', 'none');
    }
  }

  function dropdown_timer() {
    closetimer = window.setTimeout(dropdown_close, settings.timeout * 1000);
  }

  function dropdown_canceltimer() {
    if (closetimer) {
      window.clearTimeout(closetimer);
      closetimer = null;
    }
  }

  return this;
}
