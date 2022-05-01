--
-- Utility functions
--

--
-- Find max element in any array
--

CREATE OR REPLACE FUNCTION array_max(anyarray)
    RETURNS anyelement
    LANGUAGE SQL
AS
$$
SELECT max(elements)
FROM unnest($1) elements
$$;

--
-- Find min element in any array
--

CREATE OR REPLACE FUNCTION array_min(anyarray)
    RETURNS anyelement
    LANGUAGE SQL
AS
$$
SELECT min(elements)
FROM unnest($1) elements
$$;

--
-- Get person full name as string
--

CREATE OR REPLACE FUNCTION person_name(personId INTEGER)
    RETURNS TEXT
    LANGUAGE SQL
AS
$$
SELECT concat_ws(' ', second_name, first_name, coalesce(last_name, ''))
FROM persons
WHERE id = personId
$$;

--
-- QUERY 1
--
-- Получить перечень и общее число студентов указанных групп либо указанного курса
-- (курсов) факультета полностью,  по половому признаку, году рождения, возрасту,
-- признаку наличия детей, по признаку получения и размеру стипендии.
--

DROP FUNCTION find_students;
CREATE OR REPLACE FUNCTION find_students(
    groupList INTEGER[],
    courseList INTEGER[],
    facultyList VARCHAR[],
    genderList gender_types[],
    yearList INTEGER[],
    ageList INTEGER[],
    kidsCheck INTEGER,
    scholarshipCheck INTEGER,
    scholarshipInterval INTEGER[])
    RETURNS TABLE
            (
                id            INTEGER,
                recordBookNum INTEGER,
                secondName    VARCHAR,
                firstName     VARCHAR,
                lastName      VARCHAR,
                dateOfBirth   DATE,
                age           INTEGER,
                groupNumber   INTEGER,
                courseNumber  INTEGER,
                facultyName   VARCHAR,
                kids          VARCHAR,
                scholarship   INTEGER
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT p.id,
               s.record_book_num,
               p.second_name,
               p.first_name,
               p.last_name,
               p.date_of_birth,
               extract(year from age(p.date_of_birth))::INTEGER AS age,
               g.group_number,
               c.course_number,
               f.faculty_name,
               p.kids,
               s.scholarship
        FROM students s
                 INNER JOIN groups g ON s.group_id = g.id
                 INNER JOIN courses c ON c.id = g.course_id
                 INNER JOIN faculties f ON f.id = c.faculty_id
                 INNER JOIN persons p ON p.id = s.id
        WHERE ((cardinality(groupList) != 0 AND g.group_number = ANY (groupList)) OR cardinality(groupList) = 0)
          AND ((cardinality(courseList) != 0 AND c.course_number = ANY (courseList)) OR cardinality(courseList) = 0)
          AND ((cardinality(facultyList) != 0 AND f.faculty_name = ANY (facultyList)) OR cardinality(facultyList) = 0)
          AND ((cardinality(genderList) != 0 AND p.gender = ANY (genderList)) OR cardinality(genderList) = 0)
          AND ((cardinality(yearList) != 0 AND
                extract(year from p.date_of_birth) BETWEEN array_min(yearList) AND array_max(yearList)) OR
               cardinality(yearList) = 0)
          AND ((cardinality(ageList) != 0 AND
                extract(year from age(p.date_of_birth)) BETWEEN array_min(ageList) AND array_max(ageList)) OR
               cardinality(ageList) = 0)
          AND ((kidsCheck != -1 AND
                (kidsCheck = 1 AND p.kids IS NOT NULL OR kidsCheck = 0 AND p.kids IS NULL)) OR kidsCheck = -1)
          AND ((scholarshipCheck != -1 AND
                (scholarshipCheck = 1 AND s.scholarship IS NOT NULL OR
                 scholarshipCheck = 0 AND s.scholarship IS NULL)) OR scholarshipCheck = -1)
          AND ((cardinality(scholarshipInterval) != 0 AND scholarshipCheck = 1 AND
                s.scholarship BETWEEN array_min(scholarshipInterval) AND array_max(scholarshipInterval)
            OR scholarshipCheck != 1) OR cardinality(scholarshipInterval) = 0)
        ORDER BY p.id;
END;
$$ LANGUAGE plpgsql;

SELECT *
FROM find_students('{}',
                   '{}',
                   '{}',
                   '{}',
                   '{}',
                   '{}',
                   -1,
                   -1,
                   '{}');

--
-- QUERY 2
--
-- Получить список и общее число преподавателей указанных кафедр либо указанного факультета полностью
-- либо указанных категорий (ассистенты, доценты, профессора и т.д.) по половому признаку, году рождения,
-- возрасту, признаку наличия и количеству детей, размеру заработной платы, являющихся аспирантами,
-- защитивших кандидатские, докторские диссертации в указанный период.
--

DROP FUNCTION find_teachers;
CREATE OR REPLACE FUNCTION find_teachers(
    departmentList VARCHAR[],
    facultyList VARCHAR[],
    positionList position_types[],
    genderList gender_types[],
    yearList INTEGER[],
    ageList INTEGER[],
    kidsCount INTEGER,
    salaryInterval INTEGER[],
    degreeList academic_degrees[],
    articleList article_types[],
    articleDateInterval DATE[])
    RETURNS TABLE
            (
                id               INTEGER,
                secondName       VARCHAR,
                firstName        VARCHAR,
                lastName         VARCHAR,
                dateOfBirth      DATE,
                age              INTEGER,
                departmentName   VARCHAR,
                facultyName      VARCHAR,
                positionType     position_types,
                kids             VARCHAR,
                salary           INTEGER,
                degree           academic_degrees,
                defendedArticles TEXT
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT p.id,
               p.second_name,
               p.first_name,
               p.last_name,
               p.date_of_birth,
               extract(year from age(p.date_of_birth))::INTEGER  AS age,
               d.department_name,
               f.faculty_name,
               t.position_type,
               p.kids,
               t.salary,
               t.degree,
               array_to_string(array_agg(dd.article_title), ',') AS defended_articles
        FROM teachers t
                 INNER JOIN departments d ON d.id = t.department_id
                 INNER JOIN faculties f ON f.id = d.faculty_id
                 INNER JOIN persons p ON p.id = t.id
                 INNER JOIN defended_degrees dd ON p.id = dd.person_id
        WHERE ((cardinality(departmentList) != 0 AND d.department_name = ANY (departmentList)) OR
               cardinality(departmentList) = 0)
          AND ((cardinality(facultyList) != 0 AND f.faculty_name = ANY (facultyList)) OR cardinality(facultyList) = 0)
          AND ((cardinality(positionList) != 0 AND t.position_type = ANY (positionList)) OR
               cardinality(positionList) = 0)
          AND ((cardinality(genderList) != 0 AND p.gender = ANY (genderList)) OR cardinality(genderList) = 0)
          AND ((cardinality(yearList) != 0 AND
                extract(year from p.date_of_birth) BETWEEN array_min(yearList) AND array_max(yearList)) OR
               cardinality(yearList) = 0)
          AND ((cardinality(ageList) != 0 AND
                extract(year from age(p.date_of_birth)) BETWEEN array_min(ageList) AND array_max(ageList)) OR
               cardinality(ageList) = 0)
          AND ((kidsCount != -1 AND
                (p.kids = kidsCount::VARCHAR OR kidsCount = 0 AND p.kids IS NULL)) OR kidsCount = -1)
          AND ((cardinality(salaryInterval) != 0 AND
                t.salary BETWEEN array_min(salaryInterval) AND array_max(salaryInterval)) OR
               cardinality(salaryInterval) = 0)
          AND ((cardinality(degreeList) != 0 AND t.degree = ANY (degreeList)) OR cardinality(degreeList) = 0)
          AND ((cardinality(articleList) != 0 AND dd.article_type = ANY (articleList)) OR cardinality(articleList) = 0)
          AND ((cardinality(articleDateInterval) != 0 AND
                dd.defend_date BETWEEN array_min(articleDateInterval) AND array_max(articleDateInterval)) OR
               cardinality(articleDateInterval) = 0)
        GROUP BY p.id, department_name, f.faculty_name, t.position_type, t.salary, t.degree
        ORDER BY p.id;
END;
$$ LANGUAGE plpgsql;

SELECT *
FROM find_teachers('{}',
                   '{}',
                   '{}',
                   '{}',
                   '{}',
                   '{}',
                   -1,
                   '{}',
                   '{}',
                   '{}',
                   '{}');

--
-- QUERY 3
--
-- Получить перечень и общее число тем кандидатских и докторских диссертаций,
-- защитивших сотрудниками указанной кафедры либо указанного факультета.
--

DROP FUNCTION find_teacher_articles;
CREATE OR REPLACE FUNCTION find_teacher_articles(
    departmentList VARCHAR[],
    facultyList VARCHAR[],
    articleList article_types[],
    articleDateInterval DATE[])
    RETURNS TABLE
            (
                id             INTEGER,
                teacherId      INTEGER,
                secondName     VARCHAR,
                firstName      VARCHAR,
                lastName       VARCHAR,
                departmentName VARCHAR,
                facultyName    VARCHAR,
                articleTitle   VARCHAR,
                articleType    article_types,
                defendDate     DATE
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT row_number() over (ORDER BY p.id)::INTEGER,
               p.id,
               p.second_name,
               p.first_name,
               p.last_name,
               d.department_name,
               f.faculty_name,
               dd.article_title,
               dd.article_type,
               dd.defend_date
        FROM teachers t
                 INNER JOIN departments d ON d.id = t.department_id
                 INNER JOIN faculties f ON f.id = d.faculty_id
                 INNER JOIN persons p ON p.id = t.id
                 INNER JOIN defended_degrees dd ON p.id = dd.person_id
        WHERE ((cardinality(departmentList) != 0 AND d.department_name = ANY (departmentList)) OR
               cardinality(departmentList) = 0)
          AND ((cardinality(facultyList) != 0 AND f.faculty_name = ANY (facultyList)) OR cardinality(facultyList) = 0)
          AND ((cardinality(articleList) != 0 AND dd.article_type = ANY (articleList)) OR cardinality(articleList) = 0)
          AND ((cardinality(articleDateInterval) != 0 AND
                dd.defend_date BETWEEN array_min(articleDateInterval) AND array_max(articleDateInterval)) OR
               cardinality(articleDateInterval) = 0)
        ORDER BY p.id;
END;
$$ LANGUAGE plpgsql;


SELECT *
FROM find_teacher_articles('{}',
                           '{}',
                           '{}',
                           '{}');

--
-- QUERY 4
--
--
-- Получить перечень кафедр, проводящих занятия в указанной группе
-- либо на указанном курсе указанного факультета в указанном семестре, либо за указанный период.
--

DROP FUNCTION find_departments;
CREATE OR REPLACE FUNCTION find_departments(
    groupList INTEGER[],
    courseList INTEGER[],
    departmentList VARCHAR[],
    facultyList VARCHAR[],
    yearInterval INTEGER[],
    semesterList INTEGER[])
    RETURNS TABLE
            (
                id             INTEGER,
                departmentId   INTEGER,
                departmentName VARCHAR,
                facultyName    VARCHAR,
                groupNumber    INTEGER,
                courseNumber   INTEGER,
                year           INTEGER,
                semester       INTEGER
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT row_number() over (ORDER BY d.id)::INTEGER,
               d.id,
               d.department_name,
               f.faculty_name,
               g.group_number,
               cour.course_number,
               curr.year,
               curr.semester
        FROM departments d
                 INNER JOIN faculties f ON f.id = d.faculty_id
                 INNER JOIN study_assignments sa ON d.id = sa.department_id
                 INNER JOIN classes c ON sa.disciple_id = c.disciple_id
                 INNER JOIN groups g ON g.id = c.group_id
                 INNER JOIN courses cour ON cour.id = g.course_id
                 INNER JOIN curriculum curr ON c.disciple_id = curr.disciple_id
        WHERE ((cardinality(groupList) != 0 AND g.group_number = ANY (groupList)) OR cardinality(groupList) = 0)
          AND ((cardinality(courseList) != 0 AND cour.course_number = ANY (courseList)) OR cardinality(courseList) = 0)
          AND ((cardinality(departmentList) != 0 AND d.department_name = ANY (departmentList)) OR
               cardinality(departmentList) = 0)
          AND ((cardinality(facultyList) != 0 AND f.faculty_name = ANY (facultyList)) OR cardinality(facultyList) = 0)
          AND ((cardinality(yearInterval) != 0 AND
                curr.year BETWEEN array_min(yearInterval) AND array_max(yearInterval)) OR
               cardinality(yearInterval) = 0)
          AND ((cardinality(semesterList) != 0 AND
                curr.semester BETWEEN array_min(semesterList) AND array_max(semesterList)) OR
               cardinality(semesterList) = 0)
        GROUP BY d.id, f.faculty_name, g.group_number, cour.course_number, curr.year, curr.semester
        ORDER BY d.id;
END;
$$ LANGUAGE plpgsql;

SELECT *
FROM find_departments('{}',
                      '{}',
                      '{}',
                      '{}',
                      '{}',
                      '{}');

--
-- QUERY 5
--
-- Получить список и общее число преподавателей, проводивших (проводящих) занятия
-- по указанной дисциплине в указанной группе либо на указанном курсе указанного факультета.
--

DROP FUNCTION find_teacher_groups;
CREATE OR REPLACE FUNCTION find_teacher_groups(
    discipleList VARCHAR[],
    groupList INTEGER[],
    courseList INTEGER[],
    departmentList VARCHAR[],
    facultyList VARCHAR[])
    RETURNS TABLE
            (
                id             INTEGER,
                teacherId      INTEGER,
                secondName     VARCHAR,
                firstName      VARCHAR,
                lastName       VARCHAR,
                departmentName VARCHAR,
                facultyName    VARCHAR,
                groupNumber    INTEGER,
                courseNumber   INTEGER,
                disciple       VARCHAR
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT row_number() over (ORDER BY p.id)::INTEGER,
               p.id,
               p.second_name,
               p.first_name,
               p.last_name,
               d.department_name,
               f.faculty_name,
               g.group_number,
               cour.course_number,
               disc.disciple_name
        FROM departments d
                 INNER JOIN study_assignments sa ON d.id = sa.department_id
                 INNER JOIN disciples disc ON disc.id = sa.disciple_id
                 INNER JOIN classes c ON disc.id = c.disciple_id
                 INNER JOIN teachers t ON c.teacher_id = t.id
                 INNER JOIN faculties f ON f.id = d.faculty_id
                 INNER JOIN groups g ON g.id = c.group_id
                 INNER JOIN courses cour ON cour.id = g.course_id
                 INNER JOIN persons p ON p.id = t.id
        WHERE ((cardinality(groupList) != 0 AND g.group_number = ANY (groupList)) OR cardinality(groupList) = 0)
          AND ((cardinality(courseList) != 0 AND cour.course_number = ANY (courseList)) OR cardinality(courseList) = 0)
          AND ((cardinality(departmentList) != 0 AND d.department_name = ANY (departmentList)) OR
               cardinality(departmentList) = 0)
          AND ((cardinality(facultyList) != 0 AND f.faculty_name = ANY (facultyList)) OR cardinality(facultyList) = 0)
          AND ((cardinality(discipleList) != 0 AND disc.disciple_name = ANY (discipleList)) OR
               cardinality(discipleList) = 0)
        GROUP BY p.id, p.second_name, p.first_name, p.last_name, d.department_name, f.faculty_name, g.group_number,
                 cour.course_number, disc.disciple_name
        ORDER BY p.id;
END;
$$ LANGUAGE plpgsql;

SELECT *
FROM find_teacher_groups('{}',
                         '{}',
                         '{}',
                         '{}',
                         '{}');

--
-- QUERY 6
--
-- Получить перечень и общее число преподавателей проводивших (проводящих) лекционные, семинарские
-- и другие виды занятий в указанной группе либо на указанном курсе указанного факультета в указанном семестре,
-- либо за указанный период.
--

DROP FUNCTION find_teacher_classes;
CREATE OR REPLACE FUNCTION find_teacher_classes(
    classTypes class_types[],
    groupList INTEGER[],
    courseList INTEGER[],
    departmentList VARCHAR[],
    facultyList VARCHAR[],
    yearList INTEGER[],
    semesterList INTEGER[])
    RETURNS TABLE
            (
                id             INTEGER,
                teacherId      INTEGER,
                secondName     VARCHAR,
                firstName      VARCHAR,
                lastName       VARCHAR,
                departmentName VARCHAR,
                facultyName    VARCHAR,
                groupNumber    INTEGER,
                courseNumber   INTEGER,
                disciple       VARCHAR,
                classType      class_types,
                year           INTEGER,
                semester       INTEGER
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT row_number() over (ORDER BY p.id)::INTEGER,
               p.id,
               p.second_name,
               p.first_name,
               p.last_name,
               d.department_name,
               f.faculty_name,
               g.group_number,
               cour.course_number,
               disc.disciple_name,
               c.class_type,
               curr.year,
               curr.semester
        FROM departments d
                 INNER JOIN study_assignments sa ON d.id = sa.department_id
                 INNER JOIN disciples disc ON disc.id = sa.disciple_id
                 INNER JOIN classes c ON disc.id = c.disciple_id
                 INNER JOIN curriculum curr ON disc.id = curr.disciple_id
                 INNER JOIN teachers t ON c.teacher_id = t.id
                 INNER JOIN faculties f ON f.id = d.faculty_id
                 INNER JOIN groups g ON g.id = c.group_id
                 INNER JOIN courses cour ON cour.id = g.course_id
                 INNER JOIN persons p ON p.id = t.id
        WHERE ((cardinality(groupList) != 0 AND g.group_number = ANY (groupList)) OR cardinality(groupList) = 0)
          AND ((cardinality(courseList) != 0 AND cour.course_number = ANY (courseList)) OR cardinality(courseList) = 0)
          AND ((cardinality(departmentList) != 0 AND d.department_name = ANY (departmentList)) OR
               cardinality(departmentList) = 0)
          AND ((cardinality(facultyList) != 0 AND f.faculty_name = ANY (facultyList)) OR cardinality(facultyList) = 0)
          AND ((cardinality(classTypes) != 0 AND c.class_type = ANY (classTypes)) OR cardinality(classTypes) = 0)
          AND ((cardinality(yearList) != 0 AND curr.year = ANY (yearList)) OR cardinality(yearList) = 0)
          AND ((cardinality(semesterList) != 0 AND curr.semester = ANY (semesterList)) OR cardinality(semesterList) = 0)
        GROUP BY p.id, p.second_name, p.first_name, p.last_name, d.department_name, f.faculty_name, g.group_number,
                 cour.course_number, disc.disciple_name, c.class_type, curr.year, curr.semester
        ORDER BY p.id;
END;
$$ LANGUAGE plpgsql;

SELECT *
FROM find_teacher_classes('{}',
                          '{}',
                          '{}',
                          '{}',
                          '{}',
                          '{}',
                          '{}');

--
-- QUERY 7
--
-- Получить список и общее число студентов указанных групп,
-- сдавших зачет либо экзамен по указанной дисциплине с указанной оценкой.
--

DROP FUNCTION find_student_exams;
CREATE OR REPLACE FUNCTION find_student_exams(
    groupList INTEGER[],
    examTypes exam_types[],
    discipleList VARCHAR[],
    markList mark_types[])
    RETURNS TABLE
            (
                id            INTEGER,
                recordBookNum INTEGER,
                secondName    VARCHAR,
                firstName     VARCHAR,
                lastName      VARCHAR,
                groupNumber   INTEGER,
                courseNumber  INTEGER,
                facultyName   VARCHAR,
                discipleName  VARCHAR,
                examType      exam_types,
                mark          TEXT
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT p.id,
               s.record_book_num,
               p.second_name,
               p.first_name,
               p.last_name,
               g.group_number,
               c.course_number,
               f.faculty_name,
               d.disciple_name,
               ea.exam_type,
               pass.mark::TEXT || coalesce(' (' || mark_num || ')', '') AS mark
        FROM students s
                 INNER JOIN groups g ON s.group_id = g.id
                 INNER JOIN courses c ON c.id = g.course_id
                 INNER JOIN faculties f ON f.id = c.faculty_id
                 INNER JOIN persons p ON p.id = s.id
                 INNER JOIN passes pass ON s.id = pass.student_id
                 INNER JOIN exams e ON e.id = pass.exam_id
                 INNER JOIN disciples d ON d.id = e.disciple_id
                 INNER JOIN exam_assignments ea on d.id = ea.disciple_id
        WHERE ((cardinality(groupList) != 0 AND g.group_number = ANY (groupList)) OR cardinality(groupList) = 0)
          AND ((cardinality(discipleList) != 0 AND d.disciple_name = ANY (discipleList)) OR
               cardinality(discipleList) = 0)
          AND ((cardinality(markList) != 0 AND pass.mark = ANY (markList)) OR cardinality(markList) = 0)
          AND ((cardinality(examTypes) != 0 AND ea.exam_type = ANY (examTypes)) OR cardinality(examTypes) = 0)
        ORDER BY p.id;
END;
$$ LANGUAGE plpgsql;

SELECT *
FROM find_student_exams('{}',
                        '{}',
                        '{}',
                        '{}');

--
-- QUERY 8
--
-- Получить список и общее число студентов указанных групп или указанного курса
-- указанного факультета, сдавших указанную сессию на отлично, без троек, без двоек.
--

DROP FUNCTION find_student_sessions;
CREATE OR REPLACE FUNCTION find_student_sessions(
    groupList INTEGER[],
    courseList INTEGER[],
    facultyList VARCHAR[],
    sessionList VARCHAR[],
    markList mark_types[])
    RETURNS TABLE
            (
                id            INTEGER,
                recordBookNum INTEGER,
                secondName    VARCHAR,
                firstName     VARCHAR,
                lastName      VARCHAR,
                groupNumber   INTEGER,
                courseNumber  INTEGER,
                facultyName   VARCHAR,
                discipleName  VARCHAR,
                mark          TEXT
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT p.id,
               s.record_book_num,
               p.second_name,
               p.first_name,
               p.last_name,
               g.group_number,
               c.course_number,
               f.faculty_name,
               d.disciple_name,
               pass.mark::TEXT || coalesce(' (' || mark_num || ')', '') AS mark
        FROM students s
                 INNER JOIN groups g ON s.group_id = g.id
                 INNER JOIN courses c ON c.id = g.course_id
                 INNER JOIN faculties f ON f.id = c.faculty_id
                 INNER JOIN persons p ON p.id = s.id
                 INNER JOIN passes pass ON s.id = pass.student_id
                 INNER JOIN exams e ON e.id = pass.exam_id
                 INNER JOIN disciples d ON d.id = e.disciple_id
                 INNER JOIN sessions sess ON sess.id = e.session_id
        WHERE ((cardinality(groupList) != 0 AND g.group_number = ANY (groupList)) OR cardinality(groupList) = 0)
          AND ((cardinality(markList) != 0 AND pass.mark = ANY (markList)) OR cardinality(markList) = 0)
          AND ((cardinality(courseList) != 0 AND c.course_number = ANY (courseList)) OR cardinality(courseList) = 0)
          AND ((cardinality(facultyList) != 0 AND f.faculty_name = ANY (facultyList)) OR cardinality(facultyList) = 0)
          AND ((cardinality(sessionList) != 0 AND sess.name = ANY (sessionList)) OR cardinality(sessionList) = 0)
        ORDER BY p.id;
END;
$$ LANGUAGE plpgsql;

SELECT *
FROM find_student_sessions('{}',
                           '{}',
                           '{}',
                           '{}',
                           '{}');

--
-- QUERY 9
--
-- Получить перечень преподавателей, принимающих (принимавших) экзамены
-- в указанных группах, по указанным дисциплинам, в указанном семестре.
--

DROP FUNCTION find_teacher_exams;
CREATE OR REPLACE FUNCTION find_teacher_exams(
    groupList INTEGER[],
    discipleList VARCHAR[],
    semesterList INTEGER[])
    RETURNS TABLE
            (
                id             INTEGER,
                teacherId      INTEGER,
                secondName     VARCHAR,
                firstName      VARCHAR,
                lastName       VARCHAR,
                departmentName VARCHAR,
                facultyName    VARCHAR,
                groupNumbers   TEXT,
                courseNumber   INTEGER,
                disciple       VARCHAR,
                examType       exam_types,
                year           INTEGER,
                semester       INTEGER
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT row_number() over (ORDER BY p.id)::INTEGER,
               p.id,
               p.second_name,
               p.first_name,
               p.last_name,
               dep.department_name,
               f.faculty_name,
               array_to_string(array_agg(DISTINCT g.group_number), ',') AS group_numbers,
               cour.course_number,
               d.disciple_name,
               ea.exam_type,
               c.year,
               c.semester
        FROM teachers t
                 INNER JOIN teacher_exams te ON t.id = te.teacher_id
                 INNER JOIN exams e ON e.id = te.exam_id
                 INNER JOIN disciples d ON d.id = e.disciple_id
                 INNER JOIN curriculum c ON d.id = c.disciple_id
                 INNER JOIN courses cour ON cour.id = c.course_id
                 INNER JOIN groups g ON cour.id = g.course_id
                 INNER JOIN departments dep ON dep.id = t.department_id
                 INNER JOIN faculties f ON f.id = dep.faculty_id
                 INNER JOIN persons p ON p.id = t.id
                 INNER JOIN exam_assignments ea ON d.id = ea.disciple_id
        WHERE ((cardinality(groupList) != 0 AND g.group_number = ANY (groupList)) OR cardinality(groupList) = 0)
          AND ((cardinality(discipleList) != 0 AND d.disciple_name = ANY (discipleList)) OR
               cardinality(discipleList) = 0)
          AND ((cardinality(semesterList) != 0 AND c.semester = ANY (semesterList)) OR cardinality(semesterList) = 0)
        GROUP BY p.id, p.second_name, p.first_name, p.last_name, dep.department_name, f.faculty_name, g.group_number,
                 cour.course_number, d.disciple_name, ea.exam_type, c.year, c.semester
        ORDER BY p.id;
END;
$$ LANGUAGE plpgsql;

SELECT *
FROM find_teacher_exams('{}',
                        '{}',
                        '{}');

--
-- QUERY 10
--
-- Получить список студентов указанных групп, либо которым заданный преподаватель поставил
-- некоторую оценку за экзамен по определенным дисциплинам, в указанных семестрах, за некоторый период.
--

DROP FUNCTION find_student_marks;
CREATE OR REPLACE FUNCTION find_student_marks(
    groupList INTEGER[],
    courseList INTEGER[],
    facultyList VARCHAR[],
    teacherList INTEGER[],
    markList mark_types[],
    discipleList VARCHAR[],
    semesterList INTEGER[],
    dateInterval DATE[])
    RETURNS TABLE
            (
                id            INTEGER,
                recordBookNum INTEGER,
                secondName    VARCHAR,
                firstName     VARCHAR,
                lastName      VARCHAR,
                groupNumber   INTEGER,
                courseNumber  INTEGER,
                facultyName   VARCHAR,
                discipleName  VARCHAR,
                mark          TEXT,
                teacherName   TEXT,
                examDate      DATE,
                semester      INTEGER
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT p.id,
               s.record_book_num,
               p.second_name,
               p.first_name,
               p.last_name,
               g.group_number,
               c.course_number,
               f.faculty_name,
               d.disciple_name,
               pass.mark::TEXT || coalesce(' (' || mark_num || ')', '') AS mark,
               person_name(t.id),
               e.date,
               curr.semester
        FROM students s
                 INNER JOIN groups g ON s.group_id = g.id
                 INNER JOIN courses c ON c.id = g.course_id
                 INNER JOIN faculties f ON f.id = c.faculty_id
                 INNER JOIN persons p ON p.id = s.id
                 INNER JOIN passes pass ON s.id = pass.student_id
                 INNER JOIN exams e ON e.id = pass.exam_id
                 INNER JOIN disciples d ON d.id = e.disciple_id
                 INNER JOIN sessions sess ON sess.id = e.session_id
                 INNER JOIN teachers t ON t.id = pass.teacher_id
                 INNER JOIN curriculum curr ON c.id = curr.course_id
        WHERE ((cardinality(groupList) != 0 AND g.group_number = ANY (groupList)) OR cardinality(groupList) = 0)
          AND ((cardinality(markList) != 0 AND pass.mark = ANY (markList)) OR cardinality(markList) = 0)
          AND ((cardinality(courseList) != 0 AND c.course_number = ANY (courseList)) OR cardinality(courseList) = 0)
          AND ((cardinality(facultyList) != 0 AND f.faculty_name = ANY (facultyList)) OR cardinality(facultyList) = 0)
          AND ((cardinality(teacherList) != 0 AND t.id = ANY (teacherList)) OR cardinality(teacherList) = 0)
          AND ((cardinality(discipleList) != 0 AND d.disciple_name = ANY (discipleList)) OR
               cardinality(discipleList) = 0)
          AND ((cardinality(semesterList) != 0 AND curr.semester = ANY (semesterList)) OR cardinality(semesterList) = 0)
          AND ((cardinality(dateInterval) != 0 AND
                e.date BETWEEN array_min(dateInterval) AND array_max(dateInterval)) OR
               cardinality(dateInterval) = 0)
        GROUP BY p.id, s.record_book_num, p.second_name, p.first_name, p.last_name, g.group_number, c.course_number,
                 f.faculty_name, d.disciple_name, pass.mark::TEXT || coalesce(' (' || mark_num || ')', ''),
                 person_name(t.id), e.date, curr.semester
        ORDER BY p.id;
END;
$$ LANGUAGE plpgsql;

SELECT *
FROM find_student_marks('{}',
                        '{}',
                        '{}',
                        '{}',
                        '{}',
                        '{}',
                        '{}',
                        '{}');

--
-- QUERY 11
--
-- Получить список студентов и тем дипломных работ, выполняемых ими на
-- указанной кафедре либо у указанного преподавателя.
--

DROP FUNCTION find_student_diplomas;
CREATE OR REPLACE FUNCTION find_student_diplomas(
    departmentList VARCHAR[],
    teacherList INTEGER[])
    RETURNS TABLE
            (
                id                 INTEGER,
                recordBookNum      INTEGER,
                secondName         VARCHAR,
                firstName          VARCHAR,
                lastName           VARCHAR,
                groupNumber        INTEGER,
                courseNumber       INTEGER,
                facultyName        VARCHAR,
                diplomaTitle       VARCHAR,
                scientificDirector TEXT
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT p.id,
               s.record_book_num,
               p.second_name,
               p.first_name,
               p.last_name,
               g.group_number,
               c.course_number,
               f.faculty_name,
               s.diploma_title,
               person_name(s.scientific_director)
        FROM students s
                 INNER JOIN teachers t ON t.id = s.scientific_director
                 INNER JOIN departments d ON d.id = t.department_id
                 INNER JOIN persons p ON p.id = s.id
                 INNER JOIN groups g ON g.id = s.group_id
                 INNER JOIN courses c ON c.id = g.course_id
                 INNER JOIN faculties f ON f.id = d.faculty_id
        WHERE ((cardinality(departmentList) != 0 AND d.department_name = ANY (departmentList)) OR
               cardinality(departmentList) = 0)
          AND ((cardinality(teacherList) != 0 AND t.id = ANY (teacherList)) OR cardinality(teacherList) = 0)
        ORDER BY p.id;
END;
$$ LANGUAGE plpgsql;

SELECT *
FROM find_student_diplomas('{}',
                           '{}');

--
-- QUERY 12
--
-- Получить список руководителей дипломных работ с указанной кафедры,
-- либо факультета полностью и раздельно по некоторым категориям преподавателей.
--

DROP FUNCTION find_teacher_diplomas;
CREATE OR REPLACE FUNCTION find_teacher_diplomas(
    departmentList VARCHAR[],
    facultyList VARCHAR[],
    positionList position_types[])
    RETURNS TABLE
            (
                id             INTEGER,
                teacherId      INTEGER,
                secondName     VARCHAR,
                firstName      VARCHAR,
                lastName       VARCHAR,
                departmentName VARCHAR,
                facultyName    VARCHAR,
                positionType   position_types,
                diplomaTitles  VARCHAR,
                studentName    TEXT
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT row_number() over (ORDER BY p.id)::INTEGER,
               p.id,
               p.second_name,
               p.first_name,
               p.last_name,
               d.department_name,
               f.faculty_name,
               t.position_type,
               s.diploma_title,
               person_name(s.id)
        FROM teachers t
                 INNER JOIN students s ON t.id = s.scientific_director
                 INNER JOIN departments d ON d.id = t.department_id
                 INNER JOIN faculties f ON f.id = d.faculty_id
                 INNER JOIN persons p ON p.id = t.id
        WHERE ((cardinality(departmentList) != 0 AND d.department_name = ANY (departmentList)) OR
               cardinality(departmentList) = 0)
          AND ((cardinality(facultyList) != 0 AND f.faculty_name = ANY (facultyList)) OR cardinality(facultyList) = 0)
          AND ((cardinality(positionList) != 0 AND t.position_type = ANY (positionList)) OR
               cardinality(positionList) = 0)
        GROUP BY p.id, p.second_name, p.first_name, p.last_name, d.department_name, f.faculty_name, t.position_type,
                 s.diploma_title, person_name(s.id)
        ORDER BY p.id;
END;
$$ LANGUAGE plpgsql;

SELECT *
FROM find_teacher_diplomas('{}',
                           '{}',
                           '{}');

--
-- QUERY 13
--
-- Получить нагрузку преподавателей (название дисциплины, количество часов),
-- ее объем по отдельным видам занятий и общую нагрузку в указанном семестре
-- для конкретного преподавателя либо для преподавателей указанной кафедры.
--

DROP FUNCTION find_teacher_workloads;
CREATE OR REPLACE FUNCTION find_teacher_workloads(
    teacherList INTEGER[],
    departmentList VARCHAR[],
    classTypes class_types[])
    RETURNS TABLE
            (
                id             INTEGER,
                secondName     VARCHAR,
                firstName      VARCHAR,
                lastName       VARCHAR,
                departmentName VARCHAR,
                facultyName    VARCHAR,
                workload       INTEGER
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT p.id,
               p.second_name,
               p.first_name,
               p.last_name,
               d.department_name,
               f.faculty_name,
               sum(c.hours)::INTEGER AS workload
        FROM teachers t
                 INNER JOIN departments d ON d.id = t.department_id
                 INNER JOIN faculties f ON f.id = d.faculty_id
                 INNER JOIN persons p ON p.id = t.id
                 INNER JOIN classes c ON t.id = c.teacher_id
        WHERE ((cardinality(departmentList) != 0 AND d.department_name = ANY (departmentList)) OR
               cardinality(departmentList) = 0)
          AND ((cardinality(teacherList) != 0 AND t.id = ANY (teacherList)) OR cardinality(teacherList) = 0)
          AND ((cardinality(classTypes) != 0 AND c.class_type = ANY (classTypes)) OR cardinality(classTypes) = 0)
        GROUP BY p.id, p.second_name, p.first_name, p.last_name, d.department_name, f.faculty_name
        ORDER BY p.id;
END;
$$ LANGUAGE plpgsql;

SELECT *
FROM find_teacher_workloads('{}',
                            '{}',
                            '{}');
