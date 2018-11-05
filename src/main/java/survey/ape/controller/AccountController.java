package survey.ape.controller;

import survey.ape.components.accountInfo.Account;
import survey.ape.components.surveyInfo.Survey;
import survey.ape.Reserved_Keyword;
import survey.ape.SurveyApeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.mail.MessagingException;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/account")
public class AccountController {
    @Autowired
    SurveyApeService surveyApeService;

    @ResponseStatus(HttpStatus.CREATED)
    @PostMapping(value = "/signup")
    public void createAccount(@ModelAttribute Account account, HttpSession httpSession) throws MessagingException {
        httpSession.setAttribute(Reserved_Keyword.LOGIN_USER_KEY, account.getAccountId());
        httpSession.setAttribute(Reserved_Keyword.LOGIN_USER_NAME, account.getEmail());
        surveyApeService.createAccount(account);
    }

    @GetMapping(path = "/verify")
    public String verifyAccount() {
        return Reserved_Keyword.ACCOUNT_VERIFY_PAGE;
    }

    @ResponseStatus(HttpStatus.OK)
    @PostMapping(path = "/verify")
    public void verifyAccount(@RequestParam String verifyCode, HttpSession session) {
        surveyApeService.verifyAccount((String)session.getAttribute(Reserved_Keyword.LOGIN_USER_NAME), verifyCode);
        return;
    }

    @ResponseStatus(HttpStatus.OK)
    @PostMapping(path = "/login")
    public void accountLogin(@RequestParam String email,
                               @RequestParam String password,
                               HttpSession httpSession) {
        Account account = surveyApeService.loginAccount(email, password);
        httpSession.setAttribute(Reserved_Keyword.LOGIN_USER_NAME, account.getEmail());
        httpSession.setAttribute(Reserved_Keyword.LOGIN_USER_KEY, account.getAccountId());
    }

    @ResponseStatus(HttpStatus.OK)
    @GetMapping(path = "/surveyor")
    public String getSurveyorPage() {
        return Reserved_Keyword.SURVEYOR_PAGE;
    }

    @ResponseStatus(HttpStatus.OK)
    @GetMapping(path = "/surveyee")
    public String getSurveyeePage() {
        return Reserved_Keyword.SURVEYEE_PAGE;
    }

    @GetMapping(path = "/{email}")
    public @ResponseBody Account getAccount(@PathVariable("email") String email) {
        return surveyApeService.getAccountByEmail(email);
    }

    @PostMapping(path = "/createsurvey", produces = {"application/json"})
    public @ResponseBody
    void createSurvey(HttpSession httpSession,
                        @ModelAttribute Survey survey) {
        String accountId = (String) httpSession.getAttribute(Reserved_Keyword.LOGIN_USER_KEY);
        httpSession.setAttribute(Reserved_Keyword.CURRENT_SURVEY_ID, survey.getSurveyId());
        surveyApeService.createSurvey(accountId, survey);
    }

    @ResponseStatus(HttpStatus.OK)
    @GetMapping(path = "/createsurvey")
    public String getCreateSurveyPage() {
        return Reserved_Keyword.CREATE_SURVEY_PAGE;
    }

    @ResponseStatus(HttpStatus.OK)
    @GetMapping(path = "/surveys", produces = {"application/json"})
    public @ResponseBody Map<String, String> getSurveyNames(HttpSession httpSession) {
        String email = (String) httpSession.getAttribute(Reserved_Keyword.LOGIN_USER_NAME);
        Account account = surveyApeService.getAccountByEmail(email);

        Map<String, String> id2name = new HashMap<>();
        for (Survey survey : account.getCreatedSurveys()) {
            id2name.put(survey.getSurveyId(), survey.getSurveyName());
        }
        return id2name;
    }
}
