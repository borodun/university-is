package ru.nsu.ccfit.universityis.backend.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.universityis.backend.entities.DefendedDegree;
import ru.nsu.ccfit.universityis.backend.repositories.DefendedDegreeRepository;

import java.util.List;

@Service
public class DefendedDegreeService {

    private final DefendedDegreeRepository repository;

    @Autowired
    public DefendedDegreeService(DefendedDegreeRepository repository) {
        this.repository = repository;
    }

    public List<DefendedDegree> getAll() {
        return repository.findAll();
    }
}
