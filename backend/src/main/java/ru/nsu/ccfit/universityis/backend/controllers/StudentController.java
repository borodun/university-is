package ru.nsu.ccfit.universityis.backend.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import ru.nsu.ccfit.universityis.backend.dtos.StudentDTO;
import ru.nsu.ccfit.universityis.backend.entities.Student;
import ru.nsu.ccfit.universityis.backend.services.StudentService;

import java.util.List;

@RestController
@RequestMapping(path = "api/v1/students")
public class StudentController {

    private final StudentService service;

    @Autowired
    public StudentController(StudentService service) {
        this.service = service;
    }

    @GetMapping
    public List<Student> getAll() {
        return service.getAll();
    }

    @GetMapping(path = "/find")
    public List<StudentDTO> findStudents(@RequestParam(required = false, defaultValue = "{}") String groupList,
                                         @RequestParam(required = false, defaultValue = "{}") String courseList,
                                         @RequestParam(required = false, defaultValue = "{}") String facultyList,
                                         @RequestParam(required = false, defaultValue = "{}") String genderList,
                                         @RequestParam(required = false, defaultValue = "{}") String yearList,
                                         @RequestParam(required = false, defaultValue = "{}") String ageList,
                                         @RequestParam(required = false, defaultValue = "-1") Integer kidsCheck,
                                         @RequestParam(required = false, defaultValue = "-1") Integer scholarshipCheck,
                                         @RequestParam(required = false, defaultValue = "{}") String scholarshipInterval) {

        return service.findStudents(groupList,
                courseList,
                facultyList,
                genderList,
                yearList,
                ageList,
                kidsCheck,
                scholarshipCheck,
                scholarshipInterval);
    }
}
