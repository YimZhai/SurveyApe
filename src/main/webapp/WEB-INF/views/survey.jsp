<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
    <title>Survey</title>
    <script src="https://unpkg.com/jquery"></script>
    <script src="https://surveyjs.azureedge.net/1.0.20/survey.jquery.js"></script>
    <link href="https://surveyjs.azureedge.net/1.0.20/survey.css" type="text/css" rel="stylesheet"/>

    <script src="https://unpkg.com/jquery-bar-rating"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/latest/css/font-awesome.min.css">
    <!-- Themes -->
    <link rel="stylesheet" href="https://unpkg.com/jquery-bar-rating@1.2.2/dist/themes/bars-1to10.css">
    <link rel="stylesheet" href="https://unpkg.com/jquery-bar-rating@1.2.2/dist/themes/bars-movie.css">
    <link rel="stylesheet" href="https://unpkg.com/jquery-bar-rating@1.2.2/dist/themes/bars-square.css">
    <link rel="stylesheet" href="https://unpkg.com/jquery-bar-rating@1.2.2/dist/themes/bars-pill.css">
    <link rel="stylesheet" href="https://unpkg.com/jquery-bar-rating@1.2.2/dist/themes/bars-reversed.css">
    <link rel="stylesheet" href="https://unpkg.com/jquery-bar-rating@1.2.2/dist/themes/bars-horizontal.css">

    <link rel="stylesheet" href="https://unpkg.com/jquery-bar-rating@1.2.2/dist/themes/fontawesome-stars.css">
    <link rel="stylesheet" href="https://unpkg.com/jquery-bar-rating@1.2.2/dist/themes/css-stars.css">
    <link rel="stylesheet" href="https://unpkg.com/jquery-bar-rating@1.2.2/dist/themes/bootstrap-stars.css">
    <link rel="stylesheet" href="https://unpkg.com/jquery-bar-rating@1.2.2/dist/themes/fontawesome-stars-o.css">
    <script src="https://unpkg.com/surveyjs-widgets"></script>


</head>
<body>
<div id="surveyElement"></div>
<div id="surveyResult"></div>

<button onclick="myFunction()">Return</button>

<!-- check if content is empty -->

<script>
    <%@ page import="survey.ape.components.surveyInfo.Survey" %>

    var surveyId = "${surveyGeneral.surveyId}";

    var surveyName = "${surveyGeneral.surveyName}";

    var protectMode = ${surveyGeneral.protectMode};

    console.log("the protect mode is: ", protectMode);

    <%--var usingAccount = "${surveyGeneral.usingAccount}";--%>
    var usingAccount = "";

    // console.log("accountId:" + usingAccount);



    <c:catch var="exception">usingAccount</c:catch>
    <c:choose>
    <c:when test="${not empty exception}">
    console.log("accountId not available.");
    </c:when>
    <c:otherwise>
    usingAccount = "${surveyGeneral.usingAccount}";
    </c:otherwise>
    </c:choose>


    var rJson = {
        surveyId : surveyId,
        accountId : usingAccount
    };

    var cjson = [];

    var initData = {};
    <c:forEach items="${surveyGeneral.questions}" var="question">
    console.log(${question.questionContent});
    var qContent = ${question.questionContent};
    cjson.push(qContent);
    console.log("Inside for loop", cjson);

    var questionId = "${question.questionId}";
    console.log("question id: ", questionId);
    <c:forEach items="${question.answers}" var="answer">
    console.log("answer surveyId: ", surveyId);
    <c:if test="${not empty answer.content}">
    <c:choose>
    <c:when test="${fn:containsIgnoreCase(question.questionContent, 'checkbox')}">
    console.log("answer content: ", ${answer.content});
    initData[questionId] = ${answer.content};
    </c:when>
    <c:otherwise>
    console.log("answer content: ", "${answer.content}");
    initData[questionId] = "${answer.content}";
    </c:otherwise>
    </c:choose>
    </c:if>
    </c:forEach>
    </c:forEach>

    console.log("outside for loop", cjson);

    function myFunction() {
        console.log("inside return button function");
        window.history.back();
    }

    function loadState(survey) {
        survey.data = initData;
        console.log("survey.data = ", initData);
        if(protectMode === true) {
            survey.mode = 'display';
            console.log("set mode display only!!");
        }
    }

    function saveState(survey) {
        //Here should be the code to save the data into your database
        console.log("sResult is ", sResult);
        rJson.content = sResult;

        console.log("survey", survey);

        console.log("stringify rJson: ", JSON.stringify(rJson));

        var xhr = new XMLHttpRequest();
        xhr.open("POST", "/survey/answer");
        xhr.setRequestHeader("Content-Type", "application/json; charset=utf-8");
        xhr.send(JSON.stringify(rJson));

    }

    Survey
        .StylesManager
        .applyTheme("default");


    var djson = {};
    djson.elements = cjson;
    djson.title = surveyName;


    console.log(djson);

    var surveyValueChanged = function(sender, options) {
        var el = document.getElementById(options.name);
        if (el) {
            el.value = options.value;
            console.log("when click on element: ",el);
        }
    };

    window.survey = new Survey.Model(djson);
    var sResult = [];

    survey.onValueChanged.add(function (sender, options) {
        var mySurvey = sender;
        console.log(sender);
        console.log("options", options);
        var questionName = options.name;
        var newValue = options.value;
        console.log("questionName", questionName);

        console.log("newValue", newValue);

        console.log("sender data is ", sender.data);
        sResult = sender.data;
    });


    survey
        .onComplete
        .add(function () {
            console.log("inside the com");
            console.log("sResult is ", sResult);
            rJson.content = sResult;

            console.log("survey", survey);

            console.log("stringify rJson: ", JSON.stringify(rJson));

            var xhr = new XMLHttpRequest();
            xhr.open("POST", "/survey/submit");
            xhr.setRequestHeader("Content-Type", "application/json; charset=utf-8");
            xhr.send(JSON.stringify(rJson));

            // after submit, clear timer
            window.clearInterval(timerId);

            document
                .querySelector('#surveyResult');
        });

    //Load the initial state
    loadState(survey);

    //save the data every 10 seconds, it is a good idea to change it to 30-60 seconds or more.
    timerId = window.setInterval(function () {
        if(usingAccount !== "")
            saveState(survey);
    }, 10000);


    $("#surveyElement").Survey({
        model: survey,
        onValueChanged: surveyValueChanged
    });
</script>

</body>

</html>
