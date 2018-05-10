<html>
<head>
    <meta charset="utf-8"/>
    <!-- Material Design fonts -->

    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
    <link rel="stylesheet" href="https://code.getmdl.io/1.2.1/material.indigo-pink.min.css">


    <script defer src="https://code.getmdl.io/1.2.1/material.min.js"></script>

    <link href = "https://code.jquery.com/ui/1.10.4/themes/ui-lightness/jquery-ui.css" rel = "stylesheet">
      
    <script src = "https://code.jquery.com/ui/1.10.4/jquery-ui.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datetimepicker/4.17.43/css/bootstrap-datetimepicker.css" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.17.1/moment-with-locales.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.6.4/js/bootstrap-datepicker.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.6.4/css/bootstrap-datepicker.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datetimepicker/4.17.43/css/bootstrap-datetimepicker.min.css" />

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script src = "https://code.jquery.com/jquery-1.10.2.js"></script>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datetimepicker/4.17.43/js/bootstrap-datetimepicker.min.js"></script>
      
      
      
      
      
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/1.11.8/semantic.min.css"/>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/1.11.8/semantic.min.js"></script>
 
   
   
</head>

<style>
.mdl-layout__content{
	padding: 24px;
	flex: none;
}
#snackbar.show {
	visibility: visible; /* Show the snackbar */
	/* Add animation: Take 0.5 seconds to fade in and out the snackbar.
However, delay the fade out process for 2.5 seconds */
	-webkit-animation: fadein 0.5s, fadeout 0.5s 2.5s;
	animation: fadein 0.5s, fadeout 0.5s 2.5s;
}
#addkeyword{
  position: absolute;
  margin-top: 10px;
  margin-left: 270px;
}
#library1{
  height:700px;
  margin-top: 30px;
}
#buttonsclass{
margin-top:20px;
margin-left:0px;
}
#searchform{
  margin-left: 500px;
  margin-bottom: 30px;
}
#logout{
position:absolute;
margin-left:1000px;
width:100px;
color:white;
}
#searchbutton{
  margin-left: 230px;

}
#mycart{
  margin-left: 450px;
  margin-bottom: 40px;
}
#mainform{
  margin-left: 390px;
}
#updatebook{
      margin-left: 390px;
}
#updatebutton{
  margin-top: 20px;
}
#chooselibrarian{
  height:300px;
  margin-left: 300px;
}
#library1{
  height:300px;
  margin-left: 300px;
}
#hi{
  margin-left: 90px;
}
#datepicker3{
  position: fixed;
  margin-left: 860px;
  border-radius: 5px;
  border-style: solid;
  margin-top: 10px;
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
<body>
<script>
    window.keywordList=[];
</script>
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




	$(document).ready(function() {

		$(function () {
            $('#datetimepicker4').datetimepicker({
            	 defaultDate:systemdate
            });
        });



		// logout function
        $('#logout').click(function(e){
        	console.log("clicked button");
        	logOutLibrarian();	
        });
        function logOutLibrarian() {	
        	$.ajax({
        		type : "GET",
        		url : "/signup",
        		success : function(data) {
        		},
        		error: function(error){
        			window.errorMsg = JSON.parse(error.responseText);

        			showError(errorMsg.errorMessage);
        			console.log(error);
        		},
        		statusCode : {
        			200 : function() {
        				window.location = "/signup";
        			},
        			400 : function() {
        				
        			},
        			500 : function() {
        				
        			},
        			404 : function() {
        				
        				
        			},
        			409 : function() {
        			}
        		},
        		complete : function(e) {
        			if (e.status == 200) {
        														
        			}
        		}
        	});
        }


        // create survey
        $("#createsurvey").submit(function(e) {
            e.preventDefault();
            if (document.getElementById('surveyName').value == '') {
                alert("Please enter name of the survey");
            }
            else {
                createSurvey();
            }
        });

        function createSurvey() {
            $.ajax({
                type: "POST",
                url: "createsurvey",
                data: $("#createsurvey").serialize(),
                success: function (data) {
                },
                error: function (error) {
                    window.errorMsg = JSON.parse(error.responseText);

                    showError(errorMsg.errorMessage);
                    console.log(error);
                },
                statusCode : {
                    200 : function() {
                        window.location = '/account/createsurvey';
                    },
                    400 : function() {

                    },
                    500 : function() {

                    },
                    404 : function() {


                    },
                    409 : function() {
                    }
                },
                complete : function(e) {
                    if (e.status == 200) {

                    }
                }
            });
        }

        $(function() {
            $( "#expireTime" ).datepicker();
        });
		
	});

