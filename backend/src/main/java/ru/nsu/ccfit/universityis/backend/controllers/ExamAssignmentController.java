package ru.nsu.ccfit.universityis.backend.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.nsu.ccfit.universityis.backend.entities.Exam;
import ru.nsu.ccfit.universityis.backend.entities.ExamAssignment;
import ru.nsu.ccfit.universityis.backend.services.ExamAssignmentService;
import ru.nsu.ccfit.universityis.backend.services.ExamService;

import java.util.List;

@RestController
@RequestMapping(path = "api/v1/exams-assignments")
public class ExamAssignmentController {


    private final ExamAssignmentService examAssignmentService;

    @Autowired
    public ExamAssignmentController(ExamAssignmentService examAssignmentService) {
        this.examAssignmentService = examAssignmentService;
    }

    @GetMapping
    public List<ExamAssignment> getExams() {
        return examAssignmentService.getExamsAssignments();
    }
}
