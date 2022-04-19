package ru.nsu.ccfit.universityis.backend.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.universityis.backend.entities.TeacherExam;
import ru.nsu.ccfit.universityis.backend.repositories.TeacherExamRepository;

import java.util.List;

@Service
public class TeacherExamService {

    private final TeacherExamRepository repository;

    @Autowired
    public TeacherExamService(TeacherExamRepository repository) {
        this.repository = repository;
    }

    public List<TeacherExam> getAll() {
        return repository.findAll();
    }
}
