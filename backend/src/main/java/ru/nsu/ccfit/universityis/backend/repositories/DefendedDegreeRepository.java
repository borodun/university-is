package ru.nsu.ccfit.universityis.backend.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ru.nsu.ccfit.universityis.backend.entities.DefendedDegree;

@Repository
public interface DefendedDegreeRepository extends JpaRepository<DefendedDegree, Integer> {
}
