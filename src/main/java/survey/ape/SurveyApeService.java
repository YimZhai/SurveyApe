package survey.ape;

import javassist.bytecode.stackmap.TypeData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import survey.ape.EmailService;
import survey.ape.components.accountInfo.AccRepository;
import survey.ape.components.accountInfo.AccToSurRepository;
import survey.ape.components.accountInfo.Account;
import survey.ape.components.accountInfo.AccountToSurvey;
import survey.ape.components.invitationInfo.InvRepository;
import survey.ape.components.invitationInfo.Invitation;
import survey.ape.components.surveyInfo.*;

import java.util.*;
import java.util.logging.Logger;

@Component("SurveyApeService")
public class SurveyApeService {

    private static final Logger LOGGER = Logger.getLogger(TypeData.ClassName.class.getName());

    @Autowired
    AccRepository accountRepository;

    @Autowired
    AnsRepository answerRepository;

    @Autowired
    InvRepository invitationRepository;

    @Autowired
    TypeOfQuestionsRepository questionRepository;

    @Autowired
    SurRepository surveyRepository;

    @Autowired
    AccToSurRepository accountToSurveyRepository;

    @Autowired
    EmailService surveyHubEmailService;

    public Survey createSurvey(String accountId, Survey survey) {
        Optional<Account> maybeAccount = accountRepository.findById(accountId);
        if (!maybeAccount.isPresent()) {
            LOGGER.warning("Account_id does not exist");
            return null;
        }

        survey.setCreator(maybeAccount.get());
        survey.setStatus(Survey.SurveyStatus.EDITTING);
        survey.setCreateTime(new Date());
        for (Question question : survey.getQuestions()) {
            question.setSurvey(survey);
        }

        // Save survey
        surveyRepository.save(survey);
        return survey;
    }

    public void saveQuestions(String surveyId, List<Question> questions) {
        Survey survey = getSurvey(surveyId);
        List<Question> added = new ArrayList<>();
        for (Question q : questions) {
            boolean existed = false;
            for (Question existedQuestion : survey.getQuestions()) {
                if (existedQuestion.getQuestionId().equals(q.getQuestionId())) {
                    existedQuestion.setQuestionContent(q.getQuestionContent());
                    existed = true;
                    break;
                }
            }
            if (!existed) {
                added.add(q);
            }
        }
        for (Question toAdd : added) {
            toAdd.setSurvey(survey);
        }
        questionRepository.saveAll(added);
        surveyRepository.save(survey);
    }

    public void deleteQuestion(Question question) {
        questionRepository.deleteById(question.getQuestionId());
    }

    public void checkSurvey(String accountId, Survey survey) {
        boolean hasAccount = null != accountId && !accountId.isEmpty();
        for (Question question : survey.getQuestions()) {
            if (hasAccount) {
                List<Answer> answers = new ArrayList<>();
                for (Answer answer : question.getAnswers()) {
                    if (accountId.equals(answer.getAccountId())) {
                        answers.add(answer);
                    }
                }
                question.setAnswers(answers);
            } else {
                question.getAnswers().clear();
            }
        }

        if (!hasAccount) {
            survey.setProtectMode(false);
            return;
        }

        survey.setUsingAccount(accountId);
        Optional<AccountToSurvey> maybeVal =
                accountToSurveyRepository.findBySurveyIdAndAccountId(survey.getSurveyId(), accountId);
        if (!maybeVal.isPresent()) {
            return;
        }
        AccountToSurvey val = maybeVal.get();
        survey.setProtectMode(val.isSubmitted());
    }

    public Survey getSurvey(String surveyId) {
        Optional<Survey> maybeSurvey = surveyRepository.findById(surveyId);
        if (!maybeSurvey.isPresent()) {
            LOGGER.warning("Survey does not exist");
            return null;
        }
        Survey survey = maybeSurvey.get();
        Date now = new Date();
        if (survey.getExpireTime().before(now)) {
            LOGGER.warning("The survey has been expired.");
            return null;
        }
        return survey;
    }

    public void updateSurvyStatus(String surveyId, Survey.Action action, Date newDueDate) {
        Survey survey = getSurvey(surveyId);
        switch (action) {
            case CLOSE:
                survey.setStatus(Survey.SurveyStatus.CLOSED);
                break;
            case EXTEND:
                Date now = new Date();
                if (survey.getExpireTime().before(now)) {
                    LOGGER.warning("The survey has been expired.");
                }
                survey.setExpireTime(newDueDate);
                break;
            case PUBLISH:
                publishSurvey(surveyId);
                break;
            case UNPUBLISH:
                unpublishSurvey(surveyId);
                break;
            default:
                LOGGER.warning("Underconstruction error!");
        }
    }

    private void publishSurvey(String surveyId) {
        Survey survey = getSurvey(surveyId);
        if (survey.getStatus() != Survey.SurveyStatus.EDITTING) {
            LOGGER.warning("The survey has been published.");
            return;
        }
        survey.setStatus(Survey.SurveyStatus.PUBLISHED);
        surveyRepository.save(survey);
    }

    private void unpublishSurvey(String surveyId) {
        Survey survey = getSurvey(surveyId);
        if (survey.getStatus() == Survey.SurveyStatus.CLOSED) {
            LOGGER.warning("The survey has been published.");
            return;
        }
        if (survey.getParticipantNum() > 0) {
            LOGGER.warning("The survey cannot be published.");
            return;
        }
        survey.setStatus(Survey.SurveyStatus.EDITTING);
        surveyRepository.save(survey);
    }

