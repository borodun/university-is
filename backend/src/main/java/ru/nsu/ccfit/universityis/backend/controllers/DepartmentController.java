package ru.nsu.ccfit.universityis.backend.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import ru.nsu.ccfit.universityis.backend.dtos.DepartmentInfoDTO;
import ru.nsu.ccfit.universityis.backend.entities.Department;
import ru.nsu.ccfit.universityis.backend.services.DepartmentService;

import java.util.List;

@RestController
@RequestMapping(path = "api/v1/departments")
public class DepartmentController {

    private final DepartmentService service;

    @Autowired
    public DepartmentController(DepartmentService service) {
        this.service = service;
    }

    @GetMapping
    public List<Department> getAll() {
        return service.getAll();
    }

    @GetMapping(path = "/find")
    public List<DepartmentInfoDTO> findDepartments(@RequestParam(required = false, defaultValue = "{}") String groupList,
                                                   @RequestParam(required = false, defaultValue = "{}") String courseList,
                                                   @RequestParam(required = false, defaultValue = "{}") String departmentList,
                                                   @RequestParam(required = false, defaultValue = "{}") String facultyList,
                                                   @RequestParam(required = false, defaultValue = "{}") String yearInterval,
                                                   @RequestParam(required = false, defaultValue = "{}") String semesterList) {
        return service.findDepartments(groupList,
                courseList,
                departmentList,
                facultyList,
                yearInterval,
                semesterList);
    }
}
