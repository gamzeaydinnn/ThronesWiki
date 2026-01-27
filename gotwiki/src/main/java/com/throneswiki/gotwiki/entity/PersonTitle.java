package com.throneswiki.gotwiki.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "person_titles")
public class PersonTitle {

    @EmbeddedId
    private PersonTitleId id;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("personId")
    @JoinColumn(name = "person_id", nullable = false)
    private Person person;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("titleId")
    @JoinColumn(name = "title_id", nullable = false)
    private Title title;

    @Column(name = "start_year", nullable = false) // 🔥 DB NOT NULL → ENTITY NOT NULL
    private Integer startYear;

    @Column(name = "end_year")
    private Integer endYear;

    @Column(columnDefinition = "text")
    private String note;

    public PersonTitle() {
    }

    public PersonTitle(Person person, Title title, Integer startYear) {
        this.person = person;
        this.title = title;
        this.startYear = startYear;
        this.id = new PersonTitleId(person.getId(), title.getId());
    }

    public PersonTitleId getId() {
        return id;
    }

    public void setId(PersonTitleId id) {
        this.id = id;
    }

    public Person getPerson() {
        return person;
    }

    public void setPerson(Person person) {
        this.person = person;
    }

    public Title getTitle() {
        return title;
    }

    public void setTitle(Title title) {
        this.title = title;
    }

    public Integer getStartYear() {
        return startYear;
    }

    public void setStartYear(Integer startYear) {
        this.startYear = startYear;
    }

    public Integer getEndYear() {
        return endYear;
    }

    public void setEndYear(Integer endYear) {
        this.endYear = endYear;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }
}
