function dataChanged() {
	updatePreview();
	updateCustomField();
}
function updatePreview() {
	var name = document.getElementById("reminder_name").value;
	var previewText = "";
	if(name && name.length>0) {
		previewText += "Hey "+name+", ";
	}
	var message = document.getElementById("reminder_message").value;
	if(message == 'Other') {
		message = document.getElementById("reminder_custom_message").value;
	}
	previewText += message;
	document.getElementById("preview_text").innerHTML = previewText;
}
function updateCustomField() {
	var x = document.getElementById('custom_section');
	var sel = document.getElementById('reminder_message').value;
	if(sel != 'Other') {
	  x.style.display = "none";
	} else {
	  x.style.display = "block";
	}
}

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