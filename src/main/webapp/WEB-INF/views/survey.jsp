<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>The example of showing survey as a popup window, jQuery Survey Library Example</title>
    <script src="https://unpkg.com/jquery"></script>
    <script src="https://surveyjs.azureedge.net/1.0.20/survey.jquery.js"></script>
    <link href="https://surveyjs.azureedge.net/1.0.20/survey.css" type="text/css" rel="stylesheet"/>


</head>
<body>
<div id="surveyElement"></div>
<div id="surveyResult"></div>

<script>
    <%@ page import="edu.sjsu.cmpe275.domain.Survey" %>


    var surveyId = "${surveyGeneral.surveyId}";
    console.log(surveyId);
    var cjson = [];

    <c:forEach items="${surveyGeneral.questions}" var="question">
     console.log(${question.questionContent});

     cjson.push(${question.questionContent});
     console.log(cjson);

    </c:forEach>

    cjson[0]["type"] = "checkbox";
    cjson[0]["choices"] = cjson[0]["choice"];
    console.log(cjson);


    var djson = {};
    djson.questions = cjson;


    /*   $(document).ready(function(urlString){
           $.ajax({
               url: urlString,
               type: "GET",
               success: function(data) {
                   console.log(data);
                   window.survey = new Survey.Model(json);
               }, //data holds {success:true} - see below
               error: function(error) {
                   console.log(error);
                   errorMsg = JSON.parse(error.responseText);}
           });
       })*/
</script>

<script>
    var surveyValueChanged = function(sender, options) {
        var el = document.getElementById(options.name);
        if (el) {
            el.value = options.value;
        }
    };

    Survey
        .StylesManager
        .applyTheme("default");

/*
    var json = {
        questions: [{
            type: "checkbox",
            name: "car",
            title: "What car are you driving?",
            isRequired: true,
            colCount: 4,
            choices: [
                "None",
                "Ford",
                "Vauxhall",
                "Volkswagen",
                "Nissan",
                "Audi",
                "Mercedes-Benz",
                "BMW",
                "Peugeot",
                "Toyota",
                "Citroen"
            ]
        }]
    };
*/

    window.survey = new Survey.Model(djson);


    survey
        .onComplete
        .add(function(result) {
            console.log("inside survey add");

            document
                .querySelector('#surveyResult');
                /*.innerHTML = "result: " + JSON.stringify(result.data);*/
        });

/*    survey.data = {
        name: 'John Doe',
        email: 'johndoe@nobody.com',
        car: ['Ford']
    };*/

    $("#surveyElement").Survey({
        model: survey,
        onValueChanged: surveyValueChanged
    });
</script>

</body>

</html>