package com.throneswiki.gotwiki.controller;

import com.throneswiki.gotwiki.entity.House;
import com.throneswiki.gotwiki.repository.HouseRepository;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
@RestController
@RequestMapping("/api/houses")
public class HouseController {

    private final HouseRepository repo;

    public HouseController(HouseRepository repo) {
        this.repo = repo;
    }

    // GET /api/houses
    @GetMapping
    public List<House> list(@RequestParam(required = false) Boolean great) {
        if (great != null && great) {
            return repo.findByGreatTrue();
        }
        return repo.findAll(Sort.by("name"));
    }

    // GET /api/houses/{id}
    @GetMapping("/{id}")
    public House one(@PathVariable Integer id) {
        return repo.findById(id)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "House not found"));
    }
}
