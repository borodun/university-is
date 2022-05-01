package ru.nsu.ccfit.universityis.backend.dtos;

import ru.nsu.ccfit.universityis.backend.types.PositionTypes;

public interface TeacherDiplomaInfoDTO {

    Integer getId();
    Integer getTeacherId();

    String getSecondName();

    String getFirstName();

    String getLastName();

    String getDepartmentName();

    String getFacultyName();

    PositionTypes getPositionType();

    String getDiplomaTitles();

    String getStudentName();
}
