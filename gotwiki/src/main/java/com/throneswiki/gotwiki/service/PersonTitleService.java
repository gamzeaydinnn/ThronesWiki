package com.throneswiki.gotwiki.service;

import com.throneswiki.gotwiki.entity.PersonTitle;
import com.throneswiki.gotwiki.repository.PersonTitleRepository;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class PersonTitleService {

    private final PersonTitleRepository repository;

    public PersonTitleService(PersonTitleRepository repository) {
        this.repository = repository;
    }

    public List<Map<String, Object>> getTitlesOfPerson(Integer personId) {

        List<PersonTitle> list = repository.findByPerson_Id(personId);

        List<Map<String, Object>> result = new ArrayList<>();

        for (PersonTitle pt : list) {
            Map<String, Object> map = new HashMap<>();
            map.put("title", pt.getTitle().getName());
            map.put("startYear", pt.getStartYear());
            map.put("endYear", pt.getEndYear());
            map.put("note", pt.getNote());
            result.add(map);
        }

        return result;
    }
}
