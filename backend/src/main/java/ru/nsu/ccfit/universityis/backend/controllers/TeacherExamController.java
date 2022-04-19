package ru.nsu.ccfit.universityis.backend.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.nsu.ccfit.universityis.backend.entities.TeacherExam;
import ru.nsu.ccfit.universityis.backend.services.TeacherExamService;

import java.util.List;

@RestController
@RequestMapping(path = "api/v1/teacher-exams")
public class TeacherExamController {

    private final TeacherExamService service;

    @Autowired
    public TeacherExamController(TeacherExamService service) {
        this.service = service;
    }

    @GetMapping
    public List<TeacherExam> getAll() {
        return service.getAll();
    }
}
