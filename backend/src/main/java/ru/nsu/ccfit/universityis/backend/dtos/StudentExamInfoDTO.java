package ru.nsu.ccfit.universityis.backend.dtos;

import ru.nsu.ccfit.universityis.backend.types.ExamTypes;

public interface StudentExamInfoDTO {
    Integer getId();

    Integer getRecordBookNum();

    String getSecondName();

    String getFirstName();

    String getLastName();

    Integer getGroupNumber();

    Integer getCourseNumber();

    String getFacultyName();

    String getDiscipleName();

    ExamTypes getExamType();

    String getMark();
}
