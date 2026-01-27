package com.throneswiki.gotwiki.entity;

import jakarta.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "person_aliases")
@IdClass(PersonAliasId.class)
public class PersonAlias {

    @Id
    @Column(name = "person_id")
    private Integer personId;

    @Id
    @Column(name = "alias")
    private String alias;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "person_id", insertable = false, updatable = false)
    private Person person;

    // getters setters
}
