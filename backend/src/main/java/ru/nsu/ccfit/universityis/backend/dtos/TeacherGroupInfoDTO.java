package ru.nsu.ccfit.universityis.backend.dtos;

public interface TeacherGroupInfoDTO {

    Integer getId();
    Integer getTeacherId();

    String getSecondName();

    String getFirstName();

    String getLastName();

    String getDepartmentName();

    String getFacultyName();

    Integer getGroupNumber();

    Integer getCourseNumber();

    String getDisciple();
}
