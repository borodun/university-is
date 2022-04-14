package ru.nsu.ccfit.universityis.backend.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ru.nsu.ccfit.universityis.backend.entities.Session;

@Repository
public interface SessionRepository extends JpaRepository<Session, Integer> {
}
