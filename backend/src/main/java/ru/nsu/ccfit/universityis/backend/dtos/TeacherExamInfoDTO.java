package ru.nsu.ccfit.universityis.backend.dtos;

import ru.nsu.ccfit.universityis.backend.types.ExamTypes;

public interface TeacherExamInfoDTO {
    Integer getId();

    String getSecondName();

    String getFirstName();

    String getLastName();

    String getDepartmentName();

    String getFacultyName();

    String getGroupNumbers();

    Integer getCourseNumber();

    ExamTypes getExamType();

    String getDisciple();

    Integer getYear();

    Integer getSemester();
}
