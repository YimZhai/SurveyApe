package edu.sjsu.cmpe275.exceptions;

public class SurveyExpiredException extends RuntimeException {
    private String msg;

    public SurveyExpiredException(String msg) {
        this.msg = msg;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }
}
