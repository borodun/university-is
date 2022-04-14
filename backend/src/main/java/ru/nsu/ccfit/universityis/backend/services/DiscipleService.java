package ru.nsu.ccfit.universityis.backend.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.universityis.backend.entities.Disciple;
import ru.nsu.ccfit.universityis.backend.repositories.DiscipleRepository;

import java.util.List;

@Service
public class DiscipleService {

    private final DiscipleRepository discipleRepository;

    @Autowired
    public DiscipleService(DiscipleRepository discipleRepository) {
        this.discipleRepository = discipleRepository;
    }

    public List<Disciple> getDisciples() {
        return discipleRepository.findAll();
    }
}
