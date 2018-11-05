package survey.ape.components.surveyInfo;

import com.fasterxml.jackson.annotation.JsonIgnore;
import org.springframework.format.annotation.DateTimeFormat;
import survey.ape.components.accountInfo.Account;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "survey")
public class Survey {
    public enum SurveyType {
        GENERAL_SURVEY,
        CLOSED_INVITATION,
        OPEN_UNIQUE
    }

    public enum SurveyStatus {
        EDITTING,
        PUBLISHED,
        CLOSED
    }

    public enum Action {
        EXTEND,
        CLOSE,
        PUBLISH,
        UNPUBLISH
    }

    @Id
    @Column(name = "survey_id")
    private String surveyId;

    @Column(name = "survey_name")
    private String surveyName;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "account_id", nullable = false)
    @JsonIgnore
    private Account creator;

    @Column(name = "survey_type", nullable = false)
    private String surveyType;

    @Column(name = "status", nullable = false)
    private SurveyStatus status;

    @Column(name = "create_time", nullable = false)
    private Date createTime;

    @DateTimeFormat( pattern = "MM/dd/yyyy")
    @Column(name = "expire_time", nullable = false)
    private Date expireTime;

    @Column(name = "participant_num", nullable = false)
    private int participantNum;

    @Column(name = "invitation_num", nullable = false)
    private int invitationNum;

    private String usingAccount;

    private boolean protectMode;

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "survey")
    List<Question> questions = new ArrayList<>();

    public Survey() {
        this.surveyId = "survey_" + UUID.randomUUID().toString().replaceAll("-", "");
        this.status = SurveyStatus.EDITTING;
        this.participantNum = 0;
        this.invitationNum = 0;
        this.protectMode = false;
    }

    public void setSurveyId(String surveyId) {
        this.surveyId = surveyId;
    }

    public void setSurveyType(String type) {
        this.surveyType = type;
    }

    public void setStatus(SurveyStatus status) {
        this.status = status;
    }

    public void setExpireTime(Date expireTime) {
        this.expireTime = expireTime;
    }

    public void setQuestions(List<Question> questions) {
        this.questions = questions;
    }

    public String getSurveyType() {
        return surveyType;
    }

    public SurveyStatus getStatus() {
        return status;
    }

    public Date getExpireTime() {
        return expireTime;
    }

    public List<Question> getQuestions() {
        return questions;
    }

    public String getSurveyId() {
        return surveyId;
    }

    public Account getCreator() {
        return creator;
    }

    public void setCreator(Account creator) {
        this.creator = creator;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public int getParticipantNum() {
        return participantNum;
    }

    public void setParticipantNum(int participantNum) {
        this.participantNum = participantNum;
    }

    public int getInvitationNum() {
        return invitationNum;
    }

    public void setInvitationNum(int invitationNum) {
        this.invitationNum = invitationNum;
    }

    public String getSurveyName() {
        return surveyName;
    }

    public void setSurveyName(String name) {
        this.surveyName = name;
    }

    public String getUsingAccount() {
        return usingAccount;
    }

    public void setUsingAccount(String usingAccount) {
        this.usingAccount = usingAccount;
    }

    public boolean isProtectMode() {
        return protectMode;
    }

    public void setProtectMode(boolean protectMode) {
        this.protectMode = protectMode;
    }

}
