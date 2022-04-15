package ru.nsu.ccfit.universityis.backend.entities;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Type;
import ru.nsu.ccfit.universityis.backend.types.ArticleTypes;

import javax.persistence.*;
import java.time.LocalDate;

@Getter
@Setter
@Entity
@Table(name = "defended_degrees")
public class DefendedDegree {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Basic(fetch = FetchType.LAZY)
    @Column(name = "person_id", nullable = false)
    private Integer personId;

    @Column(name = "defend_date", nullable = false)
    private LocalDate defendDate;

    @Enumerated(EnumType.STRING)
    @Type(type = "postgresEnum")
    @Column(name = "article_type")
    private ArticleTypes articleType;

    @Column(name = "article_title", nullable = false)
    private String articleTitle;
}