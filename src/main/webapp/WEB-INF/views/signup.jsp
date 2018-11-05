<script
        src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<html>
<head>
    <link rel="stylesheet"
          href="https://fonts.googleapis.com/icon?family=Material+Icons">
    <link rel="stylesheet"
          href="https://code.getmdl.io/1.2.1/material.indigo-pink.min.css">
    <script defer src="https://code.getmdl.io/1.2.1/material.min.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
          integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">

</head>

<script>

    function signUp(url, next) {
        console.log("This is the URL"+url);
        $.ajax({
            type : "POST",
            url : url,
            data : $("#createUserForm").serialize(),
            success : function(data) {
            },
            error : function(error) {
                console.log(error);
                alert("go to " + error.responseText);
                errorMsg = JSON.parse(error.responseText);
            },
            statusCode : {
                201 : function() {
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

                } else {
                    document.getElementById('snackbar').innerHTML = errorMsg.errorMessage;
                    showSnackBar();
                }
            }
        });
    }

    function validateMyFields(){

        var firstName = document.getElementById("firstName").value;
        var lastName = document.getElementById("lastName").value;
        var email = document.getElementById("signupEmail").value;
        var password = document.getElementById("password").value;

        if(firstName == "" || lastName == "" || email == "" || password == ""){
            alert("Missing required fields");
            return 0;
        }
        return 1;
    }

    $(document).ready(function() {
        var sjsuEmailValue ="SJSU.EDU";
        var errorMsg;

        $("#createUserForm").submit(function(e) {
            e.preventDefault();

            var result =  parseInt(validateMyFields());
            if(result == 1){

                var url = "/account/signup";
                var next = "/account/verify";
                signUp(url, next);
            }
        });

        $("#buttonClick").click(function(e) {
            searchGroups();
        });
    });
</script>

<body>
<div class="container">
    <div class="row justify-content-center">
        <h1 style="text-align:center;">Survey Ape</h1>
    </div>

    <div class="row justify-content-center">
        <div class="col-6">
            <form id="createUserForm">
                <h3 style="text-align: center">Create an Account</h3>
                <div class="form-group">
                    <label for="firstname">First Name</label>
                    <input class="form-control" type="text" id="firstName" name="firstName" required>
                </div>
                <div class="form-group">
                    <label for="lastname">Last Name</label>
                    <input class="form-control" type="text" id="lastName" name="lastName">
                </div>
                <div class="form-group">
                    <label for="signupEmail">Username</label>
                    <input class="form-control" type="email" id="signupEmail" name="email" aria-describedby="emailHelpInline">
                    <small id="emailHelpInline" class="text-muted">
                        Must be valid email address
                    </small>
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input class="form-control" type="password" id="password" name="password"
                           pattern="((?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%]).{6,20})" aria-describedby="passwordHelpInline">
                    <small id="passwordHelpInline" class="text-muted">
                        Password must contain Uppercase,lowercase,special character & a Number. Length between 6 and 20
                    </small>
                </div>
                <div class="form-group">
                    <label for="loginType">Account Type</label>
                    <select class="form-control" id="loginType" name="loginType">
                        <option value="0">Surveyor</option>
                        <option value="1">Surveyee</option>
                    </select>
                </div>
                <button class="btn btn-primary float-right">
                    Sign Up
                </button>
            </form>
        </div>
    </div>
</div>


</body>
</html>