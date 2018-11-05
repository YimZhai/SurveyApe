package survey.ape.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping(path = "/")
    public String home() {
        return "login";
    }

    @GetMapping(path = "/signup")
    public String signUp() {
        return "signup";
    }

    @GetMapping(path = "/login")
    public String login() {
        return "login";
    }
}