    public void createAccount(Account account) {
        Optional<Account> maybeAccount = accountRepository.findByEmail(account.getEmail());
        if (maybeAccount.isPresent()) {
            LOGGER.warning("The EMAIL [" + account.getEmail() + "] exists.");
            return;
        } else {
            account.setVerified(false);
            String verifyCode = genterateVerifyCode();
            account.setVerifyCode(verifyCode);
            accountRepository.save(account);
            surveyHubEmailService.sendVerificationCode(account.getEmail(), verifyCode);
        }
    }

    public Account getAccountByEmail(String email) {
        Optional<Account> maybeAccount = accountRepository.findByEmail(email);
        if (!maybeAccount.isPresent()) {
            LOGGER.warning("Email: " + email + "does not exist.");
            return null;
        } else {
            return maybeAccount.get();
        }
    }

    public Account getAccountById(String accountId) {
        Optional<Account> maybeAccount = accountRepository.findById(accountId);
        if (maybeAccount.isPresent()) {
            return maybeAccount.get();
        }

        return null;
    }

    public Account loginAccount(String email, String password) {
        Optional<Account> maybeAccount = accountRepository.findByEmail(email);
        if (maybeAccount.isPresent()) {
            Account account = maybeAccount.get();
            if (!account.isVerified()) {
                LOGGER.warning(account + " cannot be verified.");
                return null;
            }

            if (password == null || !password.equals(account.getPassword())) {
                return null;
            }
            return account;
        }
        return null;
    }

    private String genterateVerifyCode() {
        return UUID.randomUUID().toString().replaceAll("-", "")
                   .substring(0, 7).toUpperCase();
    }

    public void verifyAccount(String email, String code) {
        Account account = getAccountByEmail(email);

        if (account.getVerifyCode().equals(code)) {
            account.setVerified(true);
            accountRepository.save(account);
        } else {
            LOGGER.warning("Account cannot be verified.");
            return;
        }
    }

    public void saveAnswers(String accountId, List<Answer> answers, List<String> questionIds) {
        Map<String, Question> questionMap = new HashMap<>();
        List<Answer> toSave = new ArrayList<>();
        for (int i = 0; i < answers.size(); ++i) {
            Answer answer = answers.get(i);
            Question question;
            if (!questionMap.containsKey(questionIds.get(i))) {
                question = getQuestion(questionIds.get(i));
                questionMap.put(questionIds.get(i), question);
            } else {
                question = questionMap.get(questionIds.get(i));
            }
            boolean duplicate = false;
            for (Answer existed : question.getAnswers()) {
                if (existed.getSurveyId().equals(answer.getSurveyId())
                        && accountId != null && !accountId.isEmpty()
                        && accountId.equals(existed.getAccountId())) {
                    existed.setContent(answer.getContent());
                    toSave.add(existed);
                    duplicate = true;
                }
            }
            if (null == accountId || accountId.isEmpty() || !duplicate) {
                answer.setQuestion(question);
                question.getAnswers().add(answer);
                toSave.add(answer);
            }
        }
        answerRepository.saveAll(toSave);
    }

    public Question getQuestion(String questionId) {
        Optional<Question> maybeQuestion = questionRepository.findById(questionId);
        if (maybeQuestion.isPresent()) {
            return maybeQuestion.get();
        }
        return null;
    }

    public Iterable<Answer> getAnswers(String questionId) {
        Question question = getQuestion(questionId);
        return question.getAnswers();
    }

    public Answer getAnswer(String questionId, String accountId) {
        Question question = getQuestion(questionId);
        for (Answer answer : question.getAnswers()) {
            if (accountId.equals(answer.getAccountId())) {
                return answer;
            }
        }
        return null;
    }

    public void submitSurvey(String surveyId, String accoundId) {
        Survey survey = getSurvey(surveyId);
        survey.setParticipantNum(survey.getParticipantNum() + 1);
        surveyRepository.save(survey);

        // No need to record submission for non-login user
        if (null == accoundId || accoundId.isEmpty()) {
            return;
        }
        AccountToSurvey accountToSurvey;
        Optional<AccountToSurvey> maybeVal =
                accountToSurveyRepository.findBySurveyIdAndAccountId(surveyId, accoundId);
        if (!maybeVal.isPresent()) {
            accountToSurvey = new AccountToSurvey();
            accountToSurvey.setAccountId(accoundId);
            accountToSurvey.setSurveyId(surveyId);
        } else {
            accountToSurvey = maybeVal.get();
        }
        accountToSurvey.setSubmitted(true);

        accountToSurveyRepository.save(accountToSurvey);
        Account account = getAccountById(accoundId);
        surveyHubEmailService.sendSubmitSurveyComfirmMail(account.getEmail(), surveyId);
    }

    private boolean hasSubmitted(String surveyId) {
        Iterable<AccountToSurvey> accountToSurveys =
                accountToSurveyRepository.findAllBySurveyId(surveyId);
        Iterator<AccountToSurvey> iter = accountToSurveys.iterator();
        while (iter.hasNext()) {
            AccountToSurvey accountToSurvey = iter.next();
            if (accountToSurvey.isSubmitted()) {
                return true;
            }
        }
        return false;
    }

    public void sendInvitation(String surveyId, List<Invitation> invitations) {
        Survey survey = getSurvey(surveyId);
        survey.setInvitationNum(survey.getInvitationNum() + invitations.size());
        for (Invitation invitation: invitations) {
            surveyHubEmailService.sendInvitationMail(invitation);
        }
        surveyRepository.save(survey);
    }
}
