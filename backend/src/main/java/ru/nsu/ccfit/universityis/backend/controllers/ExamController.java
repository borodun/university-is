package ru.nsu.ccfit.universityis.backend.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.nsu.ccfit.universityis.backend.entities.Exam;
import ru.nsu.ccfit.universityis.backend.services.ExamService;

import java.util.List;

@RestController
@RequestMapping(path = "api/v1/exams")
public class ExamController {

    private final ExamService service;

    @Autowired
    public ExamController(ExamService service) {
        this.service = service;
    }

    @GetMapping
    public List<Exam> getAll() {
        return service.getAll();
    }
}
