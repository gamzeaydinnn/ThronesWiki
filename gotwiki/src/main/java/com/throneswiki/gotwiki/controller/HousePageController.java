package com.throneswiki.gotwiki.controller;

import com.throneswiki.gotwiki.entity.House;
import com.throneswiki.gotwiki.service.HouseService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/houses")
public class HousePageController {

    private final HouseService service;

    public HousePageController(HouseService service) {
        this.service = service;
    }

    @GetMapping
    public String housesPage(Model model) {
        List<House> houses = service.findAll();
        model.addAttribute("houses", houses);
        return "houses"; // resources/templates/houses.html
    }
}
