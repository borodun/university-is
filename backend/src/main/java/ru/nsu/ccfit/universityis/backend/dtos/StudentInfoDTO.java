package ru.nsu.ccfit.universityis.backend.dtos;

import java.time.LocalDate;

public interface StudentInfoDTO {
    Integer getId();

    Integer getRecordBookNum();

    String getSecondName();

    String getFirstName();

    String getLastName();

    LocalDate getDateOfBirth();

    Integer getAge();

    Integer getGroupNumber();

    Integer getCourseNumber();

    String getFacultyName();

    String getKids();

    Integer getScholarship();
}
