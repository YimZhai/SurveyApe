package survey.ape.components.surveyInfo;

import survey.ape.components.surveyInfo.Question;
import org.springframework.data.repository.CrudRepository;

public interface TypeOfQuestionsRepository extends CrudRepository<Question, String> {
}
