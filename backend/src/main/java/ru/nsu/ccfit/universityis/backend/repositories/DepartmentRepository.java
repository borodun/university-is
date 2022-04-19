package ru.nsu.ccfit.universityis.backend.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import ru.nsu.ccfit.universityis.backend.dtos.DepartmentInfoDTO;
import ru.nsu.ccfit.universityis.backend.entities.Department;

import java.util.List;

@Repository
public interface DepartmentRepository extends JpaRepository<Department, Integer> {

    @Query(nativeQuery = true, value = "SELECT * FROM find_departments(" +
            "CAST(:groupList AS INTEGER[])," +
            "CAST(:courseList AS INTEGER[])," +
            "CAST(:departmentList AS VARCHAR[])," +
            "CAST(:facultyList AS VARCHAR[])," +
            "CAST(:yearInterval AS INTEGER[])," +
            "CAST(:semesterList AS INTEGER[]))")
    List<DepartmentInfoDTO> findDepartments(@Param("groupList") String groupList,
                                            @Param("courseList") String courseList,
                                            @Param("departmentList") String departmentList,
                                            @Param("facultyList") String facultyList,
                                            @Param("yearInterval") String yearInterval,
                                            @Param("semesterList") String semesterList);
}
