<html>
<meta http-equiv="Content-Type" content="text/html;charset=ISO-8859-1">
<head>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js"></script>
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
    <link rel="stylesheet" href="https://code.getmdl.io/1.2.1/material.indigo-pink.min.css">
    <script defer src="https://code.getmdl.io/1.2.1/material.min.js"></script>

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
          integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">

</head>

<script>
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
            var next = "/account/surveyor"
            verify(url, next);
        });
    });

</script>

<body>
<div class="container">
    <div class="row justify-content-center">
        <form id="userVerificationForm">
            <div class="form-group">
                <label for="verifyCode">Confirmation Code</label>
                <input class="form-control" type="text" name ="verifyCode" id="verifyCode" autofocus>
                <span>Enter Verify Code</span>
            </div>
            <button class="btn btn-primary" type="submit">
                Verify
            </button>
        </form>
    </div>
</div>


</body>
</html>
