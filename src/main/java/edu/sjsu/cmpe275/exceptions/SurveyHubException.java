package edu.sjsu.cmpe275.exceptions;

public class SurveyHubException extends RuntimeException {
    private String msg;

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public SurveyHubException(String msg) {
        this.msg = msg;
    }
}
