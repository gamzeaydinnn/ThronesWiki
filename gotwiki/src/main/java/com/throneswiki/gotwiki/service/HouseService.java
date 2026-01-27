package com.throneswiki.gotwiki.service;

import com.throneswiki.gotwiki.entity.House;
import com.throneswiki.gotwiki.repository.HouseRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class HouseService {

    private final HouseRepository repository;

    public HouseService(HouseRepository repository) {
        this.repository = repository;
    }

    public List<House> findAll() {
        return repository.findAll();
    }

    public House save(House house) {
        return repository.save(house);
    }

    public void delete(Integer id) {
        repository.deleteById(id);
    }
}
