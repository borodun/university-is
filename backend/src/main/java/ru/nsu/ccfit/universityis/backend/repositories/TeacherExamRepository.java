package ru.nsu.ccfit.universityis.backend.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ru.nsu.ccfit.universityis.backend.entities.TeacherExam;

@Repository
public interface TeacherExamRepository extends JpaRepository<TeacherExam, Integer> {
}
