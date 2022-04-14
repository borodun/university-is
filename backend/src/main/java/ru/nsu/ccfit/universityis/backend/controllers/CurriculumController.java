package ru.nsu.ccfit.universityis.backend.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.nsu.ccfit.universityis.backend.entities.Curriculum;
import ru.nsu.ccfit.universityis.backend.services.CurriculumService;

import java.util.List;

@RestController
@RequestMapping(path = "api/v1/curriculum")
public class CurriculumController {

    private final CurriculumService curriculumService;

    @Autowired
    public CurriculumController(CurriculumService curriculumService) {
        this.curriculumService = curriculumService;
    }

    @GetMapping
    public List<Curriculum> getDisciples() {
        return curriculumService.getCurriculum();
    }
}
