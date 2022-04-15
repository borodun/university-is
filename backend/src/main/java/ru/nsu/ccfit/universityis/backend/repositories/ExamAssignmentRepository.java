package ru.nsu.ccfit.universityis.backend.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ru.nsu.ccfit.universityis.backend.entities.ExamAssignment;
import ru.nsu.ccfit.universityis.backend.keys.ExamAssignmentPK;

@Repository
public interface ExamAssignmentRepository extends JpaRepository<ExamAssignment, ExamAssignmentPK> {
}
