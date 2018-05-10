package edu.sjsu.cmpe275.exceptions;

public class AccountNotExistException extends RuntimeException {
    private String msg;

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public AccountNotExistException(String msg) {
        this.msg = msg;
    }
}
