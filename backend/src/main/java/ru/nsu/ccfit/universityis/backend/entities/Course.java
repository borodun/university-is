package ru.nsu.ccfit.universityis.backend.entities;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Type;
import ru.nsu.ccfit.universityis.backend.types.CourseTypes;

import javax.persistence.*;

@Getter
@Setter
@Entity
@Table(name = "courses")
public class Course {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "course_number", nullable = false)
    private Integer courseNumber;

    @Enumerated(EnumType.STRING)
    @Type(type = "postgresEnum")
    @Column(name = "course_type")
    private CourseTypes courseType;

    @Column(name = "faculty_id", nullable = false)
    private Integer facultyId;
}