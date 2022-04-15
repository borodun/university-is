package ru.nsu.ccfit.universityis.backend.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.nsu.ccfit.universityis.backend.entities.Pass;
import ru.nsu.ccfit.universityis.backend.services.PassService;

import java.util.List;

@RestController
@RequestMapping(path = "api/v1/passes")
public class PassController {

    private final PassService service;

    @Autowired
    public PassController(PassService service) {
        this.service = service;
    }

    @GetMapping
    public List<Pass> getAll() {
        return service.getAll();
    }
}
