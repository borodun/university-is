package ru.nsu.ccfit.universityis.backend.entities;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Type;
import ru.nsu.ccfit.universityis.backend.types.ExamTypes;

import javax.persistence.*;

@Getter
@Setter
@Entity
@Table(name = "exam_assignments")
public class ExamAssignment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "disciple_id", nullable = false)
    private Integer disciple;

    @Enumerated(EnumType.STRING)
    @Type(type = "postgresEnum")
    @Column(name = "exam_type", columnDefinition = "exam_types not null")
    private ExamTypes examType;
}