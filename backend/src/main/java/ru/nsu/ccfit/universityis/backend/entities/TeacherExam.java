package ru.nsu.ccfit.universityis.backend.entities;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;

@Getter
@Setter
@Entity
@Table(name = "teacher_exams")
public class TeacherExam {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "teacher_id", nullable = false)
    private Integer teacher;

    @Column(name = "exam_id", nullable = false)
    private Integer exam;
}