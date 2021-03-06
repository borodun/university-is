package ru.nsu.ccfit.universityis.backend.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.nsu.ccfit.universityis.backend.entities.Curriculum;
import ru.nsu.ccfit.universityis.backend.services.CurriculumService;

import java.util.List;

@RestController
@RequestMapping(path = "api/v1/curriculum")
public class CurriculumController {

    private final CurriculumService service;

    @Autowired
    public CurriculumController(CurriculumService service) {
        this.service = service;
    }

    @GetMapping
    public List<Curriculum> getAll() {
        return service.getAll();
    }
}
