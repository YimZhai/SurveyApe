package edu.sjsu.cmpe275.service;

import edu.sjsu.cmpe275.domain.Answer;
import org.springframework.data.repository.CrudRepository;

public interface AnswerRepository extends CrudRepository<Answer, Long> {
    Iterable<Answer> findAllBySurveyId(String surveyId);
}
