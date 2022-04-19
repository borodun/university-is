package ru.nsu.ccfit.universityis.backend.dtos;

import ru.nsu.ccfit.universityis.backend.types.AcademicDegrees;
import ru.nsu.ccfit.universityis.backend.types.PositionTypes;

import java.time.LocalDate;

public interface TeacherInfoDTO {
    Integer getId();

    String getSecondName();

    String getFirstName();

    String getLastName();

    LocalDate getDateOfBirth();

    Integer getAge();

    String getDepartmentName();

    String getFacultyName();

    PositionTypes getPositionType();

    String getKids();

    Integer getSalary();

    AcademicDegrees getDegree();

    String getDefendedArticles();
}
