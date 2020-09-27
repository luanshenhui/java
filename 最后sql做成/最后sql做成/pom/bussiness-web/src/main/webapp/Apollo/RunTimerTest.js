Test = 
{	
	results : [],
	timestamp : null,
	title : '',
	totalTime : 0,
	browserInfo : (function()
	{	
		var userAgent = navigator.userAgent.toLowerCase(),name;
		if( /webkit/.test( userAgent ) ) name = 'Safari';
		else if( /opera/.test( userAgent ) ) name = 'Opera';
		else if( /msie/.test( userAgent ) && !/opera/.test( userAgent ) ) name = 'MSIE';
		else if( /mozilla/.test( userAgent ) && !/(compatible|webkit)/.test( userAgent ) ) name = 'Mozilla Firefox';		
		return name;
	})(),
	run : function( name )
	{
		this.title = name;
		this.timestamp = new Date();
	},
	stop : function()
	{
		var entity =  { 
			title : this.title || this.results.length+1,  
			time : new Date() - this.timestamp
		};
		this.results.push( entity );
		this.totalTime += entity.time;
		this.title = this.timestamp = null;
	},
	clear : function()
	{
		this.totalTime = this.results.length = 0;
	},
	output : function( title )
	{
		var d = document, section, curr, title , row , cell, val ,panel, result = this.results;
		var template = '<div style="border:1px solid #ccc;font-size:1px;position:relative;width:200px;height:10px;background:#eee;padding:1px;margin-right:5px;">' + 
		'<div style="height:4px;font:1px/0 arial ;background:white;position:absolute;left:0;width:100%;opacity:0.8;filter:alpha(opacity=80)"></div>' +
		'<div style="font-size:9px;text-indent:5px;line-height:10px;position:absolute;color:#333">{value}%</div>' +
		'<div style="height:10px;width:{value}%;background:#19D73D"></div></div>'
		
		with( panel = d.body.appendChild( d.createElement( 'table' ) ) )
		{
			cellSpacing = '0';
			cellPadding = '3';
			style.cssText = 'font:12px/1 georgia;'; 
		}
		panel.createCaption().style.cssText = 'text-align:left;padding:5px;';
		for( var i=0, l=result.length; i<l; i++ )
		{ 
			curr = result[i];
			val = Math.round( curr.time/this.totalTime * 100 );			
			row = panel.insertRow(-1);
			cell = row.insertCell(-1);
			cell.align = 'right';
			cell.innerHTML = curr.title;
			row.insertCell(-1).innerHTML = template.replace( /{value}/g,val )  ;
			row.insertCell(-1).innerHTML = '<span> 耗时: ' + curr.time + ' 毫秒</span>'
		}
		panel.caption.innerHTML = '<h3 style="font-size:14px">' + title + '</h3>在' + this.browserInfo + '下运行结果<br /><br />总耗时: ' + 
		this.totalTime + 
		' 毫秒,平均每次执行: ' + ( this.totalTime/result.length  ).toFixed() + ' 毫秒'; 
		this.clear();
		panel = null;
	},
	exec : function( fn,time,title )
	{
		time = time||5000;
		this.run( title + '(' + time + '次)' );
		while( time-- )fn();
		this.stop(); 
	}
}