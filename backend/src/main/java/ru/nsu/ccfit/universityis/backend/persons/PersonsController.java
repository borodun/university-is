package ru.nsu.ccfit.universityis.backend.persons;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import ru.nsu.ccfit.universityis.backend.types.GenderTypes;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping(path = "api/v1/persons")
public class PersonsController {

    private final PersonsService personService;

    @Autowired
    public PersonsController(PersonsService personService) {
        this.personService = personService;
    }

    @GetMapping
    public List<Persons> getPersons() {
        return personService.getPersons();
    }

    @PostMapping
    public void addPerson(@RequestBody Persons person) {
        personService.addPerson(person);
    }

    @DeleteMapping(path = "{personId}")
    public void deletePerson(@PathVariable("personId") Long id) {
        personService.deletePerson(id);
    }

    @PutMapping(path = "{personId}")
    public void updatePerson(@PathVariable("personId") Long id,
                             @RequestParam(required = false) String firstName,
                             @RequestParam(required = false) String secondName,
                             @RequestParam(required = false) String lastName,
                             @RequestParam(required = false) GenderTypes gender,
                             @RequestParam(required = false) LocalDate dob,
                             @RequestParam(required = false) String kids) {
        personService.updatePerson(id, firstName, secondName, lastName, gender, dob, kids);
    }
}
