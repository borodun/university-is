package ru.nsu.ccfit.universityis.backend.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ru.nsu.ccfit.universityis.backend.entities.Disciple;

@Repository
public interface DiscipleRepository extends JpaRepository<Disciple, Integer> {
}
