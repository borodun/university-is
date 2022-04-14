package ru.nsu.ccfit.universityis.backend.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.nsu.ccfit.universityis.backend.entities.Disciple;
import ru.nsu.ccfit.universityis.backend.services.DiscipleService;

import java.util.List;

@RestController
@RequestMapping(path = "api/v1/disciples")
public class DiscipleController {

    private final DiscipleService discipleService;

    @Autowired
    public DiscipleController(DiscipleService discipleService) {
        this.discipleService = discipleService;
    }

    @GetMapping
    public List<Disciple> getDisciples() {
        return discipleService.getDisciples();
    }
}
