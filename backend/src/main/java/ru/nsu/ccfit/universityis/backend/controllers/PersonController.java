package ru.nsu.ccfit.universityis.backend.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import ru.nsu.ccfit.universityis.backend.entities.Person;
import ru.nsu.ccfit.universityis.backend.services.PersonService;
import ru.nsu.ccfit.universityis.backend.types.GenderTypes;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping(path = "api/v1/persons")
public class PersonController {

    private final PersonService service;

    @Autowired
    public PersonController(PersonService service) {
        this.service = service;
    }

    @GetMapping
    public List<Person> getAll() {
        return service.getAll();
    }

    @PostMapping
    public void addPerson(@RequestBody Person person) {
        service.addPerson(person);
    }

    @DeleteMapping(path = "{personId}")
    public void deletePerson(@PathVariable("personId") Integer id) {
        service.deletePerson(id);
    }

    @PutMapping(path = "{personId}")
    public void updatePerson(@PathVariable("personId") Integer id,
                             @RequestParam(required = false) String firstName,
                             @RequestParam(required = false) String secondName,
                             @RequestParam(required = false) String lastName,
                             @RequestParam(required = false) GenderTypes gender,
                             @RequestParam(required = false) LocalDate dob,
                             @RequestParam(required = false) String kids) {
        service.updatePerson(id, firstName, secondName, lastName, gender, dob, kids);
    }
}