</script>

<!-- Simple header with scrollable tabs. -->
       
  
<div class="mdl-layout mdl-js-layout mdl-layout--fixed-header">
    <header class="mdl-layout__header">
        <div class="mdl-layout__header-row">
            <!-- Title -->
            <button id="logout"class="mdl-button mdl-js-button mdl-js-ripple-effect" onclick="logOutLibrarian();" style="width:200px;">
                Log Out
            </button>
            <span class="mdl-layout-title">SJSU Library</span>
        </div>
        <!-- Tabs -->
        <div class="mdl-layout__tab-bar mdl-js-ripple-effect">
            <a href="#scroll-tab-1" class="mdl-layout__tab is-active">Surveys</a>
            <a href="#scroll-tab-2" class="mdl-layout__tab">Create</a>
            <a href="#scroll-tab-3" class="mdl-layout__tab">Search By Librarian</a>
            <a href="#scroll-tab-4" class="mdl-layout__tab">Add</a>
        </div>
    </header>
    <main class="mdl-layout__content" style="height:800px;">
        <section class="mdl-layout__tab-panel is-active" id="scroll-tab-1">
            <p>Welcome to Survey Ape</p>
            <script>
                  function getSurvey() {
                      var question = $('#questions');
                      $.ajax({
                          type: "GET",
                          url: "/account/surveys",
                          success: function (data) {
                              var output = "<table><thead><tr><th>Survey Name</th></thead><thbody>";
                              for (var i in data)
                              {
                                  output += "<tr><td>" + data[i] + "</td></tr>";
                              }
                              output += "</tbody></table>";

                              question.html(output);
                          },
                          error: function (jqXHR, textStatus, errorThrown) {
                              alert("error");
                          },
                          dataType: "json"
                      });
                  }
            </script>

            <button type="submit" onclick="getSurvey()">List Survey</button>
            <div id="questions"></div>

        </section>



        <section class="mdl-layout__tab-panel" id="scroll-tab-2">
            <!-- Your content goes here -->
            <div class="page-content" >
                <form class="form-inline" id="createsurvey">
                    <div class="form-group">
                        <label for="surveyName" class="bmd-label-floating">Title</label>
                        <input type="text" class="form-control" id="surveyName" name="surveyName">
                    </div>
                    <div class="form-group">
                        Date: <input type="text" id="expireTime" name="expireTime">
                    </div>
                    <div class="form-group">
                        <label for="surveyType" class="bmd-label-floating">Survey Type</label>
                        <select class="form-control" id="surveyType" name="surveyType">
                            <option>General</option>
                            <option>Invation-Only</option>
                            <option>Unique</option>
                        </select>
                    </div>
                    <span class="form-group bmd-form-group">
                        <button type="submit">Create</button>
                    </span>
                </form>
            </div>
            <div id="hi"></div>
        </section>

        <section class="mdl-layout__tab-panel" id="scroll-tab-3">
            <p>Please select a Librarian From the Dropdown List</p>
            <div class="page-content" id="library1" style="margin-left:20%">
            </div>

        <!-- Your content goes here -->
        </section>

    </main>
   
    <div id="snackbar">Some text some message..</div>
</div>
</body>
</html>