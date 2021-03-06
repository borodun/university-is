package ru.nsu.ccfit.universityis.backend.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.universityis.backend.dtos.DepartmentInfoDTO;
import ru.nsu.ccfit.universityis.backend.entities.Department;
import ru.nsu.ccfit.universityis.backend.repositories.DepartmentRepository;

import java.util.List;

@Service
public class DepartmentService {

    private final DepartmentRepository repository;

    @Autowired
    public DepartmentService(DepartmentRepository repository) {
        this.repository = repository;
    }

    public List<Department> getAll() {
        return repository.findAll();
    }

    public List<DepartmentInfoDTO> findDepartments(String groupList,
                                            String courseList,
                                            String departmentList,
                                            String facultyList,
                                            String yearInterval,
                                            String semesterList) {
        return repository.findDepartments(groupList,
                courseList,
                departmentList,
                facultyList,
                yearInterval,
                semesterList);
    }
}
