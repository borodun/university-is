package ru.nsu.ccfit.universityis.backend.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.nsu.ccfit.universityis.backend.entities.Faculty;
import ru.nsu.ccfit.universityis.backend.services.FacultyService;

import java.util.List;

@RestController
@RequestMapping(path = "api/v1/faculties")
public class FacultyController {

    private final FacultyService service;

    @Autowired
    public FacultyController(FacultyService service) {
        this.service = service;
    }

    @GetMapping
    public List<Faculty> getAll() {
        return service.getAll();
    }
}
