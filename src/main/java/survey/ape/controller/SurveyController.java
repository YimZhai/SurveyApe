package survey.ape.controller;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import survey.ape.Reserved_Keyword;
import survey.ape.components.invitationInfo.Invitation;
import survey.ape.components.surveyInfo.Answer;
import survey.ape.components.surveyInfo.Question;
import survey.ape.components.surveyInfo.Survey;
import survey.ape.components.surveyInfo.SurveyAnswerResult;
import survey.ape.SurveyApeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.security.InvalidParameterException;
import java.text.*;
import java.util.*;

@Controller
@RequestMapping("/survey")
public class SurveyController {

    @Autowired
    SurveyApeService surveyApeService;

    @ResponseStatus(HttpStatus.OK)
    @PostMapping(path = "/question")
    public void saveQuestion(@RequestBody Question question, HttpSession httpSession) throws IOException {
        String surveyId = (String) httpSession.getAttribute(Reserved_Keyword.CURRENT_SURVEY_ID);
        ObjectMapper objectMapper = new ObjectMapper();
        JsonNode rootNode = objectMapper.readTree(question.getQuestionContent());
        question.setQuestionId(rootNode.get("name").asText());
        List<Question> questions = new ArrayList<>();
        questions.add(question);
        surveyApeService.saveQuestions(surveyId, questions);
    }

    @PutMapping(path = "/{surveyId}/question", produces = {"application/json"})
    public void saveQuestions(@PathVariable("surveyId") String surveyId,
                              @RequestBody List<Question> questions) {
        surveyApeService.saveQuestions(surveyId, questions);
    }

    @ResponseStatus(HttpStatus.CREATED)
    @PostMapping(path = "/publish")
    public void publishSurvey(HttpSession httpSession) {
        String surveyId = (String) httpSession.getAttribute(Reserved_Keyword.CURRENT_SURVEY_ID);
        surveyApeService.updateSurvyStatus(surveyId, Survey.Action.PUBLISH, null);
        httpSession.removeAttribute(Reserved_Keyword.CURRENT_SURVEY_ID);
    }

    @PutMapping(path = "/{surveyId}")
    public void updateSurveyStatus(@PathVariable("surveyId") String surveyId,
                                   @RequestParam String action,
                                   @RequestParam String dueDateStr) {
        if (Reserved_Keyword.PUBLISH.equalsIgnoreCase(action)) {
            surveyApeService.updateSurvyStatus(surveyId, Survey.Action.PUBLISH, null);
        } else if (Reserved_Keyword.UNPUBLISH.equalsIgnoreCase(action)) {
            surveyApeService.updateSurvyStatus(surveyId, Survey.Action.UNPUBLISH, null);
        } else if (Reserved_Keyword.EXTEND.equalsIgnoreCase(action)) {
            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd-HH");
            Date dueDate = null;
            try {
                dueDate = format.parse(dueDateStr);
            } catch (ParseException ex) {
                throw new InvalidParameterException("Data format is not correct.");
            }
            surveyApeService.updateSurvyStatus(surveyId, Survey.Action.EXTEND, dueDate);
        } else {
            throw new IllegalStateException();
        }
    }

    @GetMapping(path = "/takeSurvey")
    public String takeSurvey(@RequestParam("surveyId") String surveyId, HttpSession httpSession) {
        httpSession.setAttribute(Reserved_Keyword.SURVEY_TO_TAKE, surveyId);
        return Reserved_Keyword.TAKE_SURVEY_PAGE;
    }

    @ResponseStatus(HttpStatus.OK)
    @GetMapping(path = "/getSurvey", produces = {"application/json"})
    public String getSurvey(HttpSession httpSession, ModelMap model) {
        String surveyId = (String) httpSession.getAttribute(Reserved_Keyword.SURVEY_TO_TAKE);
        String accountId = (String) httpSession.getAttribute(Reserved_Keyword.LOGIN_USER_KEY);
        Survey survey = surveyApeService.getSurvey(surveyId);
        survey.setUsingAccount(accountId);
        surveyApeService.checkSurvey(accountId, survey);
        model.addAttribute("surveyGeneral", survey);
        return "survey";
    }

    // na 05/08/2018
    @GetMapping(path = "/{surveyId}")
    public String getSurvey(@PathVariable("surveyId") String surveyId,
                            ModelMap model,
                            HttpSession httpSession) {
        httpSession.setAttribute(Reserved_Keyword.SURVEY_TO_TAKE, surveyId);
        String accountId = (String) httpSession.getAttribute(Reserved_Keyword.LOGIN_USER_KEY);
        Survey s = surveyApeService.getSurvey(surveyId);
        surveyApeService.checkSurvey(accountId, s);
        model.addAttribute("surveyGeneral", s);
        return "survey";
    }

    @ResponseStatus(HttpStatus.OK)
    @PostMapping(path = "/answer")
    public void saveAnswer(@RequestBody String answersJson) throws IOException {
        saveAnswerInternal(answersJson);
    }

