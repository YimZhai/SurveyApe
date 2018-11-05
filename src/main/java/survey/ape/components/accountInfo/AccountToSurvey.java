package survey.ape.components.accountInfo;

import javax.persistence.*;

@Entity
@Table(name = "account_to_survey")
public class AccountToSurvey {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @Column(name = "account_id", nullable = false)
    private String accountId;

    @Column(name = "survey_id", nullable = false)
    private String surveyId;

    @Column(name = "submitted", nullable = false)
    private boolean submitted;

    public String getAccountId() {
        return accountId;
    }

    public void setAccountId(String accountId) {
        this.accountId = accountId;
    }

    public String getSurveyId() {
        return surveyId;
    }

    public void setSurveyId(String surveyId) {
        this.surveyId = surveyId;
    }

    public boolean isSubmitted() {
        return submitted;
    }

    public void setSubmitted(boolean submitted) {
        this.submitted = submitted;
    }

    public AccountToSurvey() {
        this.submitted = false;
    }
}
