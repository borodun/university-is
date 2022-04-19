package ru.nsu.ccfit.universityis.backend.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.universityis.backend.dtos.*;
import ru.nsu.ccfit.universityis.backend.entities.Teacher;
import ru.nsu.ccfit.universityis.backend.repositories.TeacherRepository;

import java.util.List;

@Service
public class TeacherService {

    private final TeacherRepository repository;

    @Autowired
    public TeacherService(TeacherRepository repository) {
        this.repository = repository;
    }

    public List<Teacher> getAll() {
        return repository.findAll();
    }

    public List<TeacherInfoDTO> findTeachers(String departmentList,
                                             String facultyList,
                                             String positionList,
                                             String genderList,
                                             String yearList,
                                             String ageList,
                                             Integer kidsCount,
                                             String salaryInterval,
                                             String degreeList,
                                             String articleList,
                                             String articleDateInterval) {
        return repository.findTeachers(departmentList,
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

    public List<TeacherArticleInfoDTO> findArticles(String departmentList,
                                                    String facultyList,
                                                    String articleList,
                                                    String articleDateInterval) {
        return repository.findArticles(departmentList,
                facultyList,
                articleList,
                articleDateInterval);
    }

    public List<TeacherGroupInfoDTO> findGroups(String discipleList,
                                                String groupList,
                                                String courseList,
                                                String departmentList,
                                                String facultyList) {
        return repository.findGroups(discipleList,
                groupList,
                courseList,
                departmentList,
                facultyList);
    }

    public List<TeacherClassInfoDTO> findClasses(String classTypes,
                                                 String groupList,
                                                 String courseList,
                                                 String departmentList,
                                                 String facultyList,
                                                 String yearList,
                                                 String semesterList) {
        return repository.findClasses(classTypes,
                groupList,
                courseList,
                departmentList,
                facultyList,
                yearList,
                semesterList);
    }

    public List<TeacherExamInfoDTO> findExams(String groupList,
                                              String discipleList,
                                              String semesterList) {
        return repository.findExams(groupList,
                discipleList,
                semesterList);
    }

    public List<TeacherDiplomaInfoDTO> findDiplomas(String departmentList,
                                                    String facultyList,
                                                    String positionList) {
        return repository.findDiplomas(departmentList,
                facultyList,
                positionList);
    }

    public List<TeacherWorkloadInfoDTO> findWorkloads(String teacherList,
                                                      String departmentList,
                                                      String classTypes) {
        return repository.findWorkloads(teacherList,
                departmentList,
                classTypes);
    }
}