    private String saveAnswerInternal(String answersJson) throws IOException {
        ObjectMapper objectMapper = new ObjectMapper();
        JsonNode jsonNode = objectMapper.readTree(answersJson);
        String surveyId = jsonNode.get(Reserved_Keyword.SURVEY_ID_KEY).asText();
        if (null == surveyId || surveyId.isEmpty()) {
            throw new IllegalArgumentException("SURVEY_ID is null.");
        }
        String accountId = jsonNode.get(Reserved_Keyword.ACCOUNT_ID).asText();

        JsonNode contentNode = jsonNode.get(Reserved_Keyword.CONTENT_KEY);
        List<Answer> answers = new ArrayList<>();
        List<String> questionIds = new ArrayList<>();
        Iterator<String> fieldNames = contentNode.fieldNames();

        while (fieldNames.hasNext()) {
            String questionId = fieldNames.next();
            questionIds.add(questionId);
            Answer answer = new Answer();
            answer.setSurveyId(surveyId);
            answer.setAccountId(accountId);
            if (contentNode.get(questionId).isArray()) {
                if (contentNode.get(questionId).iterator().hasNext())
                    answer.setContent(contentNode.get(questionId).toString());
            } else {
                answer.setContent(contentNode.get(questionId).asText());
            }
            answers.add(answer);
        }
        surveyApeService.saveAnswers(accountId, answers, questionIds);
        return accountId;
    }

    @PostMapping(path = "/invitation")
    public void sendInvitation(@ModelAttribute Invitation invitation, HttpSession httpSession) {
        String surveyId = (String) httpSession.getAttribute(Reserved_Keyword.CURRENT_SURVEY_ID);
        invitation.setUrl(invitation.getUrl() + "/survey/takeSurvey" + "?surveyId=" + surveyId);
        List<Invitation> invitations = new ArrayList<>();
        invitations.add(invitation);
        surveyApeService.sendInvitation(surveyId, invitations);
    }

    @GetMapping(path = "/{surveyId}/result")
    public String getResult(@PathVariable("surveyId") String surveyId, ModelMap model) throws IOException {
        Survey survey = surveyApeService.getSurvey(surveyId);
        SurveyAnswerResult surveyResult = new SurveyAnswerResult();
        surveyResult.setStartTime(survey.getCreateTime().toString());
        surveyResult.setEndTime(survey.getExpireTime().toString());
        surveyResult.setParticipants(survey.getParticipantNum());
        surveyResult.setParticipationRate((double) survey.getParticipantNum() / (double) survey.getInvitationNum());

        Map<String, Map<String, Integer>> countMultipleChoice = surveyResult.getMcqToCount();
        Map<String, List<String>> textAnswers = surveyResult.getTextAnswers();
        Map<Integer, String> responseRates = surveyResult.getResponseRates();

        int questionNumber = 1;
        for (Question question: survey.getQuestions()) {
            String content = question.getQuestionContent();
            ObjectMapper objectMapper = new ObjectMapper();
            JsonNode jsonNode = objectMapper.readTree(content);
            String questionContent = jsonNode.get(Reserved_Keyword.QUESTION).asText();
            String type = jsonNode.get(Reserved_Keyword.QUESTION_TYPE).asText();

            if (type.equals(Reserved_Keyword.MCQ)) {
                Map<String, Integer> optionsCount = new HashMap<>();
                Iterator<JsonNode> mcqOptions = jsonNode.get(Reserved_Keyword.MCQ_OPTIONS).iterator();

                while (mcqOptions.hasNext()) {
                    String mcqOption = mcqOptions.next().asText();
                    optionsCount.put(mcqOption, 0);
                }

                for (Answer answer: question.getAnswers()) {
                    String mcqContent = answer.getContent();
                    String[] options = mcqContent.substring(1,mcqContent.length()-1).split(",");
                    for (String option: options) {
                        String keyOption = option.substring(1, option.length()-1);
                        optionsCount.put(keyOption, optionsCount.get(keyOption)+1);
                    }
                }
                countMultipleChoice.put(questionContent, optionsCount);
            } else if (type.equals(Reserved_Keyword.TEXT)) {
                List<String> testAnswers = new ArrayList<>();
                for (Answer answer: question.getAnswers()) {
                    testAnswers.add(answer.getContent());
                }

                textAnswers.put(questionContent, testAnswers);
            }

            Double responseRate = ((double)question.getAnswers().size())/survey.getParticipantNum();
            DecimalFormat format = new DecimalFormat("##.00");
            double rate = Double.parseDouble(format.format(responseRate));

            rate *= 100.0;

            Double rateStr = Double.parseDouble(format.format(rate));

            responseRates.put(questionNumber, rateStr.toString()+"%");
            questionNumber++;
        }
        surveyResult.prepareMCQ();
        model.addAttribute("surveyResult", surveyResult);
        return "survey_result";
    }

    @PostMapping(path = "/submit")
    public void submitSurvey(@RequestBody String answersJson, HttpSession httpSession) throws IOException {
        String surveyId = (String) httpSession.getAttribute(Reserved_Keyword.SURVEY_TO_TAKE);
        if (null == surveyId || surveyId.isEmpty()) {
            throw new IllegalArgumentException();
        }
        String accountId = saveAnswerInternal(answersJson);
        surveyApeService.submitSurvey(surveyId, accountId);
    }
}
