<html>
<head>
    <meta charset="utf-8"/>

    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <script defer src="https://code.getmdl.io/1.2.1/material.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.17.1/moment-with-locales.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
            integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.6.4/js/bootstrap-datepicker.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/1.11.8/semantic.min.js"></script>


    <!--<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">-->
    <link rel="stylesheet" href="https://code.getmdl.io/1.2.1/material.indigo-pink.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/1.11.8/semantic.min.css"/>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.6.4/css/bootstrap-datepicker.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datetimepicker/4.17.43/css/bootstrap-datetimepicker.min.css" />

    <%--<link rel="stylesheet" href="https://unpkg.com/bootstrap-material-design@4.1.1/dist/css/bootstrap-material-design.min.css"--%>
          <%--integrity="sha384-wXznGJNEXNG1NFsbm0ugrLFMQPWswR3lds2VeinahP8N0zJw9VWSopbjv2x7WCvX" crossorigin="anonymous">--%>
    <%----%>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
          integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
    <!--
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    -->
</head>

<script>

    $(document).ready(function() {

        // add question
        $("#questionContent").submit(function(e) {
            e.preventDefault();
            if(document.getElementById('questionTitle').value == '') {
                alert("Title cannot be empty");
            }
            else {
                submitQuestion();
            }
        });

        function uuidv4() {
            return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
                var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
                return v.toString(16);
            });
        }

        var question_name = "question_" + uuidv4();
        function submitQuestion() {

            if (document.getElementById("surveyType").value == "rating"){
                console.log("inside rating")
                var question = {
                    title: document.getElementById("questionTitle").value,
                    type: "barrating",
                    name: question_name,
                    ratingTheme: "fontawesome-stars",
                    choices: ["1", "2", "3", "4", "5"]
                };
            }
            else {
                var question = {
                    title: document.getElementById("questionTitle").value,
                    type: document.getElementById("surveyType").value,
                    name: question_name,
                    choices: [
                        document.getElementById("choice1").value,
                        document.getElementById("choice2").value,
                        document.getElementById("choice3").value,
                        document.getElementById("choice4").value
                    ]
                };
            }


            $.ajax({
                type: "POST",
                url: "/survey/question",
                data:  JSON.stringify({"questionContent" : JSON.stringify(question)}),
                dataType: "json",
                contentType: "application/json",
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

            document.getElementById("questionContent").reset();
            question_name += 1;
        }

    });


    // send invitation
    function sendInvitation() {
        $.ajax({
            type: "POST",
            url: "/survey/invitation",
            data: $("#invitationForm").serialize(),
            success: function () {
            },
            error: function (error) {
                window.errorMsg = JSON.parse(error.responseText);
                showError(errorMsg.errorMessage);
                console.log(error);
            },
            statusCode : {
                201 : function() {
                    window.location = '/account/createsurvey';
                }
            },
            complete : function(e) {
                if (e.status == 200) {

                }
            }

        });
        document.getElementById("invitationForm").reset();
    }

    // publish survey
    function publishSurvey() {
        $.ajax({
            type: "POST",
            url: "/survey/publish",
            success: function () {
            },
            error: function (error) {
                window.errorMsg = JSON.parse(error.responseText);
                showError(errorMsg.errorMessage);
                console.log(error);
            },
            statusCode : {
                201 : function() {
                    window.location = '/account/surveyor';
                }
            },
            complete : function(e) {
                if (e.status == 201) {
                    alert("Survey Published");
                }
            }

        });
    }

    // user logout
    $('#logout').click(function(e){
        console.log("clicked button");
        logOutLibrarian();
    });
    function logOutLibrarian() {
        $.ajax({
            type : "GET",
            url : "/logout",
            success : function(data) {
            },
            error: function(error){
                window.errorMsg = JSON.parse(error.responseText);
                showError(errorMsg.errorMessage);
                console.log(error);
            },
            statusCode : {
                200 : function() {
                    window.location = '/signup';
                }
            },
            complete : function(e) {
                if (e.status == 200) {

                }
            }
        });
    }


</script>

<body>
<div class="container">
    <div class="row" style="height: 50px">
        <div class="col-6 text-center">
            <a href="/account/surveyor" role="button" class="mdl-button mdl-js-button mdl-js-ripple-effect">Survey Ape</a>
        </div>

        <div class="col-6 text-center">
            <button id="logout" class="mdl-button mdl-js-button mdl-js-ripple-effect" onclick="logOutLibrarian();">
                Log Out
            </button>
        </div>

    </div>

    <div class="row justify-content-center">
        <div class="col-6">
            <form id="questionContent">
                <div class="form-group">
                    <label for="surveyType" class="bmd-label-floating">Question Type</label>
                    <select class="form-control" id="surveyType" name="surveyType">
                        <option value="text">Short Answer</option>
                        <option value="radio">Yes or No</option>
                        <option value="checkbox">Multiple Choice</option>
                        <option value="rating">Star</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="questionTitle" class="bmd-label-floating">Title</label>
                    <input type="text" class="form-control" id="questionTitle" required/>

                    <label for="choice1" class="bmd-label-floating">Choice 1</label>
                    <input type="text" class="form-control" id="choice1" />

                    <label for="choice2" class="bmd-label-floating">Choice 2</label>
                    <input type="text" class="form-control" id="choice2" />

                    <label for="choice3" class="bmd-label-floating">Choice 3</label>
                    <input type="text" class="form-control" id="choice3" />

                    <label for="choice4" class="bmd-label-floating">Choice 4</label>
                    <input type="text" class="form-control" id="choice4" />

                </div>
                <div class="form-group">
                    <button type="submit" class="btn btn-primary float-right">Add Question</button>
                </div>
            </form>
        </div>
        <div class="col-6">
            <form id="invitationForm">

                <div class="form-group">
                    <label for="toEmail" class="bmd-label-floating">Invite Email</label>
                    <input type="text" class="form-control" id="toEmail" name="toEmail" />

                </div>
                <div class="form-group">
                    <button type="submit" class="btn btn-primary float-left" onclick="sendInvitation()">Send</button>
                </div>
            </form>
            <form id="publish">
                <div class="form-group">
                    <button type="submit" class="btn btn-primary float-right" onclick="publishSurvey()">Publish</button>
                </div>
            </form>
        </div>
    </div>

<%--
    <div class="row justify-content-center">
        <div class="col-6">
            <form id="invitationForm">

                <div class="form-group">
                    <label for="toEmail" class="bmd-label-floating">Invite Email</label>
                    <input type="text" class="form-control" id="toEmail" name="toEmail" />

                </div>
                <div class="form-group">
                    <button type="submit" class="btn btn-primary" onclick="sendInvitation()">Send</button>
                </div>
            </form>
        </div>
    </div>
--%>

<%--    <div class="row justify-content-center">
        <div class="col-6">
            <form id="publish">
                <div class="form-group">
                    <button type="submit" class="btn btn-primary" onclick="publishSurvey()">Publish</button>
                </div>
            </form>
        </div>
    </div>--%>

</div>
</body>


</html>
