package com.throneswiki.gotwiki.repository;

import com.throneswiki.gotwiki.entity.PersonTitle;
import com.throneswiki.gotwiki.entity.PersonTitleId;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PersonTitleRepository
        extends JpaRepository<PersonTitle, PersonTitleId> {

    List<PersonTitle> findByPerson_Id(Integer personId);
}
