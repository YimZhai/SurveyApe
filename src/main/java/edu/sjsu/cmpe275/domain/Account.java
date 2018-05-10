package edu.sjsu.cmpe275.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "account")
public class Account {
    public enum AccountType {
        SURVEYOR,
        SURVEYEE,
    }

    @Id
    @Column(name = "account_id")
    private String accountId;

    @Column(name = "first_name", nullable = false)
    private String firstName;

    @Column(name = "last_name", nullable = false)
    private String lastName;

    @Column(name = "email", nullable = false)
    private String email;

    @Column(name = "password", nullable = false)
    private String password;

    @Column(name = "type", nullable = false)
    private int type;

    @Column(name = "verify_code", nullable = false)
    private String verifyCode;

    @Column(name = "verified", nullable = false)
    private boolean verified;

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "creator")
    @JsonIgnore
    private List<Survey> createdSurveys = new ArrayList<>();

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "account_to_survey",
                joinColumns = { @JoinColumn(name = "survey_id")},
                inverseJoinColumns = { @JoinColumn(name = "account_id")})
    @JsonIgnore
    private List<Survey> joinedSurveys = new ArrayList<>();

    public List<Survey> getCreatedSurveys() {
        return createdSurveys;
    }

    public void setCreateSurveys(List<Survey> createSurveys) {
        this.createdSurveys = createSurveys;
    }

    public int getType() {
        return type;
    }

    public boolean isVerified() {
        return verified;
    }

    public List<Survey> getJoinedSurveys() {
        return joinedSurveys;
    }

    public String getAccountId() {
        return accountId;
    }

    public String getEmail() {
        return email;
    }

    public String getPassword() {
        return password;
    }

    public String getVerifyCode() {
        return verifyCode;
    }

    public void setAccountId(String accountId) {
        this.accountId = accountId;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setJoinedSurveys(List<Survey> surveys) {
        this.joinedSurveys = surveys;
    }

    public void setType(int type) {
        this.type = type;
    }

    public void setVerified(boolean verified) {
        this.verified = verified;
    }

    public void setVerifyCode(String verifyCode) {
        this.verifyCode = verifyCode;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public void setCreatedSurveys(List<Survey> createdSurveys) {
        this.createdSurveys = createdSurveys;
    }

    @Override
    public boolean equals(Object o) {
        if (!(o instanceof Account)) {
            return false;
        }
        Account other = (Account)o;
        return accountId.equals(other.accountId);
    }

    @Override
    public int hashCode() {
        return accountId.hashCode();
    }

    public Account() {
        this.accountId = "account_" + UUID.randomUUID().toString().replaceAll("-", "");
    }
}
