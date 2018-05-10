package edu.sjsu.cmpe275.service;

import edu.sjsu.cmpe275.domain.AccountToSurvey;
import org.springframework.data.repository.CrudRepository;

import java.util.Optional;

public interface AccountToSurveyRepository extends CrudRepository<AccountToSurvey, Long> {
    Iterable<AccountToSurvey> findAllBySurveyId(String surveyId);

    Optional<AccountToSurvey> findBySurveyIdAndAccountId(String surveyId, String accountId);
}
