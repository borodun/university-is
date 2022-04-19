package ru.nsu.ccfit.universityis.backend.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import ru.nsu.ccfit.universityis.backend.dtos.*;
import ru.nsu.ccfit.universityis.backend.entities.Teacher;
import ru.nsu.ccfit.universityis.backend.services.TeacherService;

import java.util.List;

@RestController
@RequestMapping(path = "api/v1/teachers")
public class TeacherController {

    private final TeacherService service;

    @Autowired
    public TeacherController(TeacherService service) {
        this.service = service;
    }

    @GetMapping
    public List<Teacher> getAll() {
        return service.getAll();
    }

    @GetMapping(path = "/find")
    public List<TeacherInfoDTO> findTeachers(@RequestParam(required = false, defaultValue = "{}") String departmentList,
                                             @RequestParam(required = false, defaultValue = "{}") String facultyList,
                                             @RequestParam(required = false, defaultValue = "{}") String positionList,
                                             @RequestParam(required = false, defaultValue = "{}") String genderList,
                                             @RequestParam(required = false, defaultValue = "{}") String yearList,
                                             @RequestParam(required = false, defaultValue = "{}") String ageList,
                                             @RequestParam(required = false, defaultValue = "-1") Integer kidsCount,
                                             @RequestParam(required = false, defaultValue = "{}") String salaryInterval,
                                             @RequestParam(required = false, defaultValue = "{}") String degreeList,
                                             @RequestParam(required = false, defaultValue = "{}") String articleList,
                                             @RequestParam(required = false, defaultValue = "{}") String articleDateInterval) {
        return service.findTeachers(departmentList,
                facultyList,
                positionList,
                genderList,
                yearList,
                ageList,
                kidsCount,
                salaryInterval,
                degreeList,
                articleList,
                articleDateInterval);
    }

    @GetMapping(path = "/find-articles")
    public List<TeacherArticleInfoDTO> findArticles(@RequestParam(required = false, defaultValue = "{}") String departmentList,
                                                    @RequestParam(required = false, defaultValue = "{}") String facultyList,
                                                    @RequestParam(required = false, defaultValue = "{}") String articleList,
                                                    @RequestParam(required = false, defaultValue = "{}") String articleDateInterval) {
        return service.findArticles(departmentList,
                facultyList,
                articleList,
                articleDateInterval);
    }

    @GetMapping(path = "/find-groups")
    public List<TeacherGroupInfoDTO> findGroups(@RequestParam(required = false, defaultValue = "{}") String discipleList,
                                                @RequestParam(required = false, defaultValue = "{}") String groupList,
                                                @RequestParam(required = false, defaultValue = "{}") String courseList,
                                                @RequestParam(required = false, defaultValue = "{}") String departmentList,
                                                @RequestParam(required = false, defaultValue = "{}") String facultyList) {
        return service.findGroups(discipleList,
                groupList,
                courseList,
                departmentList,
                facultyList);
    }

    @GetMapping(path = "/find-classes")
    public List<TeacherClassInfoDTO> findClasses(@RequestParam(required = false, defaultValue = "{}") String classTypes,
                                                 @RequestParam(required = false, defaultValue = "{}") String groupList,
                                                 @RequestParam(required = false, defaultValue = "{}") String courseList,
                                                 @RequestParam(required = false, defaultValue = "{}") String departmentList,
                                                 @RequestParam(required = false, defaultValue = "{}") String facultyList,
                                                 @RequestParam(required = false, defaultValue = "{}") String yearList,
                                                 @RequestParam(required = false, defaultValue = "{}") String semesterList) {
        return service.findClasses(classTypes,
                groupList,
                courseList,
                departmentList,
                facultyList,
                yearList,
                semesterList);
    }

    @GetMapping(path = "/find-exams")
    public List<TeacherExamInfoDTO> findExams(@RequestParam(required = false, defaultValue = "{}") String groupList,
                                              @RequestParam(required = false, defaultValue = "{}") String discipleList,
                                              @RequestParam(required = false, defaultValue = "{}") String semesterList) {
        return service.findExams(groupList,
                discipleList,
                semesterList);
    }

    @GetMapping(path = "/find-diplomas")
    public List<TeacherDiplomaInfoDTO> findDiplomas(@RequestParam(required = false, defaultValue = "{}") String departmentList,
                                                    @RequestParam(required = false, defaultValue = "{}") String facultyList,
                                                    @RequestParam(required = false, defaultValue = "{}") String positionList) {
        return service.findDiplomas(departmentList,
                facultyList,
                positionList);
    }

    @GetMapping(path = "/find-workloads")
    public List<TeacherWorkloadInfoDTO> findWorkloads(@RequestParam(required = false, defaultValue = "{}") String teacherList,
                                                      @RequestParam(required = false, defaultValue = "{}") String departmentList,
                                                      @RequestParam(required = false, defaultValue = "{}") String classTypes) {
        return service.findWorkloads(teacherList,
                departmentList,
                classTypes);
    }
}
