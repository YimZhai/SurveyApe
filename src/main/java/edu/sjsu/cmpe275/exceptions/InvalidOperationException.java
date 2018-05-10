package edu.sjsu.cmpe275.exceptions;

public class InvalidOperationException extends RuntimeException {
    private String msg;

    public InvalidOperationException(String msg) {
        this.msg = msg;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }
}
