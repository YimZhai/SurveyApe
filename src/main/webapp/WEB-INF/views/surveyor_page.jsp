<html>
<head>
    <meta charset="utf-8"/>
    <!-- Material Design fonts -->

    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
    <link rel="stylesheet" href="https://code.getmdl.io/1.2.1/material.indigo-pink.min.css">


    <script defer src="https://code.getmdl.io/1.2.1/material.min.js"></script>



    <script src = "https://code.jquery.com/ui/1.10.4/jquery-ui.js"></script>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.17.1/moment-with-locales.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.6.4/js/bootstrap-datepicker.js"></script>



    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script src = "https://code.jquery.com/jquery-1.10.2.js"></script>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datetimepicker/4.17.43/js/bootstrap-datetimepicker.min.js"></script>


    <script src="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/1.11.8/semantic.min.js"></script>

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
          integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">

   
</head>

<style>

    .mdl-layout__content{
        padding: 24px;
        flex: none;
    }

    #logout{
    position:absolute;
    margin-left:1000px;
    width:100px;
    color:white;
    }

</style>

<body onload="getEverything()">

    <script>
        window.keywordList=[];
        function getEverything() {
            getSurvey();
            getReport();
        }
    </script>

    <script>
        $(document).ready(function() {
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
                            window.location = "/login";
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

       
  
<div class="mdl-layout mdl-js-layout mdl-layout--fixed-header container-fluid">
    <header class="mdl-layout__header">
        <div class="mdl-layout__header-row">
            <!-- Title -->
            <button id="logout"class="mdl-button mdl-js-button mdl-js-ripple-effect" onclick="logOutLibrarian();" style="width:200px;">
                Log Out
            </button>
            <span class="mdl-layout-title">Survey Ape</span>
        </div>
        <div class="mdl-layout__tab-bar mdl-js-ripple-effect">
            <a href="#scroll-tab-1" class="mdl-layout__tab is-active">Survey</a>
            <a href="#scroll-tab-2" class="mdl-layout__tab">Create</a>
            <a href="#scroll-tab-3" class="mdl-layout__tab">Report</a>
        </div>
    </header>
    <main class="mdl-layout__content" style="height:800px;">
        <section class="mdl-layout__tab-panel is-active" id="scroll-tab-1">
            <script>
                console.log("${surveyorId}");

                  function getSurvey() {
                      var question = $('#questions');
                      $.ajax({
                          type: "GET",
                          url: "/account/surveys",
                          success: function (data) {
                              var output = "<table class='table'><thead><tr><th scope='col'>ID</th><th scope='col'>Survey</th></thead><thbody>";
                              for (var key in data)
                              {
                                  output += "<tr><th scope='row'>" + key + "</th><td><a href='/survey/" + key + "'>" + data[key] + "</a></td></tr>";
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

            <div class="col-6" id="questions"></div>

        </section>



        <section class="mdl-layout__tab-panel" id="scroll-tab-2">
            <div class="page-content row">
                <div class="col-3">
                    <form id="createsurvey">
                        <div class="form-group">
                            <label for="surveyName" class="bmd-label-floating">Title</label>
                            <input type="text" class="form-control" id="surveyName" name="surveyName">
                        </div>
                        <div class="form-group">
                            <label for="expireTime" class="bmd-label-floating">Expire Time</label>
                            <input type="text" class="form-control" id="expireTime" name="expireTime" aria-describedby="timeHelpInline">
                            <small id="timeHelpInline" class="text-muted">
                                Date format: MM/DD/YYYY
                            </small>
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
                            <button class="btn btn-primary float-right" type="submit">Create</button>
                        </span>
                    </form>
                </div>
            </div>
        </section>

        <section class="mdl-layout__tab-panel" id="scroll-tab-3">
            <script>
                function getReport() {
                    var report = $('#report');
                    $.ajax({
                        type: "GET",
                        url: "/account/surveys",
                        success: function (data) {
                            var output = "<table class='table'><thead><tr><th scope='col'>ID</th><th scope='col'>Survey</th></thead><thbody>";
                            for (var key in data)
                            {
                                output += "<tr><th scope='row'>" + key + "</th><td><a href='/survey/" + key + "/result'>" + data[key] + "</a></td></tr>";
                            }
                            output += "</tbody></table>";

                            report.html(output);
                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            alert("error");
                        },
                        dataType: "json"
                    });
                }
            </script>

            <div class="col-6" id="report"></div>

        </section>

    </main>
</div>
</body>
</html>
