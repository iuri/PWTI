// write out libraries
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='http://ajax.googleapis.com/ajax/libs/jquery/1.4.1/jquery.min.js' type='text/javascript'%3E%3C/script%3E"));
document.write(unescape("%3Cscript src='/resources/mores/engine.js' type='text/javascript'%3E%3C/script%3E"));



// process params
var smTitle = (typeof smTitle == 'undefined' ? 'Realtime Buzz' : smTitle);
var smSearchPhrase = (typeof smSearchPhrase == 'undefined' ? false : smSearchPhrase);
if(!smSearchPhrase) (typeof smKeywords == 'undefined' ? false : smKeywords);


var smTitle2 = (typeof smTitle2 == 'undefined' ? 'Realtime Buzz' : smTitle2);
var smSearchPhrase2 = (typeof smSearchPhrase2 == 'undefined' ? false : smSearchPhrase2);
if(!smSearchPhrase2) (typeof smKeywords == 'undefined' ? false : smKeywords);

var fist_load_timestamp = 1272367790;
			//  1272378681000
var smItemsPerPage = (typeof smItemsPerPage == 'undefined' || isNaN(smItemsPerPage) ? 25 : smItemsPerPage);
var smWidgetHeight = (typeof smWidgetHeight == 'undefined' || isNaN(smWidgetHeight) ? 500 : smWidgetHeight);
//var smMaxTimestamp = (typeof smMaxTimestamp == 'undefined' ? 604800 : smMaxTimestamp);
var smShowUserImages = (typeof smShowUserImages == 'undefined' ? true : smShowUserImages);

var smFontSize = (typeof smFontSize == 'undefined' || isNaN(smFontSize) ? 11 : smFontSize);

var smSources = (typeof smSources == 'undefined' || isArray(smSources) == false ?
	['googleblog2','twitter'] : smSources);

var smSources2 = (typeof smSources2 == 'undefined' || isArray(smSources2) == false ?
	['googleblog2','twitter'] : smSources2);


function isArray(obj){return(typeof(obj.length)=="undefined")?false:true;}

// calculate min-height
//if(!smWidgetHeight) var smWidgetHeight = (smItemsPerPage*140);

// output div container
var iframe_container_id = 'socialmention_buzz_iframe_'+Math.floor(Math.random()*10001);


//var iframe_container_id = 'socialmention_buzz_iframe';
//document.write('<iframe id="'+iframe_container_id+'" frameborder="0" class="socialmention" src="javascript:parent.writeIframe()" "></iframe>');

// output div container
var iframe_container_id2 = 'socialmention_buzz_iframe_'+Math.floor(Math.random()*10003);


//var iframe_container_id = 'socialmention_buzz_iframe';
document.write('<div class="iframe_container" ><iframe id="'+iframe_container_id+'" frameborder="0" class="socialmention" src="javascript:parent.writeIframe()" "></iframe> </div>');

document.write('<div class="iframe_container" ><iframe id="'+iframe_container_id2+'" frameborder="0" class="socialmention" src="javascript:parent.writeIframe()" "></iframe> </div>');

// http://blog.bolinfest.com/2009/01/using-iframe-to-force-doctype.html
function writeIframe() {
  return '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd"><html><head></head><body></body></html>';
}


