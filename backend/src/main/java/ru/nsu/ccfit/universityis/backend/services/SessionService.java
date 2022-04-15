package ru.nsu.ccfit.universityis.backend.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.universityis.backend.entities.Session;
import ru.nsu.ccfit.universityis.backend.repositories.SessionRepository;

import java.util.List;

@Service
public class SessionService {

    private final SessionRepository repository;

    @Autowired
    public SessionService(SessionRepository repository) {
        this.repository = repository;
    }

    public List<Session> getAll() {
        return repository.findAll();
    }
}
