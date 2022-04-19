package ru.nsu.ccfit.universityis.backend.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.universityis.backend.dtos.*;
import ru.nsu.ccfit.universityis.backend.entities.Student;
import ru.nsu.ccfit.universityis.backend.repositories.StudentRepository;

import java.util.List;

@Service
public class StudentService {

    private final StudentRepository repository;

    @Autowired
    public StudentService(StudentRepository repository) {
        this.repository = repository;
    }

    public List<Student> getAll() {
        return repository.findAll();
    }

    public List<StudentInfoDTO> findStudents(String groupList,
                                             String courseList,
                                             String facultyList,
                                             String genderList,
                                             String yearList,
                                             String ageList,
                                             Integer kidsCheck,
                                             Integer scholarshipCheck,
                                             String scholarshipInterval) {

        return repository.findStudents(groupList,
                courseList,
                facultyList,
                genderList,
                yearList,
                ageList,
                kidsCheck,
                scholarshipCheck,
                scholarshipInterval);
    }

    public List<StudentExamInfoDTO> findExams(String groupList,
                                              String examTypes,
                                              String discipleList,
                                              String markList) {
        return repository.findExams(groupList,
                examTypes,
                discipleList,
                markList);
    }

    public List<StudentSessionInfoDTO> findSessions(String groupList,
                                                    String courseList,
                                                    String facultyList,
                                                    String sessionList,
                                                    String markList) {
        return repository.findSessions(groupList,
                courseList,
                facultyList,
                sessionList,
                markList);
    }

    public List<StudentMarkInfoDTO> findMarks(String groupList,
                                              String courseList,
                                              String facultyList,
                                              String teacherList,
                                              String markList,
                                              String discipleList,
                                              String semesterList,
                                              String dateInterval) {
        return repository.findMarks(groupList,
                courseList,
                facultyList,
                teacherList,
                markList,
                discipleList,
                semesterList,
                dateInterval);
    }

    public List<StudentDiplomaInfoDTO> findDiplomas(String departmentList,
                                                    String teacherList) {
        return repository.findDiplomas(departmentList,
                teacherList);
    }
}
