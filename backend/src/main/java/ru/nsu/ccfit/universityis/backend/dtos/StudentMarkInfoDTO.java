package ru.nsu.ccfit.universityis.backend.dtos;

import java.time.LocalDate;

public interface StudentMarkInfoDTO {
    Integer getId();

    Integer getRecordBookNum();

    String getSecondName();

    String getFirstName();

    String getLastName();

    Integer getGroupNumber();

    Integer getCourseNumber();

    String getFacultyName();

    String getDiscipleName();

    String getMark();

    String getTeacherName();

    LocalDate getExamDate();

    Integer getSemester();
}
