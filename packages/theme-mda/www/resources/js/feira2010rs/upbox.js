function updateTwitts(){
  s='<scr'+'ipt src="http://search.twitter.com/search.json?callback=up&'+
    query+'&c='+Math.random()+'"></scr'+'ipt>'

  $("head").append(s)
}
function up(d){
  t="<ul>"
  for(var i=0;i<d.results.length;i++){
    t+="<li><a class=\"twitter_user\" href='http://twitter.com/"+d.results[i]['from_user']+
       "'> "+
       d.results[i]['from_user']+"</a> "+d.results[i]['text']+
       " <a href='http://twitter.com/"+d.results[i]['from_user']+
       "/statuses/"+d.results[i]['id']+"'>ver</a></li>"
  }
  t+="</ul>"
  $("#upbox").html(t)
}


$(function(){
  setInterval('updateTwitts()',timeout*1000)
  updateTwitts()
})
timeout=30


