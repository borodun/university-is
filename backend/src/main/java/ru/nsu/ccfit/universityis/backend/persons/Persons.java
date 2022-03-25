package ru.nsu.ccfit.universityis.backend.persons;

import org.hibernate.annotations.Type;
import ru.nsu.ccfit.universityis.backend.types.EnumToPostgres;
import ru.nsu.ccfit.universityis.backend.types.GenderTypes;

import javax.persistence.*;
import java.time.LocalDate;

@org.hibernate.annotations.TypeDef(name = "postgres_enum", typeClass = EnumToPostgres.class)

@Entity
@Table
public class Persons {

    @Id
    @SequenceGenerator(
            name = "personsSequence",
            sequenceName = "persons_id_seq",
            allocationSize = 1
    )
    @GeneratedValue(
            generator = "personsSequence",
            strategy = GenerationType.SEQUENCE
    )
    private Long id;
    private String firstName;
    private String secondName;
    private String lastName;
    @Enumerated(EnumType.STRING)
    @Type(type = "postgres_enum")
    private GenderTypes gender;
    private LocalDate dateOfBirth;
    private String kids;

    public String getSecondName() {
        return secondName;
    }

    public void setSecondName(String secondName) {
        this.secondName = secondName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getKids() {
        return kids;
    }

    public void setKids(String kids) {
        this.kids = kids;
    }

    public Persons() {
    }

    public Persons(Long id, String firstname, GenderTypes gender, LocalDate dob) {
        this.id = id;
        this.firstName = firstname;
        this.gender = gender;
        this.dateOfBirth = dob;
    }

    public Persons(String firstname, GenderTypes gender, LocalDate dob) {
        this.firstName = firstname;
        this.gender = gender;
        this.dateOfBirth = dob;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstname) {
        this.firstName = firstname;
    }

    public GenderTypes getGender() {
        return gender;
    }

    public void setGender(GenderTypes gender) {
        this.gender = gender;
    }

    public LocalDate getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(LocalDate dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }


    @Override
    public String toString() {
        return "Persons{" +
                "id=" + id +
                ", firstName='" + firstName + '\'' +
                ", secondName='" + secondName + '\'' +
                ", lastName='" + lastName + '\'' +
                ", gender=" + gender +
                ", dateOfBirth=" + dateOfBirth +
                ", kids='" + kids + '\'' +
                '}';
    }
}
