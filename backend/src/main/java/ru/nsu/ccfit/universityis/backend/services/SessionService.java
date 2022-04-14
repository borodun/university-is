package ru.nsu.ccfit.universityis.backend.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.universityis.backend.entities.Disciple;
import ru.nsu.ccfit.universityis.backend.entities.Session;
import ru.nsu.ccfit.universityis.backend.repositories.DiscipleRepository;
import ru.nsu.ccfit.universityis.backend.repositories.SessionRepository;

import java.util.List;

@Service
public class SessionService {

    private final SessionRepository sessionRepository;

    @Autowired
    public SessionService(SessionRepository sessionRepository) {
        this.sessionRepository = sessionRepository;
    }

    public List<Session> getSessions() {
        return sessionRepository.findAll();
    }
}
