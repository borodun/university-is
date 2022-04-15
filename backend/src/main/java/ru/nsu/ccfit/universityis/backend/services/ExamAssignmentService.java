package ru.nsu.ccfit.universityis.backend.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.universityis.backend.entities.ExamAssignment;
import ru.nsu.ccfit.universityis.backend.repositories.ExamAssignmentRepository;

import java.util.List;

@Service
public class ExamAssignmentService {

    private final ExamAssignmentRepository repository;

    @Autowired
    public ExamAssignmentService(ExamAssignmentRepository repository) {
        this.repository = repository;
    }

    public List<ExamAssignment> getAll() {
        return repository.findAll();
    }
}
