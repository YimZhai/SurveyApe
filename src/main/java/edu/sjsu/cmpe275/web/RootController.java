package edu.sjsu.cmpe275.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class RootController {

    private final static String SIGNUP = "signup";
    private final static String LOGIN = "login";

    @GetMapping(path = "/signup")
    public String signUp() {
        return SIGNUP;
    }

    @GetMapping(path = "/login")
    public String login() {
        return SIGNUP;
    }
}
