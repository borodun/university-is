package ru.nsu.ccfit.universityis.backend.entities;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Type;
import ru.nsu.ccfit.universityis.backend.types.EnumToPostgres;
import ru.nsu.ccfit.universityis.backend.types.GenderTypes;

import javax.persistence.*;
import java.time.LocalDate;

@org.hibernate.annotations.TypeDef(name = "postgresEnum", typeClass = EnumToPostgres.class)

@Getter
@Setter
@Entity
@Table(name = "persons")
public class Person {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "first_name", nullable = false)
    private String firstName;

    @Column(name = "second_name", nullable = false)
    private String secondName;

    @Column(name = "last_name")
    private String lastName;

    @Enumerated(EnumType.STRING)
    @Type(type = "postgresEnum")
    @Column(name = "gender")
    private GenderTypes gender;

    @Column(name = "date_of_birth", nullable = false)
    private LocalDate dateOfBirth;

    @Column(name = "kids")
    private String kids;
}