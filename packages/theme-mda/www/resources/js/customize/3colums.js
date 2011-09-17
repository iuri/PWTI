jQuery(document).ready(
	function () {
		jQuery('.getDrag').Sortable(
			{
				accept			: 'itemDrag',
				helperclass		: 'dragAjuda',
				activeclass 	: 'dragAtivo',
				hoverclass 		: 'dragHover',
				handle			: 'h3',
				opacity			: 0.7,
				onChange 		: function()
				{	    
				},
				onStart : function()
				{
				},
				onStop : function()
				{
			
						jQuery('.top-content-padding').children().each(function(i) {
							  var divs = jQuery(this);
						      new Ajax.Request('admin/portal/element-modify',{asynchronous:true,method:'post',parameters:'region=1&sort_key='+ i + '&element_id=' + jQuery(divs).attr('id')}); 
						});
	
						jQuery('.main-content-padding').children().each(function(i) {
							  var divs = jQuery(this);
						      new Ajax.Request('admin/portal/element-modify',{asynchronous:true,method:'post',parameters:'region=2&sort_key='+ i + '&element_id=' + jQuery(divs).attr('id')}); 
							
						});
	
						jQuery('.bottom-content-padding').children().each(function(i) {
							  var divs = jQuery(this);
						      new Ajax.Request('admin/portal/element-modify',{asynchronous:true,method:'post',parameters:'region=3&sort_key='+ i + '&element_id=' + jQuery(divs).attr('id')}); 
						}); 

	
				}
			}
		);
	}
);

