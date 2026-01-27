package com.throneswiki.gotwiki.service;

import com.throneswiki.gotwiki.entity.Person;
import com.throneswiki.gotwiki.repository.PersonRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PersonService {

    private final PersonRepository personRepository;

    public PersonService(PersonRepository personRepository) {
        this.personRepository = personRepository;
    }

    public List<Person> findAll() {
        return personRepository.findAll();
    }

    public Person findById(Integer id) {
        return personRepository.findById(id).orElse(null);
    }
}
