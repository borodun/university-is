package ru.nsu.ccfit.universityis.backend.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.nsu.ccfit.universityis.backend.entities.DefendedDegree;
import ru.nsu.ccfit.universityis.backend.services.DefendedDegreeService;

import java.util.List;

@RestController
@RequestMapping(path = "api/v1/defended-degrees")
public class DefendedDegreeController {

    private final DefendedDegreeService service;

    @Autowired
    public DefendedDegreeController(DefendedDegreeService service) {
        this.service = service;
    }

    @GetMapping
    public List<DefendedDegree> getAll() {
        return service.getAll();
    }
}
