package com.throneswiki.gotwiki.controller;

import com.throneswiki.gotwiki.entity.Person;
import com.throneswiki.gotwiki.service.PersonAliasService;
import com.throneswiki.gotwiki.service.PersonService;
import com.throneswiki.gotwiki.service.PersonTitleService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/characters")
public class PersonController {

    private final PersonService personService;
    private final PersonTitleService personTitleService;
    private final PersonAliasService personAliasService;

    public PersonController(PersonService personService,
                            PersonTitleService personTitleService,
                            PersonAliasService personAliasService) {
        this.personService = personService;
        this.personTitleService = personTitleService;
        this.personAliasService = personAliasService;
    }

    // 🔹 Tüm karakterler
    @GetMapping
    public String list(Model model) {
        model.addAttribute("persons", personService.findAll());
        return "characters";
    }

    // 🔹 Tek karakter detayı
    @GetMapping("/{id}")
    public String detail(@PathVariable Integer id, Model model) {

        Person person = personService.findById(id);
        model.addAttribute("person", person);

        model.addAttribute("titles",
                personTitleService.getTitlesOfPerson(id));

        model.addAttribute("aliases",
                personAliasService.getAliasesOfPerson(id));

        return "person_detail";
    }
}
