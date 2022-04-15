package ru.nsu.ccfit.universityis.backend.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.universityis.backend.entities.StudyAssignment;
import ru.nsu.ccfit.universityis.backend.repositories.StudyAssignmentRepository;

import java.util.List;

@Service
public class StudyAssignmentService {

    private final StudyAssignmentRepository repository;

    @Autowired
    public StudyAssignmentService(StudyAssignmentRepository repository) {
        this.repository = repository;
    }

    public List<StudyAssignment> getAll() {
        return repository.findAll();
    }
}
