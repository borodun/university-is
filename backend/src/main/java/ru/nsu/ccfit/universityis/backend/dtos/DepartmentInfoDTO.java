package ru.nsu.ccfit.universityis.backend.dtos;

public interface DepartmentInfoDTO {

    Integer getId();
    Integer getDepartmentId();

    String getDepartmentName();

    String getFacultyName();

    Integer getGroupNumber();

    Integer getCourseNumber();

    Integer getYear();

    Integer getSemester();
}
