package ru.nsu.ccfit.universityis.backend.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ru.nsu.ccfit.universityis.backend.entities.StudyAssignment;

@Repository
public interface StudyAssignmentRepository extends JpaRepository<StudyAssignment, Integer> {
}
