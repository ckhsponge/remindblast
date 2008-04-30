function dataChanged() {
	updatePreview();
	updateCustomField();
}



// Nik's javascript

function checkSelected(sel) {
  var y = document.getElementById('custom-message');
  if(sel == 'Other') {
    y.style.display = "block";
  } else {
    y.style.display = "none";
  }
}

var isFirst = true;
// 
function getObj(obj) {
	return document.getElementById(obj);
}
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
function resetForms() {
	getObj('remindForm').reset();
	YAHOO.util.Dom.setStyle(getObj('preview-message'), 'opacity', '0');
	YAHOO.util.Dom.setStyle(getObj('send'), 'opacity', '0');
}
// 
function createPreview() {

	if(isFirst) { 
		fadeIn('preview-message');
		fadeIn('send');
		isFirst = false;
	}
	var recString = getObj('reminder_name').value;
	if (recString.length > 0)
	{
		recString = recString.replace(new RegExp("(.*)\n\n([^#\*\n\n].*)","g"), "<p>$1</p><p>$2</p>");
		recString = recString.replace(new RegExp("(.*)\n([^#\*\n].*)","g"), "$1<br />$2");
	} else {
		recString = "you"
	}
	
	var msgString = getObj('reminder_message').value;
	if(msgString == "Other") {
		msgString = getObj('reminder_custom_message').value;
	}
	if (msgString.length > 0)
	{
		msgString = msgString.replace(new RegExp("(.*)\n\n([^#\*\n\n].*)","g"), "<p>$1</p><p>$2</p>");
		msgString = msgString.replace(new RegExp("(.*)\n([^#\*\n].*)","g"), "$1<br />$2");
	}
	getObj("preview-bulk").innerHTML = "Hey " + recString + "! " + msgString + "<br/><br/> -remindblast.com";
}
// 
function fadeIn(obj) {
	var o = getObj(obj);
	o.style.display = "block";
	var anim = new YAHOO.util.Anim(o, { opacity: { to: 1 } }, 0.25, YAHOO.util.Easing.easeOut);
	anim.animate();
}

function fadeOut(obj) {
	var o = getObj(obj);
	var anim = new YAHOO.util.Anim(o, { opacity: { to: 0 } }, 0.25, YAHOO.util.Easing.easeOut);
	anim.animate();
	o.style.display = "none";
}

window.onload = resetForms;














// chris's javascript

// function updatePreview() {
// 	var name = document.getElementById("reminder_name").value;
// 	var previewText = "";
// 	if(name && name.length>0) {
// 		previewText += "Hey "+name+", ";
// 	}
// 	var message = document.getElementById("reminder_message").value;
// 	if(message == 'Other') {
// 		message = document.getElementById("reminder_custom_message").value;
// 	}
// 	previewText += message;
// 	document.getElementById("preview_text").innerHTML = previewText;
// }
// function updateCustomField() {
// 	var x = document.getElementById('custom_section');
// 	var sel = document.getElementById('reminder_message').value;
// 	if(sel != 'Other') {
// 	  x.style.display = "none";
// 	} else {
// 	  x.style.display = "block";
// 	}
// }

/**
 * @author ckh
 */
	YAHOO.namespace("remindblast.calendar");
	
	YAHOO.remindblast.calendar.init = function() {
	
		function handleSelect(type,args,obj) {
			var dates = args[0]; 
			var date = dates[0];
			var year = date[0], month = date[1], day = date[2];
			
			var txtDate1 = document.getElementById("reminder_start_date");
			txtDate1.value = month + "/" + day + "/" + year;
		}
	
		function updateCal() {
			var txtDate1 = document.getElementById("reminder_start_date");
	
			if (txtDate1.value != "") {
				YAHOO.remindblast.calendar.cal1.select(txtDate1.value);
				var selectedDates = YAHOO.remindblast.calendar.cal1.getSelectedDates();
				if (selectedDates.length > 0) {
					var firstDate = selectedDates[0];
					YAHOO.remindblast.calendar.cal1.cfg.setProperty("pagedate", (firstDate.getMonth()+1) + "/" + firstDate.getFullYear());
					YAHOO.remindblast.calendar.cal1.render();
				} else {
					alert("Cannot select a date before 1/1/2006 or after 12/31/2008");
				}
				
			}
		}
	
		// For this example page, stop the Form from being submitted, and update the cal instead
		function handleSubmit(e) {
			updateCal();
			YAHOO.util.Event.preventDefault(e);
		}
		
		today = new Date();
		today_string = ""+(today.getMonth()+1)+"/"+today.getDate()+"/"+today.getFullYear();
		YAHOO.remindblast.calendar.cal1 = new YAHOO.widget.Calendar("cal1","cal1Container", 
																	{ mindate:today_string,
																	  maxdate:"8/10/2077" });
		YAHOO.remindblast.calendar.cal1.selectEvent.subscribe(handleSelect, YAHOO.remindblast.calendar.cal1, true);
		YAHOO.remindblast.calendar.cal1.render();
	
		//YAHOO.util.Event.addListener("update", "click", updateCal);
		YAHOO.util.Event.addListener("dates", "submit", handleSubmit);
	}
	
	YAHOO.util.Event.onDOMReady(YAHOO.remindblast.calendar.init);