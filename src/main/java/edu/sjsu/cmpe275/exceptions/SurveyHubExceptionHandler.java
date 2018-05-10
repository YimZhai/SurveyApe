package edu.sjsu.cmpe275.exceptions;

import edu.sjsu.cmpe275.domain.Question;
import edu.sjsu.cmpe275.domain.Survey;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

import javax.mail.MessagingException;

@ControllerAdvice
public class SurveyHubExceptionHandler extends ResponseEntityExceptionHandler {
    @ExceptionHandler(Exception.class)
    public final ResponseEntity<Exception>
    handleOtherException(Exception ex, WebRequest request) {
        return new ResponseEntity<>(ex, HttpStatus.INTERNAL_SERVER_ERROR);
    }

    @ExceptionHandler(AccountNotExistException.class)
    public final ResponseEntity<AccountNotExistException>
    handlerAccountNotExistException(AccountNotExistException ex, WebRequest request) {
        return new ResponseEntity<>(ex, HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(SurveyNotExistException.class)
    public final ResponseEntity<SurveyNotExistException>
    handlerSurveyNotExistException(SurveyNotExistException ex, WebRequest request) {
        return new ResponseEntity<>(ex, HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(SurveyExpiredException.class)
    public final ResponseEntity<SurveyExpiredException>
    handleSurveyExpiredException(SurveyExpiredException ex, WebRequest request) {
        return new ResponseEntity<>(ex, HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(SurveyUnwritableException.class)
    public final ResponseEntity<SurveyUnwritableException>
    handleSurveyUnwritableException(SurveyUnwritableException ex, WebRequest request) {
        return new ResponseEntity<>(ex, HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(InvalidOperationException.class)
    public final ResponseEntity<InvalidOperationException>
    handleInvalidOperationException(InvalidOperationException ex, WebRequest request) {
        return new ResponseEntity<>(ex, HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(VerifyFailedException.class)
    public final ResponseEntity<VerifyFailedException>
    handleVerifyFailedException(VerifyFailedException ex, WebRequest request) {
        return new ResponseEntity<>(ex, HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(QuestionNotExistException.class)
    public final ResponseEntity<QuestionNotExistException>
    handleVerifyFailedException(QuestionNotExistException ex, WebRequest request) {
        return new ResponseEntity<>(ex, HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(SurveyHubException.class)
    public final ResponseEntity<SurveyHubException>
    handleVerifyFailedException(SurveyHubException ex, WebRequest request) {
        return new ResponseEntity<>(ex, HttpStatus.NOT_FOUND);
    }
}
