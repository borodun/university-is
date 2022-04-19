package ru.nsu.ccfit.universityis.backend.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import ru.nsu.ccfit.universityis.backend.dtos.*;
import ru.nsu.ccfit.universityis.backend.entities.Teacher;

import java.util.List;

@Repository
public interface TeacherRepository extends JpaRepository<Teacher, Integer> {

    @Query(nativeQuery = true, value = "SELECT * FROM find_teachers(" +
            "CAST(:departmentList AS VARCHAR[])," +
            "CAST(:facultyList AS VARCHAR[])," +
            "CAST(:positionList AS position_types[])," +
            "CAST(:genderList AS gender_types[])," +
            "CAST(:yearList AS INTEGER[])," +
            "CAST(:ageList AS INTEGER[])," +
            ":kidsCount," +
            "CAST(:salaryInterval AS INTEGER[])," +
            "CAST(:degreeList AS academic_degrees[])," +
            "CAST(:articleList AS article_types[])," +
            "CAST(:articleDateInterval AS DATE[]))")
    List<TeacherInfoDTO> findTeachers(@Param("departmentList") String departmentList,
                                      @Param("facultyList") String facultyList,
                                      @Param("positionList") String positionList,
                                      @Param("genderList") String genderList,
                                      @Param("yearList") String yearList,
                                      @Param("ageList") String ageList,
                                      @Param("kidsCount") Integer kidsCount,
                                      @Param("salaryInterval") String salaryInterval,
                                      @Param("degreeList") String degreeList,
                                      @Param("articleList") String articleList,
                                      @Param("articleDateInterval") String articleDateInterval);

    @Query(nativeQuery = true, value = "SELECT * FROM find_articles(" +
            "CAST(:departmentList AS VARCHAR[])," +
            "CAST(:facultyList AS VARCHAR[])," +
            "CAST(:articleList AS article_types[])," +
            "CAST(:articleDateInterval AS DATE[]))")
    List<TeacherArticleInfoDTO> findArticles(@Param("departmentList") String departmentList,
                                             @Param("facultyList") String facultyList,
                                             @Param("articleList") String articleList,
                                             @Param("articleDateInterval") String articleDateInterval);

    @Query(nativeQuery = true, value = "SELECT * FROM find_teacher_groups(" +
            "CAST(:discipleList AS VARCHAR[]),\n" +
            "CAST(:groupList AS INTEGER[]),\n" +
            "CAST(:courseList AS INTEGER[])," +
            "CAST(:departmentList AS VARCHAR[])," +
            "CAST(:facultyList AS VARCHAR[]))")
    List<TeacherGroupInfoDTO> findGroups(@Param("discipleList") String discipleList,
                                         @Param("groupList") String groupList,
                                         @Param("courseList") String courseList,
                                         @Param("departmentList") String departmentList,
                                         @Param("facultyList") String facultyList);

    @Query(nativeQuery = true, value = "SELECT * FROM find_teacher_classes(" +
            "CAST(:classTypes AS class_types[]),\n" +
            "CAST(:groupList AS INTEGER[]),\n" +
            "CAST(:courseList AS INTEGER[])," +
            "CAST(:departmentList AS VARCHAR[])," +
            "CAST(:facultyList AS VARCHAR[])," +
            "CAST(:yearList AS INTEGER[])," +
            "CAST(:semesterList AS INTEGER[]))")
    List<TeacherClassInfoDTO> findClasses(@Param("classTypes") String classTypes,
                                          @Param("groupList") String groupList,
                                          @Param("courseList") String courseList,
                                          @Param("departmentList") String departmentList,
                                          @Param("facultyList") String facultyList,
                                          @Param("yearList") String yearList,
                                          @Param("semesterList") String semesterList);

    @Query(nativeQuery = true, value = "SELECT * FROM find_teacher_exams(" +
            "CAST(:groupList AS INTEGER[]),\n" +
            "CAST(:discipleList AS VARCHAR[])," +
            "CAST(:semesterList AS INTEGER[]))")
    List<TeacherExamInfoDTO> findExams(@Param("groupList") String groupList,
                                       @Param("discipleList") String discipleList,
                                       @Param("semesterList") String semesterList);

    @Query(nativeQuery = true, value = "SELECT * FROM find_teacher_diplomas(" +
            "CAST(:departmentList AS VARCHAR[]),\n" +
            "CAST(:facultyList AS VARCHAR[])," +
            "CAST(:positionList AS position_types[]))")
    List<TeacherDiplomaInfoDTO> findDiplomas(@Param("departmentList") String departmentList,
                                             @Param("facultyList") String facultyList,
                                             @Param("positionList") String positionList);

    @Query(nativeQuery = true, value = "SELECT * FROM find_teacher_workloads(" +
            "CAST(:teacherList AS INTEGER[]),\n" +
            "CAST(:departmentList AS VARCHAR[])," +
            "CAST(:classTypes AS class_types[]))")
    List<TeacherWorkloadInfoDTO> findWorkloads(@Param("teacherList") String teacherList,
                                               @Param("departmentList") String departmentList,
                                               @Param("classTypes") String classTypes);
}
