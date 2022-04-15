package ru.nsu.ccfit.universityis.backend.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.nsu.ccfit.universityis.backend.entities.ExamAssignment;
import ru.nsu.ccfit.universityis.backend.services.ExamAssignmentService;

import java.util.List;

@RestController
@RequestMapping(path = "api/v1/exam-assignments")
public class ExamAssignmentController {

    private final ExamAssignmentService service;

    @Autowired
    public ExamAssignmentController(ExamAssignmentService service) {
        this.service = service;
    }

    @GetMapping
    public List<ExamAssignment> getAll() {
        return service.getAll();
    }
}
