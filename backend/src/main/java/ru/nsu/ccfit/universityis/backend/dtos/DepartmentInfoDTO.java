package ru.nsu.ccfit.universityis.backend.dtos;

public interface DepartmentInfoDTO {
    Integer getId();

    String getDepartmentName();

    String getFacultyName();

    Integer getGroupNumber();

    Integer getCourseNumber();

    Integer getYear();

    Integer getSemester();
}
