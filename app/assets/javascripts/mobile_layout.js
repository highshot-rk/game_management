window.onscroll = function () {
	if (!canRun) return;
	if (window.pageYOffset > 50) {
		if($("#Menu")[0]){
			document.getElementById("Menu").style.top = "-50px";
		}
		if ($(".Area")[0]){
			document.getElementsByClassName("Area")[0].style.marginTop = "0";
			document.getElementsByClassName("Area")[0].style.position = "fixed";
		}
	} 
	else {
		if($("#Menu")[0]){
			document.getElementById("Menu").style.top = "0px";
		}
		if ($(".Area")[0]){
			document.getElementsByClassName("Area")[0].removeAttribute("style");
		}
	}
}

function mobile_view(x) {
	canRun = !!x.matches;
	if (!canRun) {
		if($("#Menu")[0]){
			document.getElementById("Menu").style.top = "0px";
		}
		if ($(".Area")[0]){
			document.getElementsByClassName("Area")[0].removeAttribute("style");
		}
	}
}

var x = window.matchMedia("(max-width: 700px)");
mobile_view(x);
x.addListener(mobile_view);