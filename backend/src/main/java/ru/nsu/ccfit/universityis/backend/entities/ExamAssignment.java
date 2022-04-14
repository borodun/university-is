package ru.nsu.ccfit.universityis.backend.entities;

import lombok.Getter;
import lombok.Setter;
import ru.nsu.ccfit.universityis.backend.keys.ExamAssignmentPK;

import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Table;

@Getter
@Setter
@Entity
@Table(name = "exam_assignments")
public class ExamAssignment {
    @EmbeddedId
    private ExamAssignmentPK examAssignmentPK;
}