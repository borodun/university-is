package ru.nsu.ccfit.universityis.backend.entities;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;

@Getter
@Setter
@Entity
@Table(name = "groups")
public class Group {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "group_number", nullable = false)
    private Integer groupNumber;

    @Column(name = "monitor")
    private Integer monitorId;

    @Column(name = "course_id", nullable = false)
    private Integer courseId;
}