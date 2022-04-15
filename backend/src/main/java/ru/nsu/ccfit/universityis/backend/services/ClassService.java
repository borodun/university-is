package ru.nsu.ccfit.universityis.backend.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.universityis.backend.entities.Class;
import ru.nsu.ccfit.universityis.backend.repositories.ClassRepository;

import java.util.List;

@Service
public class ClassService {

    private final ClassRepository repository;

    @Autowired
    public ClassService(ClassRepository repository) {
        this.repository = repository;
    }

    public List<Class> getAll() {
        return repository.findAll();
    }
}
