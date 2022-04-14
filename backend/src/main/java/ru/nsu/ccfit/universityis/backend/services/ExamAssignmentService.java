package ru.nsu.ccfit.universityis.backend.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.universityis.backend.entities.Exam;
import ru.nsu.ccfit.universityis.backend.entities.ExamAssignment;
import ru.nsu.ccfit.universityis.backend.repositories.ExamAssignmentsRepository;
import ru.nsu.ccfit.universityis.backend.repositories.ExamRepository;

import java.util.List;

@Service
public class ExamAssignmentService {

    private final ExamAssignmentsRepository examAssignmentsRepository;

    @Autowired
    public ExamAssignmentService(ExamAssignmentsRepository examAssignmentsRepository) {
        this.examAssignmentsRepository = examAssignmentsRepository;
    }

    public List<ExamAssignment> getExamsAssignments() {
        return examAssignmentsRepository.findAll();
    }
}
