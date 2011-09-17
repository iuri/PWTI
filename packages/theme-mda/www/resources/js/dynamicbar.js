jQuery.noConflict();
jQuery(document).ready(function(){
        jQuery("#subLinks").find("li")
        .prepend("<span id='cornerS'></span>")
        .append("<span id='cornerE'></span>")
        .hover(function(){  jQuery(this).toggleClass("highlight");  }, function(){  jQuery(this).toggleClass("highlight");  })
        ;


        jQuery("#linksPortal").find("li")
        .prepend("<span id='cornerS'></span>")
        .append("<span id='cornerE'></span>")
        .hover(function(){  jQuery(this).toggleClass("highlight");  }, function(){  jQuery(this).toggleClass("highlight");  })
        ;

		jQuery(".boxAcao").click(function () {
			var qual = jQuery(this);
			var qual2 = jQuery(this).find('ul');
		
			var estado = jQuery(this).find('ul').attr("class");
			if (typeof(estado) == 'undefined') {
			 	jQuery(this).find('ul').slideUp("500", function(){jQuery(qual2).addClass("desativado")});
			 	//jQuery(this).find('ul').slideUp("500", function(){jQuery(qual).addClass("desativado")});
			} else {
				jQuery(this).find('ul').slideDown("500");
				//jQuery(this).removeClass("desativado");
			 	jQuery(this).find('ul').removeClass("desativado");
			}
	});
	jQuery(".boxAcao03").click(function () {
			var qual = jQuery(this);
			var qual2 = jQuery(this).find('ul');
		
			var estado = jQuery(this).find('ul').attr("class");
			if (typeof(estado) == 'undefined') {
			 	jQuery(this).find('ul').slideUp("500", function(){jQuery(qual2).addClass("desativado")});
			 	//jQuery(this).find('ul').slideUp("500", function(){jQuery(qual).addClass("desativado")});
			} else {
				jQuery(this).find('ul').slideDown("500");
				//jQuery(this).removeClass("desativado");
			 	jQuery(this).find('ul').removeClass("desativado");
			}
	});




});

function go_to_url(application) {

   window.location = application.value;

}
