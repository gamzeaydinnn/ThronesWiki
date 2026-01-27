package com.throneswiki.gotwiki.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "titles")
public class Title {

    @Id
    @Column(name = "id")
    private Integer id;

    @Column(name = "name", nullable = false)
    private String name;

    public Title() {
    }

    public Integer getId() {        // 🔥 BU YOKTU
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
