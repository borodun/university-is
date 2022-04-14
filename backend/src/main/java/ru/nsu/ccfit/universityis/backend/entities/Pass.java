package ru.nsu.ccfit.universityis.backend.entities;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Type;
import ru.nsu.ccfit.universityis.backend.types.MarkTypes;

import javax.persistence.*;

@Getter
@Setter
@Entity
@Table(name = "passes")
public class Pass {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @JoinColumn(name = "exam_id", nullable = false)
    private Integer examId;

    @Column(name = "student_id", nullable = false)
    private Integer studentId;

    @Enumerated(EnumType.STRING)
    @Type(type = "postgresEnum")
    @Column(name = "mark")
    private MarkTypes mark;

    @Column(name = "mark_num")
    private Integer markNum;
}