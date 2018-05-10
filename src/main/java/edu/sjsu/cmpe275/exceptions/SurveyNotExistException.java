package edu.sjsu.cmpe275.exceptions;

public class SurveyNotExistException extends RuntimeException {
    private String msg;

    public SurveyNotExistException(String msg) {
         this.msg = msg;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }
}
