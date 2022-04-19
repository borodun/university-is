package ru.nsu.ccfit.universityis.backend.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import ru.nsu.ccfit.universityis.backend.dtos.*;
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
    List<StudentInfoDTO> findStudents(@Param("groupList") String groupList,
                                      @Param("courseList") String courseList,
                                      @Param("facultyList") String facultyList,
                                      @Param("genderList") String genderList,
                                      @Param("yearList") String yearList,
                                      @Param("ageList") String ageList,
                                      @Param("kidsCheck") Integer kidsCheck,
                                      @Param("scholarshipCheck") Integer scholarshipCheck,
                                      @Param("scholarshipInterval") String scholarshipInterval);

    @Query(nativeQuery = true, value = "SELECT * FROM find_student_exams(" +
            "CAST(:groupList AS INTEGER[]),\n" +
            "CAST(:examTypes AS exam_types[]),\n" +
            "CAST(:discipleList AS VARCHAR[]),\n" +
            "CAST(:markList AS mark_types[]))")
    List<StudentExamInfoDTO> findExams(@Param("groupList") String groupList,
                                       @Param("examTypes") String examTypes,
                                       @Param("discipleList") String discipleList,
                                       @Param("markList") String markList);

    @Query(nativeQuery = true, value = "SELECT * FROM find_student_sessions(" +
            "CAST(:groupList AS INTEGER[]),\n" +
            "CAST(:courseList AS INTEGER[]),\n" +
            "CAST(:facultyList AS VARCHAR[])," +
            "CAST(:sessionList AS VARCHAR[]),\n" +
            "CAST(:markList AS mark_types[]))")
    List<StudentSessionInfoDTO> findSessions(@Param("groupList") String groupList,
                                             @Param("courseList") String courseList,
                                             @Param("facultyList") String facultyList,
                                             @Param("sessionList") String sessionList,
                                             @Param("markList") String markList);

    @Query(nativeQuery = true, value = "SELECT * FROM find_student_marks(" +
            "CAST(:groupList AS INTEGER[]),\n" +
            "CAST(:courseList AS INTEGER[]),\n" +
            "CAST(:facultyList AS VARCHAR[])," +
            "CAST(:teacherList AS INTEGER[]),\n" +
            "CAST(:markList AS mark_types[]),\n" +
            "CAST(:discipleList AS VARCHAR[]),\n" +
            "CAST(:semesterList AS INTEGER[])," +
            "CAST(:dateInterval AS DATE[]))")
    List<StudentMarkInfoDTO> findMarks(@Param("groupList") String groupList,
                                       @Param("courseList") String courseList,
                                       @Param("facultyList") String facultyList,
                                       @Param("teacherList") String teacherList,
                                       @Param("markList") String markList,
                                       @Param("discipleList") String discipleList,
                                       @Param("semesterList") String semesterList,
                                       @Param("dateInterval") String dateInterval);

    @Query(nativeQuery = true, value = "SELECT * FROM find_student_diplomas(" +
            "CAST(:departmentList AS VARCHAR[]),\n" +
            "CAST(:teacherList AS INTEGER[]))")
    List<StudentDiplomaInfoDTO> findDiplomas(@Param("departmentList") String departmentList,
                                             @Param("teacherList") String teacherList);
}
