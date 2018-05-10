package edu.sjsu.cmpe275.service;

import edu.sjsu.cmpe275.domain.Question;
import org.springframework.data.repository.CrudRepository;

public interface QuestionRepository extends CrudRepository<Question, String> {
}
