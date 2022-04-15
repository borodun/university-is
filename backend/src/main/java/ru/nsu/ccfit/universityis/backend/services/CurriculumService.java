package ru.nsu.ccfit.universityis.backend.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.universityis.backend.entities.Curriculum;
import ru.nsu.ccfit.universityis.backend.repositories.CurriculumRepository;

import java.util.List;

@Service
public class CurriculumService {

    private final CurriculumRepository repository;

    @Autowired
    public CurriculumService(CurriculumRepository repository) {
        this.repository = repository;
    }

    public List<Curriculum> getAll() {
        return repository.findAll();
    }
}
