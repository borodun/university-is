package ru.nsu.ccfit.universityis.backend.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.universityis.backend.entities.Pass;
import ru.nsu.ccfit.universityis.backend.repositories.PassRepository;

import java.util.List;

@Service
public class PassService {

    private final PassRepository repository;

    @Autowired
    public PassService(PassRepository repository) {
        this.repository = repository;
    }

    public List<Pass> getAll() {
        return repository.findAll();
    }
}
