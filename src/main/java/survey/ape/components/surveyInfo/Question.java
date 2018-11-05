package survey.ape.components.surveyInfo;

import com.fasterxml.jackson.annotation.JsonIgnore;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "question")
public class Question {

    @Id
    @Column(name = "question_id")
    private String questionId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "survey_id", nullable = false)
    @JsonIgnore
    private Survey survey;

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "question")
    private List<Answer> answers = new ArrayList<>();

    @Column(name = "content", nullable = true)
    @Lob
    private String questionContent;

    @Override
    public boolean equals(Object o) {
        if (!(o instanceof Question)) {
            return false;
        }

        Question other = (Question)o;
        return other.questionId.equals(questionId);
    }

    @Override
    public int hashCode() {
        return questionId.hashCode();
    }

    public String getQuestionId() {
        return questionId;
    }

    public void setQuestionId(String questionId) {
        this.questionId = questionId;
    }

    public Survey getSurvey() {
        return survey;
    }

    public void setSurvey(Survey survey) {
        this.survey = survey;
    }

    public String getQuestionContent() {
        return questionContent;
    }

    public void setQuestionContent(String questionContent) {
        this.questionContent = questionContent;
    }

    public List<Answer> getAnswers() {
        return answers;
    }

    public void setAnswers(List<Answer> answers) {
        this.answers = answers;
    }

    public Question() {
        this.questionId = "question_" + UUID.randomUUID().toString().replaceAll("-", "");
    }
}
