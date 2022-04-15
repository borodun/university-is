package ru.nsu.ccfit.universityis.backend.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.nsu.ccfit.universityis.backend.entities.Session;
import ru.nsu.ccfit.universityis.backend.services.SessionService;

import java.util.List;

@RestController
@RequestMapping(path = "api/v1/sessions")
public class SessionController {

    private final SessionService service;

    @Autowired
    public SessionController(SessionService service) {
        this.service = service;
    }

    @GetMapping
    public List<Session> getAll() {
        return service.getAll();
    }
}
