package ru.nsu.ccfit.universityis.backend.dtos;

public interface StudentDiplomaInfoDTO {
    Integer getId();

    Integer getRecordBookNum();

    String getSecondName();

    String getFirstName();

    String getLastName();

    Integer getGroupNumber();

    Integer getCourseNumber();

    String getFacultyName();

    String getDiplomaTitle();

    String getScientificDirector();
}
