var path = '/assets/screenshots/'
var screenshots = ['screenshot1.png','screenshot2.png','screenshot3.png','screenshot4.png','screenshot5.png'];

function preload(screenshots) {
  	$(screenshots).each(function () {
  	$('<img />').attr('src',this).appendTo('body').hide();
  });
}

preload(screenshots);

$(document).ready(function(){


	var $screenshot = $('.screenshot');
	var i = 0
	var rotateScreenshot = setInterval(function(){
		$screenshot.attr("src", path + screenshots[i])
		if(i>=4)
			i=0;
		else
			i++;
	}, 750);

});