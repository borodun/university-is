package ru.nsu.ccfit.universityis.backend.entities;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.time.LocalDate;

@Getter
@Setter
@Entity
@Table(name = "exams")
public class Exam {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "disciple_id", nullable = false)
    private Integer discipleId;

    @Column(name = "date", nullable = false)
    private LocalDate date;

    @Column(name = "session_id", nullable = false)
    private Integer sessionId;
}