package ru.nsu.ccfit.universityis.backend.entities;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Getter
@Setter
@Entity
@Table(name = "students")
public class Student {
    @Id
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "record_book_num", nullable = false)
    private Integer recordBookNumId;

    @Column(name = "group_id")
    private Integer groupId;

    @Column(name = "scholarship")
    private Integer scholarship;

    @Column(name = "diploma_title")
    private String diplomaTitle;

    @Column(name = "scientific_director")
    private Integer scientificDirector;
}