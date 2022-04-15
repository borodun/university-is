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
@Table(name = "study_assignments")
public class StudyAssignment {
    @Id
    @Column(name = "disciple_id", nullable = false)
    private Integer discipleId;

    @Column(name = "department_id", nullable = false)
    private Integer departmentId;
}