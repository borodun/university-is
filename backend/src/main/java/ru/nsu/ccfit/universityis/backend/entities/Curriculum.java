package ru.nsu.ccfit.universityis.backend.entities;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Type;
import ru.nsu.ccfit.universityis.backend.types.ClassTypes;

import javax.persistence.*;

@Getter
@Setter
@Entity
@Table(name = "curriculum")
public class Curriculum {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "disciple_id", nullable = false)
    private Integer discipleId;

    @Enumerated(EnumType.STRING)
    @Type(type = "postgresEnum")
    @Column(name = "class_type")
    private ClassTypes classType;

    @Column(name = "hours", nullable = false)
    private Integer hours;

    @Column(name = "year", nullable = false)
    private Integer year;

    @Column(name = "course_id", nullable = false)
    private Integer courseId;

    @Column(name = "semester", nullable = false)
    private Integer semester;
}