package ru.nsu.ccfit.universityis.backend.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.universityis.backend.dtos.StudentDTO;
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

    public List<StudentDTO> findStudents(String groupList,
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
}
