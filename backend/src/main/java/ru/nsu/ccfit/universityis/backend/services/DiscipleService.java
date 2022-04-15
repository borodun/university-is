package ru.nsu.ccfit.universityis.backend.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.universityis.backend.entities.Disciple;
import ru.nsu.ccfit.universityis.backend.repositories.DiscipleRepository;

import java.util.List;

@Service
public class DiscipleService {

    private final DiscipleRepository repository;

    @Autowired
    public DiscipleService(DiscipleRepository repository) {
        this.repository = repository;
    }

    public List<Disciple> getAll() {
        return repository.findAll();
    }
}
