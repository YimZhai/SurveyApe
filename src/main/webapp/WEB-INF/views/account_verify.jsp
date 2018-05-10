<html>
<meta http-equiv="Content-Type" content="text/html;charset=ISO-8859-1">
<head>
  <!-- Material Design fonts -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js"></script>
  <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
<link rel="stylesheet" href="https://code.getmdl.io/1.2.1/material.indigo-pink.min.css">
<script defer src="https://code.getmdl.io/1.2.1/material.min.js"></script>
</head>
<style>
#snackbar.show {
	visibility: visible; /* Show the snackbar */
	/* Add animation: Take 0.5 seconds to fade in and out the snackbar.
However, delay the fade out process for 2.5 seconds */
	-webkit-animation: fadein 0.5s, fadeout 0.5s 2.5s;
	animation: fadein 0.5s, fadeout 0.5s 2.5s;
}
#snackbar {
	visibility: hidden; /* Hidden by default. Visible on click */
	min-width: 250px; /* Set a default minimum width */
	margin-left: -125px; /* Divide value of min-width by 2 */
	background-color: #333; /* Black background color */
	color: #fff; /* White text color */
	text-align: center; /* Centered text */
	border-radius: 2px; /* Rounded borders */
	padding: 16px; /* Padding */
	position: fixed; /* Sit on top of the screen */
	z-index: 1; /* Add a z-index if needed */
	left: 50%; /* Center the snackbar */
	bottom: 30px; /* 30px from the bottom */
}
</style>
<script>
function showSnackBar() {
	// Get the snackbar DIV
	var x = document.getElementById("snackbar");

	// Add the "show" class to DIV
	x.className = "show";

	// After 3 seconds, remove the show class from DIV
	setTimeout(function() {
		x.className = x.className.replace("show", "");
	}, 3000);
}

 window.showError=function(errorMessage){
	document.getElementById('snackbar').innerHTML = errorMessage;
	showSnackBar();
}
function verify(url, next) {
	$.ajax({
		type : "POST",
		url : url,
		data: $("#userVerificationForm").serialize(),
		success : function(data) {
		},
		error:function(error){
		    alert(error.responseText);
			window.errorMsg = JSON.parse(error.responseText);

			showError(errorMsg.errorMessage);
			console.log(error);
		},
		statusCode : {
			200 : function() {
                window.location = next;
			},
			400 : function() {
                document.getElementById('snackbar').innerHTML = errorMsg.errorMessage;
                showSnackBar();
			},
			500 : function() {
                document.getElementById('snackbar').innerHTML = errorMsg.errorMessage;
                showSnackBar();
			},
			404 : function() {
                document.getElementById('snackbar').innerHTML = errorMsg.errorMessage;
                showSnackBar();
			},
			409 : function() {
                document.getElementById('snackbar').innerHTML = errorMsg.errorMessage;
                showSnackBar();
			}
		},
		complete : function(e) {
			if (e.status == 200) {
			}
			if (e.status == 400) {
				var errorMessage = JSON.parse(e.responseText);
			}
		}
	});
}


$(document).ready(function() {
	$("#userVerificationForm").submit(function(e) {
		e.preventDefault();
		var url = "/account/verify"
        // var next = "/signup"
        var next = "/account/surveyor"
		verify(url, next);
	});
	
	$("#buttonClick").click(function(e) {
		searchGroups();
	});
});
</script>

<body>
<form   id="userVerificationForm" style="margin-left:450px;margin-top:200px;">
    <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
        <input class="mdl-textfield__input" type="text" name ="verifyCode" id="verifyCode">
        <label class="mdl-textfield__label" for="verifyCode">Confirmation Code</label>
        <span class="mdl-textfield__error">Enter Verify Code</span>
    </div>

    <button class="mdl-button mdl-js-button mdl-js-ripple-effect" type="submit">
        Verify
    </button>
</form>
<div id="snackbar">Some text some message..</div>
</body>
</html>
