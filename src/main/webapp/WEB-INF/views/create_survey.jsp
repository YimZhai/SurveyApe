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

    <link rel="stylesheet" href="https://unpkg.com/bootstrap-material-design@4.1.1/dist/css/bootstrap-material-design.min.css"
          integrity="sha384-wXznGJNEXNG1NFsbm0ugrLFMQPWswR3lds2VeinahP8N0zJw9VWSopbjv2x7WCvX" crossorigin="anonymous">
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

        var question_name = 1;
        function submitQuestion() {

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

            /*
            {"title":"Choose a color",
            "name":"1",
            "type":"checkbox",
            "choices":[
            "red",
            "blue",
            "yellow",
            "white"]
            }
             */

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
                    },
                    400 : function() {
                        console.log(errorMsg);
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
                if (e.status == 201) {
                    alert("fuck");
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


</script>

<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-2">
            <a href="/account/surveyor">Survey Hub</a>
        </div>
        <div class="col-4"></div>
        <div class="col-2">
            <button id="logout" class="btn btn-primary" onclick="logOutLibrarian();">
            Log Out
            </button>
        </div>
    </div>

    <div class="row justify-content-center">
        <div class="col-6">
            <form id="questionContent">
                <fieldset>Add Question</fieldset>
                <div class="form-group">
                    <label for="surveyType" class="bmd-label-floating">Question Type</label>
                    <select class="form-control" id="surveyType" name="surveyType">
                        <option value="text">Short Answer</option>
                        <option value="radiogroup">Yes or No</option>
                        <option value="checkbox">Multiple Choice</option>
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
                    <button type="submit">Add</button>
                </div>
            </form>
        </div>
    </div>

    <div class="row justify-content-center">
        <div class="col-6">
            <form id="invitationForm">


                <div class="form-group">
                    <label for="toEmail" class="bmd-label-floating">Email</label>
                    <input type="text" class="form-control" id="toEmail" name="toEmail" />

                </div>
                <div class="form-group">
                    <button type="submit" onclick="sendInvitation()">Send Invation</button>
                </div>
            </form>
        </div>
    </div>

    <div class="row justify-content-center">
        <div class="col-6">
            <form id="publish">
                <div class="form-group">
                    <button type="submit" onclick="publishSurvey()">Publish</button>
                </div>
            </form>
        </div>
    </div>

</div>
</body>


</html>