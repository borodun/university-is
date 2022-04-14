package ru.nsu.ccfit.universityis.backend.keys;

import lombok.*;
import org.hibernate.annotations.Type;
import ru.nsu.ccfit.universityis.backend.types.ExamTypes;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import java.io.Serializable;

@Getter
@Setter
@EqualsAndHashCode
@NoArgsConstructor
@AllArgsConstructor
@Embeddable
public class ExamAssignmentPK implements Serializable {

    @Column(name = "disciple_id")
    private Integer discipleId;

    @Enumerated(EnumType.STRING)
    @Type(type = "postgresEnum")
    @Column(name = "exam_type")
    private ExamTypes examType;
}
