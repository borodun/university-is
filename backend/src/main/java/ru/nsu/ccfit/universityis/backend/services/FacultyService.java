package ru.nsu.ccfit.universityis.backend.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.universityis.backend.entities.Faculty;
import ru.nsu.ccfit.universityis.backend.repositories.FacultyRepository;

import java.util.List;

@Service
public class FacultyService {

    private final FacultyRepository repository;

    @Autowired
    public FacultyService(FacultyRepository repository) {
        this.repository = repository;
    }

    public List<Faculty> getAll() {
        return repository.findAll();
    }
}
