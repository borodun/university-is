package ru.nsu.ccfit.universityis.backend.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.universityis.backend.entities.Person;
import ru.nsu.ccfit.universityis.backend.repositories.PersonRepository;
import ru.nsu.ccfit.universityis.backend.types.GenderTypes;

import javax.transaction.Transactional;
import java.time.LocalDate;
import java.util.List;
import java.util.Objects;

@Service
public class PersonService {

    private final PersonRepository repository;

    @Autowired
    public PersonService(PersonRepository repository) {
        this.repository = repository;
    }

    public List<Person> getAll() {
        return repository.findAll();
    }

    public void addPerson(Person person) {
        repository.save(person);
    }

    public void deletePerson(Integer id) {
        boolean exists = repository.existsById(id);
        if (!exists) {
            throw new IllegalStateException("no person with id " + id);
        }
        repository.deleteById(id);
    }

    @Transactional
    public void updatePerson(Integer id,
                             String firstName,
                             String secondName,
                             String lastName,
                             GenderTypes gender,
                             LocalDate dob,
                             String kids) {
        Person person = repository.findById(id).orElseThrow(() -> new IllegalStateException("no person with id " + id));

        if (firstName != null && firstName.length() > 0 && !Objects.equals(person.getFirstName(), firstName)) {
            person.setFirstName(firstName);
        }

        if (secondName != null && secondName.length() > 0 && !Objects.equals(person.getSecondName(), secondName)) {
            person.setSecondName(secondName);
        }

        if (lastName != null && lastName.length() > 0 && !Objects.equals(person.getLastName(), lastName)) {
            person.setLastName(lastName);
        }

        if (gender != null && !Objects.equals(person.getGender(), gender)) {
            person.setGender(gender);
        }

        if (dob != null && dob.isBefore(LocalDate.now()) && !Objects.equals(person.getDateOfBirth(), dob)) {
            person.setDateOfBirth(dob);
        }

        if (kids != null && kids.length() > 0 && !Objects.equals(person.getKids(), kids)) {
            person.setKids(kids);
        }
    }
}
