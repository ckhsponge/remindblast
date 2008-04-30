// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function dataChanged() {
	updatePreview();
	updateCustomField();
}

// function checkSelected(sel) {
//   var x = document.getElementById('custom_section');
//   var y = document.getElementById('othermsg');
//   if(sel != 'Other') {
//     x.style.display = "none";
//     y.style.display = "block";
//   } else {
//     x.style.display = "block";
//     y.style.display = "none";
//   }
// }
// 
// var isFirst = true;
// 
// function getObj(obj) {
// 	return document.getElementById(obj);
// }
// 
// function checkSelected(sel) {
// 	if(sel == 'Other') {
// 		fadeOut('custom');
// 		fadeIn('custom-message');
// 	} else {
// 		fadeIn('custom');
// 		fadeOut('custom-message');
// 	}
// }
// 
// function resetForms() {
// 	getObj('remindForm').reset();
// 	YAHOO.util.Dom.setStyle(getObj('preview-message'), 'opacity', '0');
// 	YAHOO.util.Dom.setStyle(getObj('send'), 'opacity', '0');
// }
// 
// function createPreview() {
// 
// 	if(isFirst) { 
// 		fadeIn('preview-message');
// 		fadeIn('send');
// 		isFirst = false;
// 	}
// 	var recString = getObj('recipient').value;
// 	if (recString.length > 0)
// 	{
// 		recString = recString.replace(new RegExp("(.*)\n\n([^#\*\n\n].*)","g"), "<p>$1</p><p>$2</p>");
// 		recString = recString.replace(new RegExp("(.*)\n([^#\*\n].*)","g"), "$1<br />$2");
// 	}
// 	
// 	var msgString = getObj('message').value;
// 	if(msgString == "Other") {
// 		msgString = getObj('cmessage').value;
// 	}
// 	if (msgString.length > 0)
// 	{
// 		msgString = msgString.replace(new RegExp("(.*)\n\n([^#\*\n\n].*)","g"), "<p>$1</p><p>$2</p>");
// 		msgString = msgString.replace(new RegExp("(.*)\n([^#\*\n].*)","g"), "$1<br />$2");
// 	}
// 	getObj("preview-bulk").innerHTML = "Hey " + recString + "! " + msgString;
// }
// 
// function fadeIn(obj) {
// 	var o = getObj(obj);
// 	o.style.display = "block";
// 	var anim = new YAHOO.util.Anim(o, { opacity: { to: 1 } }, 0.25, YAHOO.util.Easing.easeOut);
// 	anim.animate();
// }
// 
// function fadeOut(obj) {
// 	var o = getObj(obj);
// 	var anim = new YAHOO.util.Anim(o, { opacity: { to: 0 } }, 0.25, YAHOO.util.Easing.easeOut);
// 	anim.animate();
// 	o.style.display = "none";
// }
// 
// window.onload = resetForms;
