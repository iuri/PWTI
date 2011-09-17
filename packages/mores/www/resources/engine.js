
var socialMentionEngine = function (config) {
	this.config = config || {};
	this.query = null;
	this.source_idx = 0;
	this.cycle_timestamp;
	this.sources = ['googleblog2','twitter']; // 'brightkite', 'backtype', 'delicious', 'friendfeed', 'flickr', 'identica', 'youare', 'digg'
	this.sources_timestamps = {};
	//this.max_default_items = 5; // items to display on first load
	
	this.isCycleComplete = function() {
		// check that the cycle has returned to the first source and that we have a timestamp
		// so we know we've completed the cycle at least once
		if(this.source_idx == 0 && this.cycle_timestamp != null) return true;
		return false;
	}
	
	this.setQuery = function(str) {
		this.query = str;
	}
	
	this.setParams = function(params) {
		this.params = params;
	}
	
	this.getNextSource = function() {
		var source_name = this.config.sourceData['sources'][this.source_idx];
		// increment the index
		this.source_idx++;
		if(this.source_idx >= this.config.sourceData['sources'].length) {
			this.source_idx = 0;
		}
		// return source object
		return source_name; //this.sources[source_name];
	}
	
	this.repeater = function() {
		var self = this;
		
		// check if on the first item of the cycle after the first time
		if(this.source_idx == 0 && this.cycle_timestamp != null || this.query == null) {
			// check that the timestamp is more then 30secs between full cycles
			if(new Date().getTime() - this.cycle_timestamp < 60000 || this.query == null) {
				// if was longer then 30 seconds since last cycle wait 5 more seconds
				setTimeout(function(){ self.repeater(); }, 10000);
				return;
			}
		}
		
		// on the first source so record the start of the cycle's timestamp
		if(this.source_idx == 0) {
			this.cycle_timestamp = new Date().getTime();	
		}
		
		// get the next source object starting at the current index
		var original_source_index = this.source_idx;
		var source_name = this.getNextSource();
		// create the new class
		try {
			var source_class = eval("new " + source_name + "('" + encodeURIComponent(this.query) + "')");
		} catch(e) {
			this.repeater();
			return;
		}
		// launch ajax method
		this.getSourceData(source_class, source_name);
	}
	
	this.getSourceData = function(source_class, source_name) {
		var that = this;
		var url = source_class.api_uri + "&callback=?";
		// get data
		//alert(url);
		$.ajax({url:url, dataType:'jsonp', data:'', timeout: 60000,
			success:function(data, textStatus){
				// process results
				try {
					// process data in results array
					var results = source_class.getRestuls(data);
					// filter previously sent items
					results = that.filterOnlyNewItems(results, source_name);
					// run parent update method
					that.config.sourceData['success'](source_class, results);
				} catch(e) {
					//alert(e)
				}
			},
			error:function(XMLHttpRequest, textStatus, errorThrown){},
			complete:function(XMLHttpRequest, textStatus) {}
		})
		// load next source
		that.repeater();
	}

	this.filterOnlyNewItems = function(items, source_name) {
		var filtered_items = new Array();
		// sort items from newest to oldest
		items.sort(this.sortDesc);
		// get the last polling timestamp for the source
		var last_poll_timestamp = null;
		if(typeof(this.sources_timestamps[source_name]) != "undefined") {
			var last_poll_timestamp = this.sources_timestamps[source_name]['last_timestamp'];	
		} else {
			// create object in array if it doesn't exist
			this.sources_timestamps[source_name] = {};	
		}
		// loop through items and remove any items that have been already sent
		for(var i=0; i<items.length; i++) {
			var item = items[i];
			// if item timestamp is less then last polling
			// or allow the last N items if first poll
			if((last_poll_timestamp != null && item.timestamp > last_poll_timestamp) || (last_poll_timestamp == null /*&& i < this.max_default_items*/)) {
				filtered_items.push(item);
			}
		}
		// update the source's last timestamp with the latest timestamp
		if(filtered_items[0]) {
			this.sources_timestamps[source_name]['last_timestamp'] = filtered_items[0]['timestamp'];
		}
		// return the new item array
		return filtered_items;
	}

	this.getTrends = function(callback) {
		var url = 'http://search.twitter.com/trends.json';
		$.ajax({type:'GET', url:url, dataType:'jsonp', data:'', timeout: 60000,
			success:function(data, textStatus){
				// process results
				callback(data);
			},
			error:function(XMLHttpRequest, textStatus, errorThrown){
				callback(null);	
			},
			complete:function(XMLHttpRequest, textStatus) {}
		})
	}

	this.startDataCycle = function(config, params) {
		//this.config = config || {}; //{'sources':[], 'cycle':true, 'cycle_interval':30000, 'success':null};		
		this.config.sourceData = config;
		this.config.sourceData["sources"] = (this.config.sourceData["sources"] ? this.config.sourceData["sources"] : this.sources);
		this.config.sourceData["cycle"] = (this.config.sourceData["cycle"] ? this.config.sourceData["cycle"] : true);
		this.config.sourceData["cycle_interval"] = (this.config.sourceData["cycle_interval"] ? this.config.sourceData["cycle_interval"] : 60000);
		// set params
		this.setParams(params);
		// check that all source in config are valid
		// start the repeater
		this.repeater();	
	}

	this.init = function() {
	}
	this.init();
}


