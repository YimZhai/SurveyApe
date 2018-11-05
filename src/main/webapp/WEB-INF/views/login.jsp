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

    function login(url, next) {
        console.log("next: " + next)
        $.ajax({
                type : "POST",
                url : url,
                data : $("#accountLoginForm").serialize(),
                success : function(data) {
                },
                error : function(error) {
                    console.log(error);
                    errorMsg = JSON.parse(error.responseText);
                },
                statusCode : {
                    200 : function() {
                        window.location = next;
                    }
                },
                complete : function(e) {
                }
            });
    }


    $(document).ready(function() {
        $("#accountLoginForm").submit(function(e) {
            e.preventDefault();

            var url = "/account/login";
            var next;
            console.log(document.getElementById("loginType").value);
            if (document.getElementById("loginType").value == 0) {
                next = "/account/surveyor";
            } else {
                next = "/account/surveyee";
            }
            login(url, next);
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
            <form id="accountLoginForm">
                <div class="form-group">
                    <label for="loginType">Account Type</label>
                    <select class="form-control" id="loginType" name="loginType">
                        <option value="0">Surveyor</option>
                        <option value="1">Surveyee</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="loginType">Username</label>
                    <input class="form-control" type="email" id="loginEmail" name="email" aria-describedby="emailHelpInline">
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
                <button class="btn btn-primary float-right">
                    Log In
                </button>
            </form>
        </div>
    </div>
    <div class="row justify-content-center">
        <a href="/signup">Create new account</a>
    </div>
</div>

</body>
</html>