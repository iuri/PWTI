function Chart(el,config){
this._cont=el;
this._series=new Array();
this._painter=null;
// alert (config.showLegend);
var defaultConfig={yMin:0,yMax:0,xGrid:0,yGrid:10,labelPrecision:0,showLegend:true,xLabels:new Array(),painterType:'canvas',legendWidth:150,backgroundColor:'white',gridColor:'silver',axesColor:'black',textColor:'black'};
for(var p in config){
	if(config[p]!='')defaultConfig[p]=config[p]
}
this.config=defaultConfig;
if(this.config.painterType=='canvas'){
	try{
		this.setPainterFactory(CanvasChartPainterFactory)
	}catch(e){
		alert("Canvas painter not loaded")
	}
}else if(this.config.painterType=='jsgraphics'){
	try{
		this.setPainterFactory(JsGraphicsChartPainterFactory)
	}catch(e){
		alert("JSGraphics painternon not loaded")
	}
}else{
	try{
		this.setPainterFactory(CanvasChartPainterFactory)
	}catch(e){
		try{
			this.setPainterFactory(JsGraphicsChartPainterFactory)
		}catch(e1){
			alert("No supported painter factory found")
		}
	}
}
if(!this._painter){return}
this.xlen=this.config.xLabels.length;
this.ymin=this.config.yMin;
this.ymax=this.config.yMax;
this.w=this._painter.getWidth();
this.h=this._painter.getHeight();
this.chartx=0;
this.charty=0;
this.chartw=this.w;
this.charth=this.h;
this.offset=0;
this.config.showLegend=config.showLegend;
}
Chart.prototype.getPainter=function(){return this._painter};

Chart.prototype.add=function(series){try{series.getLabel()}catch(e){try{series=eval("new "+series.type+"ChartSeries(series);")}catch(e1){alert(e)}}this._series.push(series);var range=series.getRange(this);this.adjustRange(range);if(series.toOffset()){this.offset++}};

Chart.prototype.draw=function(seriesLabel){if(!this._painter){return}if(typeof seriesLabel!='undefined'){var series=this.find(seriesLabel);if(series){series.draw(this);if(this.config.showLegend){this.drawLegend(series)}}}else{for(var i=0;i<this._series.length;i++){this._series[i].draw(this);if(this.config.showLegend){this.drawLegend(this._series[i])}}}this.drawAxes()};

Chart.prototype.find=function(label){for(var i=0;i<this._series.length;i++){if(this._series[i].getLabel()==label){return this._series[i]}}return null};

Chart.prototype.clear=function(){if(this.config.showLegend){this.createLegend()}this._painter.fillRect(this.config.backgroundColor,0,0,this.w,this.h);if(this.config.xGrid<=this.xlen-1){this.config.xGrid=this.xlen-1}this.adjustRange();if(this.showLabels){this.drawVerticalLabels();this.drawHorizontalLabels()}if(this.xGridDensity){for(var i=0;i<this.config.xGrid;i++){var x=1+this.chartx+(i*this.xGridDensity);this._painter.line(this.config.gridColor,1,x,this.charty,x,this.charty+this.charth)}this._painter.line(this.config.gridColor,1,this.chartx+this.chartw,this.charty,this.chartx+this.chartw,this.charty+this.charth)}if(this.yGridDensity){for(var i=0;i<this.config.yGrid;i++){var y=this.charty+this.charth-(i*this.yGridDensity)-1;this._painter.line(this.config.gridColor,1,this.chartx+1,y,this.chartx+this.chartw+1,y)}this._painter.line(this.config.gridColor,1,this.chartx+1,this.charty,this.chartx+this.chartw,this.charty)}this.adjustRange();this.drawAxes()};Chart.prototype.setPainterFactory=function(f){this._painterFactory=f;this._painter=this._painterFactory();this._painter.create(this._cont);this._painter.fillRect(this.config.backgroundColor,0,0,1,1)};Chart.prototype.adjustRange=function(range){if(typeof range!='undefined'){if(range.xlen>this.xlen){this.xlen=range.xlen}if(range.ymin<this.ymin){this.ymin=range.ymin}if(range.ymax>this.ymax){this.ymax=range.ymax}}this.range=this.ymax-this.ymin;this.xstep=this.chartw/(this.xlen-1);this.xGridDensity=0;this.yGridDensity=0;if(this.config.xGrid>0){this.xGridDensity=Math.round((this.chartw-1)/this.config.xGrid)}if(this.config.yGrid>0){this.yGridDensity=Math.round((this.charth-1)/this.config.yGrid)}this.showLabels=(this.xGridDensity)&&(this.yGridDensity)};Chart.prototype.drawAxes=function(){var x1=this.chartx;var x2=this.chartx+this.chartw+1;var y1=this.charty;var y2=this.charty+this.charth-1;this._painter.line(this.config.axesColor,1,x1,y1,x1,y2);this._painter.line(this.config.axesColor,1,x1,y2,x2,y2)};
Chart.prototype.createLegend=function(){var series=this._series;this.legend=document.createElement('div');this.legend.style.position='absolute';this.legendList=document.createElement('ul');this.legendList.style.listStyle='square';this.legend.style.backgroundColor=this.config.backgroundColor;

//this.legend.style.display='none';

this.legend.style.width=this.config.legendWidth+'px';this.legend.style.right='0px';this.legend.style.border='1px solid '+this.config.textColor;this.legend.style.borderColor=this.config.textColor;this.legend.style.top=this.charty+(this.charth/ 2) - (this.legend.offsetHeight /2)+'px';this.legend.appendChild(this.legendList);this._cont.appendChild(this.legend);this.chartw=this.w-(this.config.legendWidth+5);this.adjustRange()};

