package com.throneswiki.gotwiki.repository;

import com.throneswiki.gotwiki.entity.Person;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PersonRepository extends JpaRepository<Person, Integer> {
}
