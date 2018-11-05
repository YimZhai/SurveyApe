package survey.ape.components.accountInfo;

import survey.ape.components.accountInfo.AccountToSurvey;
import org.springframework.data.repository.CrudRepository;

import java.util.Optional;

public interface AccToSurRepository extends CrudRepository<AccountToSurvey, Long> {
    Iterable<AccountToSurvey> findAllBySurveyId(String surveyId);
    Optional<AccountToSurvey> findBySurveyIdAndAccountId(String surveyId, String accountId);
}