Chart.prototype.drawLegend=function(series){if(typeof series=='undefined'){for(var i=0;i<this._series.length;i++){this.drawLegend(this._series[i])}return}this.legendList.innerHTML+='<li style="color:'+series.getColor()+'"><span style="color:'+this.config.textColor+'">'+series.getLabel()+'</span>';};Chart.prototype.drawVerticalLabels=function(){var axis,item,step,y,ty,n,yoffset,value,multiplier,w,items,pos;var ygd,precision;ygd=this.config.yGrid;if(ygd<=0)return;precision=this.config.labelPrecision;multiplier=Math.pow(10,precision);step=this.range/this.config.yGrid;axis=document.createElement('div');axis.style.position='absolute';axis.style.left='0px';axis.style.top='0px';axis.style.textAlign='right';this._cont.appendChild(axis);w=0;items=new Array();for(i=0;i<=this.config.yGrid;i++){value=parseInt((this.ymin+(i*step))*multiplier)/multiplier;item=document.createElement('span');item.appendChild(document.createTextNode(value));axis.appendChild(item);items.push(item);if(item.offsetWidth>w){w=item.offsetWidth}}item=document.createElement('span');item.appendChild(document.createTextNode(this.ymin));axis.appendChild(item);items.push(item);if(item.offsetWidth>w){w=item.offsetWidth}axis.style.width=w+'px';this.chartx=w+5;this.charty=item.offsetHeight/2;this.charth=this.h-((item.offsetHeight*1.5)+5);this.chartw=this.w-(((this.legend)?this.legend.offsetWidth:0)+w+10);this.adjustRange();for(i=0;i<items.length;i++){y=this.charty+this.charth-(i*this.yGridDensity);ty=this.charth-(i*this.yGridDensity);item=items[i];this._painter.fillRect(this.config.textColor,this.chartx-5,y,5,1);item.style.position='absolute';item.style.right='0px';item.style.top=ty+'px';item.style.color=this.config.textColor}};Chart.prototype.drawHorizontalLabels=function(){var axis,item,step,x,tx;var xlen,labels,xgd,precision;labels=this.config.xLabels;axis=document.createElement('div');axis.style.position='absolute';axis.style.left='0px';axis.style.top=(this.charty+this.charth+5)+'px';axis.style.width=this.w+'px';this._cont.appendChild(axis);x=this.chartx;for(i=0;i<this.xlen;i++){item=document.createElement('span');if(labels[i]){item.appendChild(document.createTextNode(labels[i]))}axis.appendChild(item);tx=x-(item.offsetWidth/2);item.style.position='absolute';item.style.left=tx+'px';item.style.top='0px';item.style.color=this.config.textColor;this._painter.fillRect(this.config.textColor,x,this.charty+this.charth,1,5);x+=this.xstep}};function AbstractChartSeries(){}AbstractChartSeries.prototype.getColor=function(){return this.config.color};AbstractChartSeries.prototype.getLabel=function(){return this.config.label};AbstractChartSeries.prototype.getRange=function(chart){var i,ymin,ymax,xlen;var values=this.getStackedValues(chart);xlen=values.length;ymin=values[0];ymax=ymin;for(i=0;i<this.config.values.length;i++){ymin=Math.min(values[i],ymin);ymax=Math.max(values[i],ymax)}return{xlen:xlen,ymin:ymin,ymax:ymax}};AbstractChartSeries.prototype.toOffset=function(){return 0};AbstractChartSeries.prototype.getStackedValues=function(chart){var stacked=new Array();if(this.config.stackedOn){var stackedSeries=chart.find(this.config.stackedOn);if(stackedSeries){stacked=stackedSeries.getStackedValues(chart)}}for(var i=0;i<this.config.values.length;i++){if(stacked[i]){stacked[i]=parseFloat(stacked[i])+parseFloat(this.config.values[i])}else{stacked[i]=this.config.values[i]}}return stacked};AbstractChartSeries.prototype.setConfig=function(name,value){if(!value&&typeof name==Object){this.config=name}else{this.config[name]=value}};AbstractChartSeries.prototype.getConfig=function(){if(name){return this.config[name]}else{return this.config}};function BarChartSeries(config){var defaultConfig={label:"BarChart",color:"#000",values:[],distance:0,width:10,offset:0};for(var p in config){defaultConfig[p]=config[p]}this.config=defaultConfig;this.offset=0}BarChartSeries.prototype=new AbstractChartSeries;BarChartSeries.prototype._getRange=AbstractChartSeries.prototype.getRange;BarChartSeries.prototype.getRange=function(chart){var range=this._getRange(chart);range.xlen++;if(chart.offset&&(!this.config.stackedOn||this.config.stackedOn=='')){this.offset=this.config.distance+chart.offset*(this.config.width+this.config.distance)}else{if(this.config.stackedOn){var stackedOn=chart.find(this.config.stackedOn);if(stackedOn){this.offset=stackedOn.offset}}}return range};BarChartSeries.prototype.toOffset=function(){return(!this.config.stackedOn||this.config.stackedOn=='')?1:0};BarChartSeries.prototype.draw=function(chart){var i,len,x,y,barHt,yBottom,n,yoffset,painter,values;painter=chart.getPainter();values=this.getStackedValues(chart);if(values.length<=0)return;n=chart.range/chart.charth;yoffset=(chart.ymin/n);yBottom=chart.charty+chart.charth+yoffset;len=values.length;if(len>chart.xlen){len=chart.xlen}if(len){x=chart.chartx+this.offset+1;for(i=0;i<len;i++){y=(values[i]/n);barHt=(this.config.values[i]/n);painter.fillRect(this.config.color,x,yBottom-y,this.config.width,barHt);x+=chart.xstep}}};function AreaChartSeries(config){var defaultConfig={label:"AreaChart",color:"#000",values:[]};for(var p in config){defaultConfig[p]=config[p]}this.config=defaultConfig;this.base=AbstractChartSeries}AreaChartSeries.prototype=new AbstractChartSeries;AreaChartSeries.prototype.draw=function(chart){var i,len,x,y,barHt,yBottom,n,yoffset,painter,values;var points=[];painter=chart.getPainter();values=this.getStackedValues(chart);if(values.length<=0)return;n=chart.range/chart.charth;yoffset=(chart.ymin/n);yBottom=chart.charty+chart.charth+yoffset;points.push({x:chart.chartx+1,y:chart.charty+chart.charth-1});len=values.length;if(len>chart.xlen){len=chart.xlen}if(len){for(i=0;i<len;i++){y=(values[i]/n);barHt=(this.config.values[i]/n);points.push({x:chart.chartx+1+chart.xstep*i,y:yBottom-y})}points.push({x:chart.chartx+chart.chartw,y:yBottom-y});points.push({x:chart.chartx+chart.chartw,y:yBottom-y+barHt});for(i=len-1;i>=0;i--){y=(values[i]/n);barHt=(this.config.values[i]/n);points.push({x:chart.chartx+1+chart.xstep*i,y:yBottom-y+barHt})}painter.fillArea(this.config.color,points)}};function LineChartSeries(config){var defaultConfig={label:"LineChart",lineWidth:2,color:"#000",values:[]};for(var p in config){defaultConfig[p]=config[p]}this.config=defaultConfig;this.base=AbstractChartSeries}LineChartSeries.prototype=new AbstractChartSeries;LineChartSeries.prototype.draw=function(chart){var i,len,x,y,n,yoffset,yBottom;painter=chart.getPainter();values=this.getStackedValues(chart);if(values.length<=0)return;var points=[];n=chart.range/chart.charth;yoffset=(chart.ymin/n);yBottom=chart.charty+chart.charth+yoffset;y=0;for(i=0;i<values.length;i++){y=(values[i]/n);points.push({x:chart.chartx+1+i*chart.xstep,y:yBottom-y})}points.push({x:chart.chartx+chart.chartw,y:yBottom-y});painter.polyLine(this.config.color,this.config.lineWidth,points)};function AbstractChartPainter(){};AbstractChartPainter.prototype.create=function(el){};AbstractChartPainter.prototype.getWidth=function(){return this.w};AbstractChartPainter.prototype.getHeight=function(){return this.h};AbstractChartPainter.prototype.fillArea=function(color,points){};AbstractChartPainter.prototype.polyLine=function(color,lineWidth,points){};AbstractChartPainter.prototype.fillRect=function(color,x,y,width,height){};AbstractChartPainter.prototype.line=function(color,lineWidth,x1,y1,x2,y2){};
