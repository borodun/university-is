package ru.nsu.ccfit.universityis.backend.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.universityis.backend.entities.Exam;
import ru.nsu.ccfit.universityis.backend.repositories.ExamRepository;

import java.util.List;

@Service
public class ExamService {

    private final ExamRepository repository;

    @Autowired
    public ExamService(ExamRepository repository) {
        this.repository = repository;
    }

    public List<Exam> getAll() {
        return repository.findAll();
    }
}
