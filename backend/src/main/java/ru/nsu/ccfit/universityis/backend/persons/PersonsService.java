package ru.nsu.ccfit.universityis.backend.persons;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.universityis.backend.types.GenderTypes;

import javax.transaction.Transactional;
import java.time.LocalDate;
import java.util.List;
import java.util.Objects;

@Service
public class PersonsService {

    private final PersonsRepository personsRepository;

    @Autowired
    public PersonsService(PersonsRepository personsRepository) {
        this.personsRepository = personsRepository;
    }

    public List<Persons> getPersons() {
        return personsRepository.findAll();
    }

    public void addPerson(Persons person) {
        personsRepository.save(person);
    }

    public void deletePerson(Long id) {
        boolean exists = personsRepository.existsById(id);
        if (!exists) {
            throw new IllegalStateException("no person with id " + id);
        }
        personsRepository.deleteById(id);
    }

    @Transactional
    public void updatePerson(Long id,
                             String firstName,
                             String secondName,
                             String lastName,
                             GenderTypes gender,
                             LocalDate dob,
                             String kids) {
        Persons person = personsRepository.findById(id).orElseThrow(() -> new IllegalStateException("no person with id " + id));

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
