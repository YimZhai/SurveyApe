package edu.sjsu.cmpe275.web;

import edu.sjsu.cmpe275.domain.Account;
import edu.sjsu.cmpe275.domain.Survey;
import edu.sjsu.cmpe275.service.SurveyHubService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.mail.MessagingException;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/account")
public class AccountController {
    @Autowired
    SurveyHubService surveyHubService;

    private final static String ACCOUNT_VERIFY_PAGE = "account_verify";
    private final static String LOGIN_USER_KEY = "login_user_key";
    private final static String LOGIN_USER_NAME = "login_user_name";
    private final static String CURRENT_SURVEY_ID = "current_survey_id";
    private final static String SURVEYOR_PAGE = "surveyor_page";
    private final static String SURVEYEE_PAGE = "surveyee_page";
    private final static String CREATE_SURVEY_PAGE = "create_survey";

    @ResponseStatus(HttpStatus.CREATED)
    @PostMapping(value = "/signup")
    public void createAccount(@ModelAttribute Account account, HttpSession httpSession) throws MessagingException {
        System.out.println("createAccount");
        httpSession.setAttribute(LOGIN_USER_KEY, account.getAccountId());
        httpSession.setAttribute(LOGIN_USER_NAME, account.getEmail());
        surveyHubService.createAccount(account);
    }

    @GetMapping(path = "/verify")
    public String verifyAccount() {
        System.out.println("GET verify page");
        return ACCOUNT_VERIFY_PAGE;
    }

    @ResponseStatus(HttpStatus.OK)
    @PostMapping(path = "/verify")
    public void verifyAccount(@RequestParam String verifyCode, HttpSession session) {
        System.out.println("POST verify page");
        surveyHubService.verifyAccount((String)session.getAttribute(LOGIN_USER_NAME), verifyCode);
        return;
    }

    @ResponseStatus(HttpStatus.OK)
    @PostMapping(path = "/login")
    public void accountLogin(@RequestParam String email,
                               @RequestParam String password,
                               HttpSession httpSession) {
        System.out.println("POST login page");
        Account account = surveyHubService.loginAccount(email, password);
        httpSession.setAttribute(LOGIN_USER_NAME, account.getEmail());
        httpSession.setAttribute(LOGIN_USER_KEY, account.getAccountId());
    }

    @ResponseStatus(HttpStatus.OK)
    @GetMapping(path = "/surveyor")
    public String getSurveyorPage() {
        System.out.println("GET surveyor page");
        return SURVEYOR_PAGE;
    }

    @ResponseStatus(HttpStatus.OK)
    @GetMapping(path = "/surveyee")
    public String getSurveyeePage() {
        System.out.println("GET surveyee page");
        return SURVEYEE_PAGE;
    }

    @GetMapping(path = "/{email}")
    public @ResponseBody Account getAccount(@PathVariable("email") String email) {
        System.out.println("GET account by email");
        return surveyHubService.getAccountByEmail(email);
    }

    @PostMapping(path = "/createsurvey", produces = {"application/json"})
    public @ResponseBody
    void createSurvey(HttpSession httpSession,
                        @ModelAttribute Survey survey) {
        System.out.println("POST survey");
        String accountId = (String) httpSession.getAttribute(LOGIN_USER_KEY);
        httpSession.setAttribute(CURRENT_SURVEY_ID, survey.getSurveyId());
        surveyHubService.createSurvey(accountId, survey);
    }

    @ResponseStatus(HttpStatus.OK)
    @GetMapping(path = "/createsurvey")
    public String getCreateSurveyPage() {
        return CREATE_SURVEY_PAGE;
    }

    @ResponseStatus(HttpStatus.OK)
    @GetMapping(path = "/surveys", produces = {"application/json"})
    public @ResponseBody List<String> getSurveyNames(HttpSession httpSession) {
        System.out.println("GET Surveys");
        String email = (String) httpSession.getAttribute(LOGIN_USER_NAME);
        Account account = surveyHubService.getAccountByEmail(email);

        List<String> names = new ArrayList<>();
        for (Survey survey : account.getCreatedSurveys()) {
            names.add(survey.getSurveyName());
        }
        return names;
    }
}
