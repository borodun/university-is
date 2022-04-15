package ru.nsu.ccfit.universityis.backend.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.nsu.ccfit.universityis.backend.entities.StudyAssignment;
import ru.nsu.ccfit.universityis.backend.services.StudyAssignmentService;

import java.util.List;

@RestController
@RequestMapping(path = "api/v1/study-assignments")
public class StudyAssignmentController {

    private final StudyAssignmentService service;

    @Autowired
    public StudyAssignmentController(StudyAssignmentService service) {
        this.service = service;
    }

    @GetMapping
    public List<StudyAssignment> getAll() {
        return service.getAll();
    }
}