socialMentionEngine.prototype.addUrlsToText = function(str) {
	str = str.replace(/(\s|\n|^)(\w+:\/\/[^\s\n]+)/g, '$1<a href="$2" target="_blank">$2</a>');
	str = str.replace(/(^|\s+)@([a-zA-Z0-9_-]+)/gi, '$1<a href="http://twitter.com/' + '$2" class="inline-reply" title="View $2\'s profile page" user-screen_name="$2">@$2</a>');
	str = str.replace(/(^|\s+)#([a-zA-Z0-9_-]+)/gi, '$1<a href="http://search.twitter.com/search?q=%23' + '$2" class="inline-reply" title="View hash tag results for $2" user-screen_name="$2">#$2</a>');
	return str;
}

socialMentionEngine.prototype.sortAsc = function(a,b) {return isNaN(a.timestamp - b.timestamp) ? -1 : a.timestamp - b.timestamp;}
socialMentionEngine.prototype.sortDesc = function(a,b) {return isNaN(b.timestamp - a.timestamp) ? -1 : b.timestamp - a.timestamp;}

function fixDateTime(date) {
	tmp = date.replace(/-/g, '/');
	tmp = tmp.replace(/T/g, ' ');
	tmp = tmp.replace(/Z/g, '');
	return tmp + ' +0000';
}

function timeAgo(timestamp) {
	var now = new Date().getTime();
	var time_difference = now - timestamp;
	time_difference = time_difference/1000; // convert to seconds
	if(time_difference > 86400) {
		// days
		time_prefix = Math.round(time_difference / 86400);
		if(time_prefix == 1) {
			return 'ontem';
		}
		if(time_prefix > 31) {
		// months
			time_prefix = Math.round(time_prefix/31);
			return time_prefix + ' meses atrás';
		}
		// days
		return time_prefix + ' dias atrás';
	} else if(time_difference > 3600) {
		// hours
		time_prefix = Math.round(time_difference / 3600);
		if(time_prefix == 1) {
			return time_prefix + ' hora atrás';
		}
		return time_prefix + ' horas atrás';
	} else if(time_difference > 60) {
		// minutes
		time_prefix = Math.round(time_difference / 60);
		if(time_prefix == 1) {
			return time_prefix + ' minuto atrás';
		}
		return time_prefix + ' minutos atrás';
	} else {
		// seconds
		time_prefix = Math.round(time_difference);
		if(time_prefix <= 0) {
			return 'agora';
		} else if(time_prefix == 1) {
			return time_prefix + ' segundo atrás';
		}
		return time_prefix + ' segundos atrás';
	}
}

var Helper = {};

Helper.isArray = function(obj) {
   if (obj.constructor.toString().indexOf("Array") == -1)
      return false;
   else
      return true;
}

// created DOM node
Helper.createNode = function(tag, domAttributes, styleAttributes, innerHTML, windowDocument) {
	// if we are creating nodes in an iframe we need to reference the iframe document
	if(windowDocument) {
		var el=windowDocument.createElement(tag);
	} else {
   		var el=document.createElement(tag);
	}
   Helper.styleNode(el,domAttributes,styleAttributes);
   if(innerHTML){
      el.innerHTML = innerHTML;
   }
   return el;
};

// style a DOM node
Helper.styleNode = function(el,domAttributes,styleAttributes){
   if(!el) { return; }
   if(domAttributes){
      for(var i in domAttributes){
         var domAttribute = domAttributes[i];

         if(typeof (domAttribute)=="function"){
            continue;
         }
         /*if(YAHOO.env.ua.ie && i=="type" && (el.tagName=="INPUT"||el.tagName=="SELECT") ){
            continue;
         }*/
         if(i=="className"){
            i="class";
            el.className=domAttribute;
         }
         if(domAttribute!==el.getAttribute(i)){
            try{
               if(domAttribute===false){
                  el.removeAttribute(i);
               }else{
                  el.setAttribute(i,domAttribute);
               }
            }
            catch(err){
               alert("WARNING: StyleNode failed for "+el.tagName+", attr "+i+", val "+domAttribute);
            }
         }
      }
   }
       
   if(styleAttributes){
      for(var i in styleAttributes){
         if(typeof (styleAttributes[i])=="function"){
            continue;
         }
         if(el.style[i]!=styleAttributes[i]){
            el.style[i]=styleAttributes[i];
         }
      }
   }
};

// sources

var twitter = function(query) {
	this.api_uri = "http://search.twitter.com/search.json?q=" + query + "&rpp=25&callback=?";
	this.favicon = "http://twitter.com/favicon.ico";
	
	this.getRestuls = function(json) {
		var items = json.results;
		var output = new Array();
		if(!items) return output;
		for(var i=0; i<items.length; i++) {
			var item = items[i];
			// Mon, 09 Feb 2009 23:19:29 +0000
			var date = Date.parse(item.created_at);
			date = (isNaN(date) ? 0 : date);
			var obj = {
				'text':item.text,
				'title':item.text,
				'url':'http://twitter.com/' + item.from_user + '/statuses/' + item.id,
				'user':item.from_user,
				'profile':'http://twitter.com/' + item.from_user,
				'image':item.profile_image_url,
				'date':item.created_at,
				'timestamp':date,
				'favicon':this.favicon,
				'source':'Twitter'
			};
			output.push(obj);
		}
		return output;
	}
}


var googleblog2 = function(query) {
	

	var exists = query.search(/beth/i);
	if (exists < 0 ) {	
		query = escape(query);


		this.api_uri = "http://173.230.132.158/search/search-engine.php?url=http%3a%2f%2fapi2.socialmention.com%2fsearch%3fq%3d"+query+"%26btnG%3dSearch%26lang%3dpt%26f%3djson%26src%5b%5d%3dbing%26src%5b%5d%3ddelicious%26src%5b%5d%3ddigg%26src%5b%5d%3dfacebook%26src%5b%5d%3dflickr%26src%5b%5d%3dfriendfeed%26src%5b%5d%3dgoogle_blog%26src%5b%5d%3dgoogle_buzz%26src%5b%5d%3dgoogle_news%26src%5b%5d%3dgoogle_video%26src%5b%5d%3didentica%26src%5b%5d%3dlinkedin%26src%5b%5d%3dmsn_social%26src%5b%5d%3dmsn_video%26src%5b%5d%3dmybloglog%26src%5b%5d%3dmyspace%26src%5b%5d%3dmyspace_photo%26src%5b%5d%3dmyspace_video%26src%5b%5d%3dning%26src%5b%5d%3dpanoramio%26src%5b%5d%3dpicasaweb%26src%5b%5d%3dreddit%26src%5b%5d%3dstumbleupon%26src%5b%5d%3dwordpress%26src%5b%5d%3dyahoo%26src%5b%5d%3dyahoo_news%26src%5b%5d%3dyouare%26src%5b%5d%3dyoutube";
	} else {


	}
	//	alert (this.api_uri);
	this.getRestuls = function(json) {
		var items = json.contents.items;
		var output = new Array();
		if(!items) return output;
		for(var i=0; i<items.length; i++) {
			var item = items[i];
			// Mon, 09 Feb 2009 23:19:29 +0000
			var timestamp2 = item.timestamp + '000';
			//alert (timestamp2);
			var addr_src = item.source;
			if (item.link != null) {
				var addr = item.link.split('/');
				addr_src = addr[2];
			} 
			var obj = {
				'text':item.title,
				'title':item.title,
				'url':item.link,
				'user':item.user,
				'profile':item.user_link,
				'image':item.user_image,
				'date':item.timestamp,
				'timestamp':timestamp2,
				'favicon':item.favicon,
				'source':addr_src
			};
			output.push(obj);
		}
		return output;
	}
}

var contextvoice = function(query) {

	
	query = escape(query);


	this.api_uri = "http://173.230.132.158/search/search-engine.php?url=http%3A%2F%2Fapi.contextvoice.com%2F1.2%2Fresources%2Fsearch%2F%3Fq%3D"+query+"%26format%3Djson%26apikey%3D561233b7f1efeb3b30ccac53e958c84a";
	//alert (this.api_uri);
	this.getRestuls = function(json) {
		var items = json.contents.results;
		var output = new Array();
		if(!items) return output;
		for(var i=0; i<items.length; i++) {
			var item = items[i];
			// Mon, 09 Feb 2009 23:19:29 +0000
			var timestamp2 = item.created_at + '000';
			//alert (timestamp2);
			var addr_src = item.generator;
			if (item.url != null) {
				var addr = item.url.split('/');
				addr_src = addr[2];
			} 
			var obj = {
				'text':item.title,
				'title':item.title,
				'url':item.url,
				'user':item.author,
				'profile':'',
				'image':'',
				'date':item.created_at,
				'timestamp':timestamp2,
				'favicon':'',
				'source':addr_src
			};
			output.push(obj);
		}
		return output;
	}
}
