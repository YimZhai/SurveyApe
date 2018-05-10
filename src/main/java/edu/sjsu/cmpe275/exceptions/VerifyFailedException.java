package edu.sjsu.cmpe275.exceptions;

public class VerifyFailedException extends RuntimeException {
    private String msg;

    public VerifyFailedException(String msg) {
        this.msg = msg;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }
}
