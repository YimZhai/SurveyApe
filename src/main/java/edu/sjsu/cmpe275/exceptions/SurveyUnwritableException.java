package edu.sjsu.cmpe275.exceptions;

public class SurveyUnwritableException extends RuntimeException {
    private String msg;

    public SurveyUnwritableException(String msg) {
        this.msg = msg;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }
}
