package com.throneswiki.gotwiki.repository;

import com.throneswiki.gotwiki.entity.Title;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TitleRepository extends JpaRepository<Title, Integer> {
}
