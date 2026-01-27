package com.throneswiki.gotwiki.repository;

import com.throneswiki.gotwiki.entity.PersonAlias;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface PersonAliasRepository extends JpaRepository<PersonAlias, Integer> {

    @Query("select pa.alias from PersonAlias pa where pa.person.id = :personId")
    List<String> findAliasesByPersonId(Integer personId);
}
