package ru.nsu.ccfit.universityis.backend.entities;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Type;
import ru.nsu.ccfit.universityis.backend.types.ClassTypes;

import javax.persistence.*;

@Getter
@Setter
@Entity
@Table(name = "classes")
public class Class {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "group_id", nullable = false)
    private Integer groupId;

    @Column(name = "teacher_id", nullable = false)
    private Integer teacherId;

    @Column(name = "disciple_id", nullable = false)
    private Integer discipleId;

    @Enumerated(EnumType.STRING)
    @Type(type = "postgresEnum")
    @Column(name = "class_type")
    private ClassTypes classType;

    @Column(name = "hours", nullable = false)
    private Integer hours;
}