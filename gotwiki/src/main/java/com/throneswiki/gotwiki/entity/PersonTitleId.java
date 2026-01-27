package com.throneswiki.gotwiki.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;

import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class PersonTitleId implements Serializable {

    @Column(name = "person_id")
    private Integer personId;

    @Column(name = "title_id")
    private Integer titleId;

    public PersonTitleId() {
    }

    public PersonTitleId(Integer personId, Integer titleId) {
        this.personId = personId;
        this.titleId = titleId;
    }

    public Integer getPersonId() {
        return personId;
    }

    public void setPersonId(Integer personId) {
        this.personId = personId;
    }

    public Integer getTitleId() {
        return titleId;
    }

    public void setTitleId(Integer titleId) {
        this.titleId = titleId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof PersonTitleId)) return false;
        PersonTitleId that = (PersonTitleId) o;
        return Objects.equals(personId, that.personId)
                && Objects.equals(titleId, that.titleId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(personId, titleId);
    }
}
