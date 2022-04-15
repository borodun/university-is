package ru.nsu.ccfit.universityis.backend.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.nsu.ccfit.universityis.backend.entities.Class;
import ru.nsu.ccfit.universityis.backend.services.ClassService;

import java.util.List;

@RestController
@RequestMapping(path = "api/v1/classes")
public class ClassController {

    private final ClassService service;

    @Autowired
    public ClassController(ClassService service) {
        this.service = service;
    }

    @GetMapping
    public List<Class> getAll() {
        return service.getAll();
    }
}
