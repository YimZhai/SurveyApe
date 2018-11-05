package survey.ape.components.surveyInfo;

import survey.ape.components.surveyInfo.Answer;
import org.springframework.data.repository.CrudRepository;

public interface AnsRepository extends CrudRepository<Answer, Long> {
    Iterable<Answer> findAllBySurveyId(String surveyId);
}