// class
var simpleSpy = function(iframe_container_id, smSearchPhrase, smShowUserImages, smFontSize, smTitle, smSources) {
	this.css_id = 'socialmention_widget_css';
	this.play = 1; // 0 = pause
	this.interval_cue = 2000;
	this.itemsPerPage = smItemsPerPage;
	this.smSearchPhrase = encodeURIComponent(smSearchPhrase);
	this.smShowUserImages = smShowUserImages;
	this.iframe_container_id = iframe_container_id;
	this.smTitle = smTitle;
	this.smSources = smSources;
	
	this.container_id = 'socialmention_buzz_'+Math.floor(Math.random()*10001);
	//this.container_content_id = 'socialmention_buzz_content_'+Math.floor(Math.random()*10001);
	
	this.container_content_id = 'socialmention_buzz_content_id';
	this.smWidgetHeight = smWidgetHeight-125;
	this.smFontSize = smFontSize;
	
	this.pageCurrent = 1;
	
	this.firstSetofItems = true;
	
	this.item_cue = new Array();
	this.items_all = new Array();
	this.item_list = new Array(); // holds elements as they are placed in a page
	
	this.engine;
	
	this.inMidPageChange = false;

	this.iframeContents = function() {
		return $('#'+this.iframe_container_id).contents();	
	}
	
	this.get_iframe = function() {
		return document.getElementById(this.iframe_container_id);	
	}

	this.setupIframeContent = function() {
		this.iframeContents().find("body").html('' +
			'<div id="' + this.container_id + '" class="socialmention-buzz-widget clearfix" style="font-size:'+this.smFontSize+'px;">' +
			'<div class="sm_title">' + this.smTitle + ' <span class="sm-pause" style="display:none;">(pausado)</span></div>' +
			'<div id="' + this.container_content_id + '" ></div>' +
			'<div class="pagination2">' +
			'</div>' +
			'</div>' +							   
		'');
	}

	this.insertCSS = function() {
		// ie 7 the new element has to be created by the iframe document
		var css = this.get_iframe().contentWindow.document.createElement("link");
		css.setAttribute("type", "text/css");
		css.setAttribute("rel", "stylesheet");
		css.setAttribute("href", "/resources/mores/buzz.css");
		//this.iframeContents().find('head').appendChild(css);

		$element = $(css);
		$container = this.iframeContents().find('head');
		$element.appendTo($container);
	}

	this.getPaginationStartAt = function() {
		return this.itemsPerPage * (this.pageCurrent-1);
	}

	this.getPaginationLimit = function() {
		return this.itemsPerPage * this.pageCurrent;
	}
	
	this.changePage = function(nextPage) {
		this.inMidPageChange = true;
	try{
		if(nextPage) {
			this.pageCurrent = this.pageCurrent+1;
		} else {
			this.pageCurrent = this.pageCurrent-1;
			if(this.pageCurrent <= 1) this.pageCurrent = 1;
		}
		
		// update content
		
		// clear out array that holds the live elements (to remove them on update)
		this.item_list = new Array();
		// clear the cue array to make sure items don't get reposted after returning to page 1
		this.item_cue = new Array(); 
		
		// clear out content
		this.iframeContents().find("#"+this.container_content_id).html("");

		// sort items all array so newest item is first
		this.items_all.sort(this.engine.sortDesc);
		
		//console.log(this.pageCurrent + " start at: " + this.getPaginationStartAt() + " limit:" +this.getPaginationLimit())
		
		for(var i=this.getPaginationStartAt(); i<this.getPaginationLimit() && i<this.items_all.length; i++) {
			var item = this.items_all[i];
			var element = this.getItemHTML(item);
			$container = this.iframeContents().find("#"+this.container_content_id);
			$(element).appendTo($container);
			$(element).show();
			
			this.item_list.push(element);
		}
		} catch(e){alert(e)}
		this.inMidPageChange = false;
	}

	this.initPagination = function() {
		var div1 = Helper.createNode('div', {"className":"prev"}, {}, "Newer", this.get_iframe().contentWindow.document);
		var div2 = Helper.createNode('div', {"className":"next"}, {}, "Older", this.get_iframe().contentWindow.document);		
		//
		$div1 = $(div1);
		$div2 = $(div2);
		
		var element = this.iframeContents().find("#"+this.container_id+" .sm-pagination-buttons").eq(0);
		
		var self = this;
		try{
		$div1.click(function(){self.changePage(false);});
		$div2.click(function(){self.changePage(true);});
		} catch(e){alert(e)}
		
		$div2.appendTo(element);
		$div1.appendTo(element);
	}
	
	this.googAnalytics = function() {
		var pageTracker = _gat._getTracker("UA-655659-11");
		pageTracker._trackPageview('/exit/widget/buzz/'+encodeURI(location.href));	
	}

	this.start = function() {
		//if(console) console.log("start()");
		//
	//	this.googAnalytics();
		//	
		this.insertCSS();
		//
		this.setupIframeContent();
		//
		var self = this;
		
		// start the cue
		//setInterval(function(){ self.runCue(); }, this.interval_cue);
		// create the data fetching engine
		this.engine = new socialMentionEngine();
		
		//
		this.initPagination();
		
		/*
		this.engine.getTrends(function(data) {
			alert(data);	   
		});*/
		
		this.is_first_load = true;
		this.first_load_timestamp = null;
		
		//funcoes retiradas daqui
		
		this.is_first_load = true;
		this.first_load_timestamp = null;
		this.engine.setQuery(smSearchPhrase);
		var self = this;
		//alert(smSearchPhrase2);
		this.engine.startDataCycle({'sources':this.smSources,

			'success':function(source_class, items) {				
				for(var i=0; i<items.length; i++) {
					var item = items[i];
					self.item_cue.push(item);
					self.items_all.push(item);
				}
				// filter duplicates
				self.item_cue = self.filterDuplicateMentions(self.item_cue);
				self.items_all = self.filterDuplicateMentions(self.items_all);
				// if first load pre-populate list and start the auto cue
				if(self.is_first_load == true) {
					self.is_first_load = false;
					//
					self.prePopulate();					
					// start the cue
					setInterval(function(){ self.runCue(); }, self.interval_cue);
				}
			}},
		{'cycle_interval':10000});
		// add the pause events
		this.iframeContents().find("#"+this.container_content_id).mouseover(function(){self.pauseWidget(true);});
		this.iframeContents().find("#"+this.container_content_id).mouseout(function(){self.pauseWidget(false);});
	}
	
	this.openmonitor = function (smSearchPhrase) {

		
		this.is_first_load = true;
		this.first_load_timestamp = null;
		this.engine.setQuery(smSearchPhrase2);
		var self = this;
		//alert(smSearchPhrase2);
		this.engine.startDataCycle({'sources':this.smSources,
			'success':function(source_class, items) {				
				for(var i=0; i<items.length; i++) {
					var item = items[i];
					self.item_cue.push(item);
					self.items_all.push(item);
				}
				// filter duplicates
				self.item_cue = self.filterDuplicateMentions(self.item_cue);
				self.items_all = self.filterDuplicateMentions(self.items_all);
				// if first load pre-populate list and start the auto cue
				if(self.is_first_load == true) {
					self.is_first_load = false;
					//
					self.prePopulate();					
					// start the cue
					setInterval(function(){ self.runCue(); }, self.interval_cue);
				}
			}},
		{'cycle_interval':10000});

	
	}
	
	this.pauseWidget = function(pause) {
		if(pause) {
			this.play = 1;
			this.play = 0;
			this.iframeContents().find("#"+this.container_id+" .sm-pause").eq(0).show();
		} else {
			this.play = 1;
			this.iframeContents().find("#"+this.container_id+" .sm-pause").eq(0).hide();
		}
	}

	this.togglePause = function(pause) {
		if(pause) {
			this.play = 0;
		} else {
			this.play = 1;
		}
	}
	
	this.runCue = function() {
		if(this.play != 1) return;
		if(this.item_cue.length == 0) return;
		if(this.pageCurrent != 1 || this.inMidPageChange == true) return;
		
		// wait for the first cycle to complete
		/*if(this.engine.isCycleComplete == true) {
			this.item_cue.sort(this.engine.sortAsc);
			this.item_cue.splice(0, this.itemsPerPage);
		} else {
			return;	
		}*/

		// update all timestamps
		this.iframeContents().find("#"+this.container_content_id).find('.date').each(function () {
            		var timestamp = this.getAttribute('rel');
			$(this).find('> a').text(timeAgo(timestamp));
        	});
		
		// filter out old mentions
		//this.item_cue = this.filterOldMentions(this.item_cue);

		// filter duplicates
		this.item_cue = this.filterDuplicateMentions(this.item_cue);

		// sort array (newest first)
		this.item_cue.sort(this.engine.sortAsc);
		
		//console.log(this.item_cue.length + " " + this.itemsPerPage);
		// if there are more mentions that the max items per page
		// remove them and just insert the new ones
		if(this.item_cue.length > this.itemsPerPage) {
			this.item_cue.splice(0, this.itemsPerPage-1);
		}

		// sort array (to oldest is first to be shifted out of array)
		this.item_cue.sort(this.engine.sortDesc);

		// if first dump of items
		/*if(this.firstSetofItems == true) {
			this.item_cue.splice(0, this.itemsPerPage);
			this.firstSetofItems = false;
		}*/
		
		// get first array element
		var item = this.item_cue.pop();
		//
		
		//if(console) console.log(this.first_load_timestamp + " < " + item.timestamp);
		if(item && this.first_load_timestamp && item.timestamp < this.first_load_timestamp) return;
		
		//
		var element = this.getItemHTML(item);
		$container = this.iframeContents().find("#"+this.container_content_id);
		$insert = $(element).prependTo($container);
		$(element).slideDown("slow");

		// add to item list
		this.item_list.push(element);
		
		if(this.item_list.length > this.itemsPerPage) {
			// remove that item on list
			var element = this.item_list.shift();
			$(element).slideUp("fast");
			$(element).remove();
			//document.getElementById(this.container_content_id).removeChild(element);
		}
	}
	
	this.prePopulate = function() {
		// filter duplicates
		this.item_cue = this.filterDuplicateMentions(this.item_cue);
		
		// sort array (newest first)
		this.item_cue.sort(this.engine.sortAsc);
		
		if(this.item_cue[0]) this.first_load_timestamp = this.item_cue[0].timestamp;
		// > fist_load_timestamp? fist_load_timestamp : this.item_cue[0].timestamp)
		//if(console) console.log(this.first_load_timestamp);
		
		//console.log(this.item_cue.length + " " + this.itemsPerPage);
		// if there are more mentions that the max items per page
		// remove them and just insert the new ones
		if(this.item_cue.length > this.itemsPerPage) {
			this.item_cue.splice(0, this.itemsPerPage-1);
		}
		
		// sort array (to oldest is first to be shifted out of array)
		this.item_cue.sort(this.engine.sortDesc);

		// get first array element
		var count = this.item_cue.length;
		for(i=0;i<count;i++) {
			var item = this.item_cue.pop();
			var element = this.getItemHTML(item);
			$container = this.iframeContents().find("#"+this.container_content_id);
			$insert = $(element).prependTo($container);
			$(element).show();
			// add to item list
			this.item_list.push(element);
		}
	}
	
	this.filterOldMentions = function(items) {
		var now = new Date().getTime();
		for(var x=0; x<items.length; x++) {
			var time_difference = now - items[x].timestamp;
			time_difference = time_difference/1000; // convert to seconds
			//console.log(time_difference);
			if(time_difference >= smMaxTimestamp) {
				items.splice(x, 1);
				x = x-1;
			}
		}
		return items;
	}
	
	this.filterDuplicateMentions = function(items) {
		var temp = new Array();
		for(var x=0; x<items.length; x++) {
			var current_item = items[x];
			// if match is true do nothing
			// if match is false add to temp array
			var dup_key1 = 'title'; // ie: source or title
			var dup_key2 = 'source'; // ie: source or title
			if(this.arrayContains(temp, dup_key1, dup_key2, current_item[dup_key1], current_item[dup_key2]) == true) {
			} else {
				temp.push(current_item);	
			}
		}
		return temp;
	}
	 
	//Will check for the Uniqueness
	this.arrayContains = function(a, dup_key1, dup_key2, e1, e2) {
	 for(j=0;j<a.length;j++) {
		 if(a[j][dup_key1] == e1 && a[j][dup_key2] == e2) return true;
	 }
	 return false;
	}

	this.getItemHTML = function(item) {
		var media = '';
		if(item.media) {
			if(Helper.isArray(item.media) == true) {
				for(var x=0; x<item.media.length && x<3; x++) {
					media += '<a href="' + item.url + '" target="_blank"><img src="' + item.media[x] + '" /></a>';
				}
			} else {
				media = '<a href="' + item.url + '" target="_blank"><img src="' + item.media + '" /></a>';
			}
		}
		var div1 = Helper.createNode('div', {"className":"item"}, {"display":"none"}, "", this.get_iframe().contentWindow.document);
	if(item.user && this.smShowUserImages == true) {
		var div2 = Helper.createNode('div', {"className":"text"}, {}, media + this.engine.addUrlsToText(item.title), this.get_iframe().contentWindow.document);
	} else {
		var div2 = Helper.createNode('div', {"className":"text2"}, {}, media + this.engine.addUrlsToText(item.title), this.get_iframe().contentWindow.document);
	}
		var div3 = Helper.createNode('div', {"className":"details"}, {}, "", this.get_iframe().contentWindow.document);
		var div4 = Helper.createNode('div', {"className":"source"}, {}, '<img src="' + item.favicon + '" />&nbsp;' +
			'<span class="date" rel="' + item.timestamp + '"><a title="Veja o post original " href="' + item.url +  '" target="_blank">' + timeAgo(item.timestamp) + '</a></span> ' + (item.user ? ' por <a href="' + item.profile + '" target="_blank">'+ item.user + '</a>' : '') + ' - ' + item.source +' <a class="link_original" href="' + item.url  + '" target="_blank"> </a>', this.get_iframe().contentWindow.document);
		
		if(item.user && this.smShowUserImages == true) {
			var img = (item.image ? item.image : 'img/q_silhouette.gif');
			var div5 = Helper.createNode('div', {"className":"user_image"}, {}, '<a href="' + item.profile + '" target="_blank"><img src="' + img + '"/></a>', this.get_iframe().contentWindow.document);
			div1.appendChild(div5);
		}		
		
		div1.appendChild(div2);
		div1.appendChild(div3);
		div3.appendChild(div4);
		//var div6 = Helper.createNode('div', {"className":"folow_link"}, {}, '<a href="' + item.url  + '" target="_blank"> Veja o Post Completo </a>', this.get_iframe().contentWindow.document);
			//div1.appendChild(div6);
		return div1;
	}

	this.addScript = function(script_url) {
		var script = document.createElement("script");
		script.setAttribute("type", "text/javascript");
		script.setAttribute("defer", "true");
		script.setAttribute("src", script_url);
		document.getElementsByTagName('body')[0].appendChild(script);
	}

	this.init = function() {
		//this.addScript('http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js');
		//this.addScript('http://socialmention.com/spy/engine.js');
		
		// IE will throw an error if you try to add script presumably before the page is loaded...
		this.addLoadEvent(this.start);
	}
	
	// See: http://dean.edwards.name/weblog/2006/06/again/
	this.addLoadEvent = function(func) {
		var init = this.bind(func);

		// for Mozilla and Opera browsers
		// strange error in which you cant have 2 widgets
		// maybe gets overridden?
		/*if (document.addEventListener) {
			document.addEventListener("DOMContentLoaded", init, false);
			return;
		}
		*/
		 
		// for WebKit browsers
		if (/WebKit/i.test(navigator.userAgent)) { // sniff
			var _timer = setInterval(function() {
				if (/loaded|complete/.test(document.readyState)) {
					clearInterval(_timer);
					init(); // call the onload handler
				}
			}, 1);
			return;
		}
		// for anyone else not covered above.
		var oldonload = window.onload;
		if (typeof window.onload != 'function') {
			window.onload = init;
		} else {
			window.onload = function() {
				if (oldonload) { oldonload(); }
				init();
			}
		}
	}

	this.bind = function(func) {
		var obj = this;
		return function() { return func.apply(obj, arguments) };
	}
}

// initialize
var spy = new simpleSpy(iframe_container_id, smSearchPhrase, smShowUserImages, smFontSize, smTitle, smSources);
spy.init();

var spy2 = new simpleSpy(iframe_container_id2, smSearchPhrase2, smShowUserImages, smFontSize, smTitle2, smSources2);
spy2.init();
