package ru.nsu.ccfit.universityis.backend.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import ru.nsu.ccfit.universityis.backend.dtos.StudentDTO;
import ru.nsu.ccfit.universityis.backend.entities.Student;

import java.util.List;

@Repository
public interface StudentRepository extends JpaRepository<Student, Integer> {

    @Query(nativeQuery = true, value = "SELECT * FROM find_students(" +
            "CAST(:groupList AS INTEGER[])," +
            "CAST(:courseList AS INTEGER[])," +
            "CAST(:facultyList AS VARCHAR[])," +
            "CAST(:genderList AS gender_types[])," +
            "CAST(:yearList AS INTEGER[])," +
            "CAST(:ageList AS INTEGER[])," +
            ":kidsCheck," +
            ":scholarshipCheck," +
            "CAST(:scholarshipInterval AS INTEGER[]))")
    List<StudentDTO> findStudents(@Param("groupList") String groupList,
                                  @Param("courseList") String courseList,
                                  @Param("facultyList") String facultyList,
                                  @Param("genderList") String genderList,
                                  @Param("yearList") String yearList,
                                  @Param("ageList") String ageList,
                                  @Param("kidsCheck") Integer kidsCheck,
                                  @Param("scholarshipCheck") Integer scholarshipCheck,
                                  @Param("scholarshipInterval") String scholarshipInterval);

}
