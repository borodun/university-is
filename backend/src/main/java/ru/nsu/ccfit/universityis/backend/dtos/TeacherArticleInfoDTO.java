package ru.nsu.ccfit.universityis.backend.dtos;

import ru.nsu.ccfit.universityis.backend.types.ArticleTypes;

import java.time.LocalDate;

public interface TeacherArticleInfoDTO {
    Integer getId();

    String getSecondName();

    String getFirstName();

    String getLastName();

    String getDepartmentName();

    String getFacultyName();

    String getArticleTitle();

    ArticleTypes getArticleType();

    LocalDate getDefendDate();
}
