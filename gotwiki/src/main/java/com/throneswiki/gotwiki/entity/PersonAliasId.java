package com.throneswiki.gotwiki.entity;

import java.io.Serializable;
import java.util.Objects;

public class PersonAliasId implements Serializable {

    private Integer personId;
    private String alias;

    public PersonAliasId() {}

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof PersonAliasId)) return false;
        PersonAliasId that = (PersonAliasId) o;
        return Objects.equals(personId, that.personId) &&
                Objects.equals(alias, that.alias);
    }

    @Override
    public int hashCode() {
        return Objects.hash(personId, alias);
    }
}
