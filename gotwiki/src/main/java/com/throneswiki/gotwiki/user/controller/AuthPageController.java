/*package com.throneswiki.gotwiki.user.controller;

import com.throneswiki.gotwiki.user.entity.User;
import com.throneswiki.gotwiki.user.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class AuthPageController {

    private final UserService service;

    public AuthPageController(UserService service) {
        this.service = service;
    }

    // REGISTER PAGE
    @GetMapping("/register")
    public String registerPage(Model model) {
        model.addAttribute("user", new User());
        return "register";
    }

    // REGISTER ACTION
    @PostMapping("/register")
    public String register(@ModelAttribute User user) {
        service.register(user);
        return "redirect:/login";
    }

    // LOGIN PAGE
    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }

    // LOGIN ACTION
    @PostMapping("/login")
    public String login(
            @RequestParam String username,
            @RequestParam String password,
            Model model
    ) {
        boolean success = service.login(username, password);

        if (success) {
            return "success";
        }

        model.addAttribute("error", "Kullanıcı adı veya şifre yanlış");
        return "login";
    }
}*/
package com.throneswiki.gotwiki.user.controller;

import com.throneswiki.gotwiki.user.entity.User;
import com.throneswiki.gotwiki.user.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class AuthPageController {

    private final UserService service;

    public AuthPageController(UserService service) {
        this.service = service;
    }

    @GetMapping("/register")
    public String registerPage(Model model) {
        model.addAttribute("user", new User());
        return "register";
    }

    @PostMapping("/register")
    public String register(@ModelAttribute User user) {
        service.register(user);
        return "redirect:/login";
    }

    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }


    @GetMapping("/success")
    public String successPage() {
        return "index"; // templates/success.html
    }
}

