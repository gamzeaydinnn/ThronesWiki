package com.throneswiki.gotwiki.service;

import com.throneswiki.gotwiki.repository.PersonAliasRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PersonAliasService {

    private final PersonAliasRepository repository;

    public PersonAliasService(PersonAliasRepository repository) {
        this.repository = repository;
    }

    public List<String> getAliasesOfPerson(Integer personId) {
        return repository.findAliasesByPersonId(personId);
    }
}
