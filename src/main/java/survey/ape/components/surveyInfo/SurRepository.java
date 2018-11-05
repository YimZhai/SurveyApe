package survey.ape.components.surveyInfo;

import survey.ape.components.surveyInfo.Survey;
import org.springframework.data.repository.CrudRepository;

public interface SurRepository extends CrudRepository<Survey, String> {
}
