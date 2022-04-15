package ru.nsu.ccfit.universityis.backend.entities;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;

@Getter
@Setter
@Entity
@Table(name = "faculties")
public class Faculty {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "dean_id", nullable = false)
    private Integer dean;

    @Column(name = "faculty_name", nullable = false)
    private String facultyName;
}