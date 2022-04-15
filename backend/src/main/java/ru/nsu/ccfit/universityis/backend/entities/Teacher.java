package ru.nsu.ccfit.universityis.backend.entities;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Type;
import ru.nsu.ccfit.universityis.backend.types.AcademicDegrees;
import ru.nsu.ccfit.universityis.backend.types.PositionTypes;

import javax.persistence.*;

@Getter
@Setter
@Entity
@Table(name = "teachers")
public class Teacher {
    @Id
    @Column(name = "id", nullable = false)
    private Integer id;

    @JoinColumn(name = "department_id", nullable = false)
    private Integer departmentId;

    @Column(name = "salary", nullable = false)
    private Integer salary;

    @Enumerated(EnumType.STRING)
    @Type(type = "postgresEnum")
    @Column(name = "degree")
    private AcademicDegrees degree;

    @Enumerated(EnumType.STRING)
    @Type(type = "postgresEnum")
    @Column(name = "position", nullable = false)
    private PositionTypes position;

    @Column(name = "scientific_theme")
    private String scientificTheme;

    @Column(name = "scientific_direction")
    private String scientificDirection;
}