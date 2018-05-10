package edu.sjsu.cmpe275.exceptions;

public class QuestionNotExistException extends RuntimeException {
    private String msg;

    public QuestionNotExistException(String msg) {
        this.msg = msg;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }
}
