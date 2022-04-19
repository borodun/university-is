package ru.nsu.ccfit.universityis.backend.dtos;

import ru.nsu.ccfit.universityis.backend.types.ClassTypes;

public interface TeacherClassInfoDTO {
    Integer getId();

    String getSecondName();

    String getFirstName();

    String getLastName();

    String getDepartmentName();

    String getFacultyName();

    Integer getGroupNumber();

    Integer getCourseNumber();

    String getDisciple();

    ClassTypes getClassType();

    Integer getYear();

    Integer getSemester();
}
