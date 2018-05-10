package edu.sjsu.cmpe275.service;

import edu.sjsu.cmpe275.domain.Survey;
import org.springframework.data.repository.CrudRepository;

public interface SurveyRepository extends CrudRepository<Survey, String> {
}
