--
-- PostgreSQL database dump
--

-- Dumped from database version 12.9 (Ubuntu 12.9-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 14.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE IF EXISTS university;
--
-- Name: university; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE university WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.UTF-8';


\connect university

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: university; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA university;


--
-- Name: academic_degrees; Type: TYPE; Schema: university; Owner: -
--

CREATE TYPE university.academic_degrees AS ENUM (
    'bachelor',
    'master',
    'candidate',
    'doctorate'
    );


--
-- Name: article_types; Type: TYPE; Schema: university; Owner: -
--

CREATE TYPE university.article_types AS ENUM (
    'diploma',
    'phd',
    'doctoral'
    );


--
-- Name: class_types; Type: TYPE; Schema: university; Owner: -
--

CREATE TYPE university.class_types AS ENUM (
    'lection',
    'seminar',
    'laboratory_work',
    'course_work',
    'consultation'
    );


--
-- Name: course_types; Type: TYPE; Schema: university; Owner: -
--

CREATE TYPE university.course_types AS ENUM (
    'undergraduate',
    'magistracy',
    'postgraduate'
    );


--
-- Name: exam_types; Type: TYPE; Schema: university; Owner: -
--

CREATE TYPE university.exam_types AS ENUM (
    'exam',
    'differential_pass',
    'pass'
    );


--
-- Name: gender_types; Type: TYPE; Schema: university; Owner: -
--

CREATE TYPE university.gender_types AS ENUM (
    'male',
    'female'
    );


--
-- Name: mark_types; Type: TYPE; Schema: university; Owner: -
--

CREATE TYPE university.mark_types AS ENUM (
    'pass',
    'fail',
    'excellent',
    'good',
    'satisfactory',
    'unsatisfactory'
    );


--
-- Name: position_types; Type: TYPE; Schema: university; Owner: -
--

CREATE TYPE university.position_types AS ENUM (
    'assistant',
    'teacher',
    'senior_teacher',
    'associate_professor',
    'professor'
    );


--
-- Name: array_max(anyarray); Type: FUNCTION; Schema: university; Owner: -
--

CREATE FUNCTION university.array_max(anyarray) RETURNS anyelement
    LANGUAGE sql
AS
$_$
SELECT max(elements)
FROM unnest($1) elements
$_$;


--
-- Name: array_min(anyarray); Type: FUNCTION; Schema: university; Owner: -
--

CREATE FUNCTION university.array_min(anyarray) RETURNS anyelement
    LANGUAGE sql
AS
$_$
SELECT min(elements)
FROM unnest($1) elements
$_$;


--
-- Name: find_departments(integer[], integer[], character varying[], character varying[], integer[], integer[]); Type: FUNCTION; Schema: university; Owner: -
--

CREATE FUNCTION university.find_departments(grouplist integer[], courselist integer[],
                                            departmentlist character varying[], facultylist character varying[],
                                            yearinterval integer[], semesterlist integer[])
    RETURNS TABLE
            (
                id             integer,
                departmentid   integer,
                departmentname character varying,
                facultyname    character varying,
                groupnumber    integer,
                coursenumber   integer,
                year           integer,
                semester       integer
            )
    LANGUAGE plpgsql
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
$$;


--
-- Name: find_student_diplomas(character varying[], integer[]); Type: FUNCTION; Schema: university; Owner: -
--

CREATE FUNCTION university.find_student_diplomas(departmentlist character varying[], teacherlist integer[])
    RETURNS TABLE
            (
                id                 integer,
                recordbooknum      integer,
                secondname         character varying,
                firstname          character varying,
                lastname           character varying,
                groupnumber        integer,
                coursenumber       integer,
                facultyname        character varying,
                diplomatitle       character varying,
                scientificdirector text
            )
    LANGUAGE plpgsql
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
                 INNER JOIN teachers t on t.id = s.scientific_director
                 INNER JOIN departments d on d.id = t.department_id
                 INNER JOIN persons p on p.id = s.id
                 INNER JOIN groups g on g.id = s.group_id
                 INNER JOIN courses c on c.id = g.course_id
                 INNER JOIN faculties f on f.id = d.faculty_id
        WHERE ((cardinality(departmentList) != 0 AND d.department_name = ANY (departmentList)) OR
               cardinality(departmentList) = 0)
          AND ((cardinality(teacherList) != 0 AND t.id = ANY (teacherList)) OR cardinality(teacherList) = 0)
        ORDER BY p.id;
END;
$$;


--
-- Name: find_student_exams(integer[], university.exam_types[], character varying[], university.mark_types[]); Type: FUNCTION; Schema: university; Owner: -
--

CREATE FUNCTION university.find_student_exams(grouplist integer[], examtypes university.exam_types[],
                                              disciplelist character varying[], marklist university.mark_types[])
    RETURNS TABLE
            (
                id            integer,
                recordbooknum integer,
                secondname    character varying,
                firstname     character varying,
                lastname      character varying,
                groupnumber   integer,
                coursenumber  integer,
                facultyname   character varying,
                disciplename  character varying,
                examtype      university.exam_types,
                mark          text
            )
    LANGUAGE plpgsql
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
$$;


--
-- Name: find_student_marks(integer[], integer[], character varying[], integer[], university.mark_types[], character varying[], integer[], date[]); Type: FUNCTION; Schema: university; Owner: -
--

CREATE FUNCTION university.find_student_marks(grouplist integer[], courselist integer[],
                                              facultylist character varying[], teacherlist integer[],
                                              marklist university.mark_types[], disciplelist character varying[],
                                              semesterlist integer[], dateinterval date[])
    RETURNS TABLE
            (
                id            integer,
                recordbooknum integer,
                secondname    character varying,
                firstname     character varying,
                lastname      character varying,
                groupnumber   integer,
                coursenumber  integer,
                facultyname   character varying,
                disciplename  character varying,
                mark          text,
                teachername   text,
                examdate      date,
                semester      integer
            )
    LANGUAGE plpgsql
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
$$;


--
-- Name: find_student_sessions(integer[], integer[], character varying[], character varying[], university.mark_types[]); Type: FUNCTION; Schema: university; Owner: -
--

CREATE FUNCTION university.find_student_sessions(grouplist integer[], courselist integer[],
                                                 facultylist character varying[], sessionlist character varying[],
                                                 marklist university.mark_types[])
    RETURNS TABLE
            (
                id            integer,
                recordbooknum integer,
                secondname    character varying,
                firstname     character varying,
                lastname      character varying,
                groupnumber   integer,
                coursenumber  integer,
                facultyname   character varying,
                disciplename  character varying,
                mark          text
            )
    LANGUAGE plpgsql
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
                 INNER JOIN groups g on s.group_id = g.id
                 INNER JOIN courses c on c.id = g.course_id
                 INNER JOIN faculties f on f.id = c.faculty_id
                 INNER JOIN persons p on p.id = s.id
                 INNER JOIN passes pass on s.id = pass.student_id
                 INNER JOIN exams e on e.id = pass.exam_id
                 INNER JOIN disciples d on d.id = e.disciple_id
                 INNER JOIN sessions sess on sess.id = e.session_id
        WHERE ((cardinality(groupList) != 0 AND g.group_number = ANY (groupList)) OR cardinality(groupList) = 0)
          AND ((cardinality(markList) != 0 AND pass.mark = ANY (markList)) OR cardinality(markList) = 0)
          AND ((cardinality(courseList) != 0 AND c.course_number = ANY (courseList)) OR cardinality(courseList) = 0)
          AND ((cardinality(facultyList) != 0 AND f.faculty_name = ANY (facultyList)) OR cardinality(facultyList) = 0)
          AND ((cardinality(sessionList) != 0 AND sess.name = ANY (sessionList)) OR cardinality(sessionList) = 0)
        ORDER BY p.id;
END;
$$;


--
-- Name: find_students(integer[], integer[], character varying[], university.gender_types[], integer[], integer[], integer, integer, integer[]); Type: FUNCTION; Schema: university; Owner: -
--

CREATE FUNCTION university.find_students(grouplist integer[], courselist integer[], facultylist character varying[],
                                         genderlist university.gender_types[], yearlist integer[], agelist integer[],
                                         kidscheck integer, scholarshipcheck integer, scholarshipinterval integer[])
    RETURNS TABLE
            (
                id            integer,
                recordbooknum integer,
                secondname    character varying,
                firstname     character varying,
                lastname      character varying,
                dateofbirth   date,
                age           integer,
                groupnumber   integer,
                coursenumber  integer,
                facultyname   character varying,
                kids          character varying,
                scholarship   integer
            )
    LANGUAGE plpgsql
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
$$;


--
-- Name: find_teacher_articles(character varying[], character varying[], university.article_types[], date[]); Type: FUNCTION; Schema: university; Owner: -
--

CREATE FUNCTION university.find_teacher_articles(departmentlist character varying[], facultylist character varying[],
                                                 articlelist university.article_types[], articledateinterval date[])
    RETURNS TABLE
            (
                id             integer,
                teacherid      integer,
                secondname     character varying,
                firstname      character varying,
                lastname       character varying,
                departmentname character varying,
                facultyname    character varying,
                articletitle   character varying,
                articletype    university.article_types,
                defenddate     date
            )
    LANGUAGE plpgsql
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
$$;


--
-- Name: find_teacher_classes(university.class_types[], integer[], integer[], character varying[], character varying[], integer[], integer[]); Type: FUNCTION; Schema: university; Owner: -
--

CREATE FUNCTION university.find_teacher_classes(classtypes university.class_types[], grouplist integer[],
                                                courselist integer[], departmentlist character varying[],
                                                facultylist character varying[], yearlist integer[],
                                                semesterlist integer[])
    RETURNS TABLE
            (
                id             integer,
                teacherid      integer,
                secondname     character varying,
                firstname      character varying,
                lastname       character varying,
                departmentname character varying,
                facultyname    character varying,
                groupnumber    integer,
                coursenumber   integer,
                disciple       character varying,
                classtype      university.class_types,
                year           integer,
                semester       integer
            )
    LANGUAGE plpgsql
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
$$;


--
-- Name: find_teacher_diplomas(character varying[], character varying[], university.position_types[]); Type: FUNCTION; Schema: university; Owner: -
--

CREATE FUNCTION university.find_teacher_diplomas(departmentlist character varying[], facultylist character varying[],
                                                 positionlist university.position_types[])
    RETURNS TABLE
            (
                id             integer,
                teacherid      integer,
                secondname     character varying,
                firstname      character varying,
                lastname       character varying,
                departmentname character varying,
                facultyname    character varying,
                positiontype   university.position_types,
                diplomatitles  character varying,
                studentname    text
            )
    LANGUAGE plpgsql
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
$$;


--
-- Name: find_teacher_exams(integer[], character varying[], integer[]); Type: FUNCTION; Schema: university; Owner: -
--

CREATE FUNCTION university.find_teacher_exams(grouplist integer[], disciplelist character varying[],
                                              semesterlist integer[])
    RETURNS TABLE
            (
                id             integer,
                teacherid      integer,
                secondname     character varying,
                firstname      character varying,
                lastname       character varying,
                departmentname character varying,
                facultyname    character varying,
                groupnumbers   text,
                coursenumber   integer,
                disciple       character varying,
                examtype       university.exam_types,
                year           integer,
                semester       integer
            )
    LANGUAGE plpgsql
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
$$;


--
-- Name: find_teacher_groups(character varying[], integer[], integer[], character varying[], character varying[]); Type: FUNCTION; Schema: university; Owner: -
--

CREATE FUNCTION university.find_teacher_groups(disciplelist character varying[], grouplist integer[],
                                               courselist integer[], departmentlist character varying[],
                                               facultylist character varying[])
    RETURNS TABLE
            (
                id             integer,
                teacherid      integer,
                secondname     character varying,
                firstname      character varying,
                lastname       character varying,
                departmentname character varying,
                facultyname    character varying,
                groupnumber    integer,
                coursenumber   integer,
                disciple       character varying
            )
    LANGUAGE plpgsql
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
$$;


--
-- Name: find_teacher_workloads(integer[], character varying[], university.class_types[]); Type: FUNCTION; Schema: university; Owner: -
--

CREATE FUNCTION university.find_teacher_workloads(teacherlist integer[], departmentlist character varying[],
                                                  classtypes university.class_types[])
    RETURNS TABLE
            (
                id             integer,
                secondname     character varying,
                firstname      character varying,
                lastname       character varying,
                departmentname character varying,
                facultyname    character varying,
                workload       integer
            )
    LANGUAGE plpgsql
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
$$;


--
-- Name: find_teachers(character varying[], character varying[], university.position_types[], university.gender_types[], integer[], integer[], integer, integer[], university.academic_degrees[], university.article_types[], date[]); Type: FUNCTION; Schema: university; Owner: -
--

CREATE FUNCTION university.find_teachers(departmentlist character varying[], facultylist character varying[],
                                         positionlist university.position_types[], genderlist university.gender_types[],
                                         yearlist integer[], agelist integer[], kidscount integer,
                                         salaryinterval integer[], degreelist university.academic_degrees[],
                                         articlelist university.article_types[], articledateinterval date[])
    RETURNS TABLE
            (
                id               integer,
                secondname       character varying,
                firstname        character varying,
                lastname         character varying,
                dateofbirth      date,
                age              integer,
                departmentname   character varying,
                facultyname      character varying,
                positiontype     university.position_types,
                kids             character varying,
                salary           integer,
                degree           university.academic_degrees,
                defendedarticles text
            )
    LANGUAGE plpgsql
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
               array_to_string(array_agg(dd.article_title), ',') AS degended_articles
        FROM teachers t
                 INNER JOIN departments d on d.id = t.department_id
                 INNER JOIN faculties f on f.id = d.faculty_id
                 INNER JOIN persons p on p.id = t.id
                 INNER JOIN defended_degrees dd on p.id = dd.person_id
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
$$;


--
-- Name: person_name(integer); Type: FUNCTION; Schema: university; Owner: -
--

CREATE FUNCTION university.person_name(personid integer) RETURNS text
    LANGUAGE sql
AS
$$
SELECT concat_ws(' ', second_name, first_name, coalesce(last_name, ''))
FROM persons
WHERE id = personId
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: classes; Type: TABLE; Schema: university; Owner: -
--

CREATE TABLE university.classes
(
    id          integer                NOT NULL,
    group_id    integer                NOT NULL,
    teacher_id  integer                NOT NULL,
    disciple_id integer                NOT NULL,
    class_type  university.class_types NOT NULL,
    hours       integer                NOT NULL
);


--
-- Name: classes_id_seq; Type: SEQUENCE; Schema: university; Owner: -
--

CREATE SEQUENCE university.classes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: classes_id_seq; Type: SEQUENCE OWNED BY; Schema: university; Owner: -
--

ALTER SEQUENCE university.classes_id_seq OWNED BY university.classes.id;


--
-- Name: courses; Type: TABLE; Schema: university; Owner: -
--

CREATE TABLE university.courses
(
    id            integer NOT NULL,
    course_type   university.course_types,
    course_number integer NOT NULL,
    faculty_id    integer NOT NULL,
    CONSTRAINT number CHECK ((course_number > 0))
);


--
-- Name: courses_id_seq; Type: SEQUENCE; Schema: university; Owner: -
--

CREATE SEQUENCE university.courses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: courses_id_seq; Type: SEQUENCE OWNED BY; Schema: university; Owner: -
--

ALTER SEQUENCE university.courses_id_seq OWNED BY university.courses.id;


--
-- Name: curriculum; Type: TABLE; Schema: university; Owner: -
--

CREATE TABLE university.curriculum
(
    id          integer                NOT NULL,
    disciple_id integer                NOT NULL,
    hours       integer                NOT NULL,
    year        integer                NOT NULL,
    course_id   integer                NOT NULL,
    semester    integer                NOT NULL,
    class_type  university.class_types NOT NULL,
    CONSTRAINT hours_constraint CHECK ((hours > 0)),
    CONSTRAINT semester_constraint CHECK ((semester > 0)),
    CONSTRAINT year_constraint CHECK ((year > 0))
);


--
-- Name: curriculum_id_seq; Type: SEQUENCE; Schema: university; Owner: -
--

CREATE SEQUENCE university.curriculum_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: curriculum_id_seq; Type: SEQUENCE OWNED BY; Schema: university; Owner: -
--

ALTER SEQUENCE university.curriculum_id_seq OWNED BY university.curriculum.id;


--
-- Name: defended_degrees; Type: TABLE; Schema: university; Owner: -
--

CREATE TABLE university.defended_degrees
(
    id            integer                  NOT NULL,
    person_id     integer                  NOT NULL,
    defend_date   date                     NOT NULL,
    article_type  university.article_types NOT NULL,
    article_title character varying        NOT NULL,
    CONSTRAINT date_constraint CHECK ((defend_date < now()))
);


--
-- Name: defended_degrees_id_seq; Type: SEQUENCE; Schema: university; Owner: -
--

CREATE SEQUENCE university.defended_degrees_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: defended_degrees_id_seq; Type: SEQUENCE OWNED BY; Schema: university; Owner: -
--

ALTER SEQUENCE university.defended_degrees_id_seq OWNED BY university.defended_degrees.id;


--
-- Name: departments; Type: TABLE; Schema: university; Owner: -
--

CREATE TABLE university.departments
(
    id              integer           NOT NULL,
    department_name character varying NOT NULL,
    faculty_id      integer           NOT NULL
);


--
-- Name: departments_id_seq; Type: SEQUENCE; Schema: university; Owner: -
--

CREATE SEQUENCE university.departments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: departments_id_seq; Type: SEQUENCE OWNED BY; Schema: university; Owner: -
--

ALTER SEQUENCE university.departments_id_seq OWNED BY university.departments.id;


--
-- Name: disciples; Type: TABLE; Schema: university; Owner: -
--

CREATE TABLE university.disciples
(
    id            integer           NOT NULL,
    disciple_name character varying NOT NULL
);


--
-- Name: disciples_id_seq; Type: SEQUENCE; Schema: university; Owner: -
--

CREATE SEQUENCE university.disciples_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: disciples_id_seq; Type: SEQUENCE OWNED BY; Schema: university; Owner: -
--

ALTER SEQUENCE university.disciples_id_seq OWNED BY university.disciples.id;


--
-- Name: exam_assignments; Type: TABLE; Schema: university; Owner: -
--

CREATE TABLE university.exam_assignments
(
    disciple_id integer               NOT NULL,
    exam_type   university.exam_types NOT NULL,
    id          integer               NOT NULL
);


--
-- Name: exam_assignments_id_seq; Type: SEQUENCE; Schema: university; Owner: -
--

CREATE SEQUENCE university.exam_assignments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: exam_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: university; Owner: -
--

ALTER SEQUENCE university.exam_assignments_id_seq OWNED BY university.exam_assignments.id;


--
-- Name: exams; Type: TABLE; Schema: university; Owner: -
--

CREATE TABLE university.exams
(
    id          integer NOT NULL,
    disciple_id integer NOT NULL,
    date        date    NOT NULL,
    session_id  integer NOT NULL
);


--
-- Name: exams_id_seq; Type: SEQUENCE; Schema: university; Owner: -
--

CREATE SEQUENCE university.exams_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: exams_id_seq; Type: SEQUENCE OWNED BY; Schema: university; Owner: -
--

ALTER SEQUENCE university.exams_id_seq OWNED BY university.exams.id;


--
-- Name: faculties; Type: TABLE; Schema: university; Owner: -
--

CREATE TABLE university.faculties
(
    id           integer           NOT NULL,
    dean_id      integer           NOT NULL,
    faculty_name character varying NOT NULL
);


--
-- Name: faculties_id_seq; Type: SEQUENCE; Schema: university; Owner: -
--

CREATE SEQUENCE university.faculties_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: faculties_id_seq; Type: SEQUENCE OWNED BY; Schema: university; Owner: -
--

ALTER SEQUENCE university.faculties_id_seq OWNED BY university.faculties.id;


--
-- Name: groups; Type: TABLE; Schema: university; Owner: -
--

CREATE TABLE university.groups
(
    id           integer NOT NULL,
    group_number integer NOT NULL,
    monitor      integer,
    course_id    integer NOT NULL,
    CONSTRAINT group_number CHECK ((group_number > 0))
);


--
-- Name: groups_id_seq; Type: SEQUENCE; Schema: university; Owner: -
--

CREATE SEQUENCE university.groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: groups_id_seq; Type: SEQUENCE OWNED BY; Schema: university; Owner: -
--

ALTER SEQUENCE university.groups_id_seq OWNED BY university.groups.id;


--
-- Name: passes; Type: TABLE; Schema: university; Owner: -
--

CREATE TABLE university.passes
(
    id         integer               NOT NULL,
    exam_id    integer               NOT NULL,
    student_id integer               NOT NULL,
    mark       university.mark_types NOT NULL,
    mark_num   integer,
    teacher_id integer               NOT NULL,
    CONSTRAINT mark_constraint CHECK ((mark_num > 0))
);


--
-- Name: passes_id_seq; Type: SEQUENCE; Schema: university; Owner: -
--

CREATE SEQUENCE university.passes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: passes_id_seq; Type: SEQUENCE OWNED BY; Schema: university; Owner: -
--

ALTER SEQUENCE university.passes_id_seq OWNED BY university.passes.id;


--
-- Name: persons; Type: TABLE; Schema: university; Owner: -
--

CREATE TABLE university.persons
(
    id            integer           NOT NULL,
    first_name    character varying NOT NULL,
    second_name   character varying NOT NULL,
    last_name     character varying,
    gender        university.gender_types,
    date_of_birth date              NOT NULL,
    kids          character varying,
    CONSTRAINT age_constraint CHECK ((date_of_birth < now()))
);


--
-- Name: persons_id_seq; Type: SEQUENCE; Schema: university; Owner: -
--

CREATE SEQUENCE university.persons_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: persons_id_seq; Type: SEQUENCE OWNED BY; Schema: university; Owner: -
--

ALTER SEQUENCE university.persons_id_seq OWNED BY university.persons.id;


--
-- Name: sessions; Type: TABLE; Schema: university; Owner: -
--

CREATE TABLE university.sessions
(
    id           integer NOT NULL,
    session_date date    NOT NULL,
    name         character varying
);


--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: university; Owner: -
--

CREATE SEQUENCE university.sessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: university; Owner: -
--

ALTER SEQUENCE university.sessions_id_seq OWNED BY university.sessions.id;


--
-- Name: students; Type: TABLE; Schema: university; Owner: -
--

CREATE TABLE university.students
(
    id                  integer NOT NULL,
    record_book_num     integer NOT NULL,
    group_id            integer,
    scholarship         integer,
    diploma_title       character varying,
    scientific_director integer,
    CONSTRAINT scholarship_constraint CHECK ((scholarship >= 0))
);


--
-- Name: students_record_book_num_seq; Type: SEQUENCE; Schema: university; Owner: -
--

CREATE SEQUENCE university.students_record_book_num_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: students_record_book_num_seq; Type: SEQUENCE OWNED BY; Schema: university; Owner: -
--

ALTER SEQUENCE university.students_record_book_num_seq OWNED BY university.students.record_book_num;


--
-- Name: study_assignments; Type: TABLE; Schema: university; Owner: -
--

CREATE TABLE university.study_assignments
(
    department_id integer NOT NULL,
    disciple_id   integer NOT NULL
);


--
-- Name: teacher_exams; Type: TABLE; Schema: university; Owner: -
--

CREATE TABLE university.teacher_exams
(
    id         integer NOT NULL,
    teacher_id integer NOT NULL,
    exam_id    integer NOT NULL
);


--
-- Name: teacher_exams_id_seq; Type: SEQUENCE; Schema: university; Owner: -
--

CREATE SEQUENCE university.teacher_exams_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: teacher_exams_id_seq; Type: SEQUENCE OWNED BY; Schema: university; Owner: -
--

ALTER SEQUENCE university.teacher_exams_id_seq OWNED BY university.teacher_exams.id;


--
-- Name: teachers; Type: TABLE; Schema: university; Owner: -
--

CREATE TABLE university.teachers
(
    id                   integer                   NOT NULL,
    department_id        integer                   NOT NULL,
    salary               integer                   NOT NULL,
    degree               university.academic_degrees,
    position_type        university.position_types NOT NULL,
    scientific_theme     character varying,
    scientific_direction character varying,
    CONSTRAINT salary CHECK ((salary >= 0))
);


--
-- Name: classes id; Type: DEFAULT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.classes
    ALTER COLUMN id SET DEFAULT nextval('university.classes_id_seq'::regclass);


--
-- Name: courses id; Type: DEFAULT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.courses
    ALTER COLUMN id SET DEFAULT nextval('university.courses_id_seq'::regclass);


--
-- Name: curriculum id; Type: DEFAULT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.curriculum
    ALTER COLUMN id SET DEFAULT nextval('university.curriculum_id_seq'::regclass);


--
-- Name: defended_degrees id; Type: DEFAULT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.defended_degrees
    ALTER COLUMN id SET DEFAULT nextval('university.defended_degrees_id_seq'::regclass);


--
-- Name: departments id; Type: DEFAULT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.departments
    ALTER COLUMN id SET DEFAULT nextval('university.departments_id_seq'::regclass);


--
-- Name: disciples id; Type: DEFAULT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.disciples
    ALTER COLUMN id SET DEFAULT nextval('university.disciples_id_seq'::regclass);


--
-- Name: exam_assignments id; Type: DEFAULT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.exam_assignments
    ALTER COLUMN id SET DEFAULT nextval('university.exam_assignments_id_seq'::regclass);


--
-- Name: exams id; Type: DEFAULT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.exams
    ALTER COLUMN id SET DEFAULT nextval('university.exams_id_seq'::regclass);


--
-- Name: faculties id; Type: DEFAULT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.faculties
    ALTER COLUMN id SET DEFAULT nextval('university.faculties_id_seq'::regclass);


--
-- Name: groups id; Type: DEFAULT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.groups
    ALTER COLUMN id SET DEFAULT nextval('university.groups_id_seq'::regclass);


--
-- Name: passes id; Type: DEFAULT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.passes
    ALTER COLUMN id SET DEFAULT nextval('university.passes_id_seq'::regclass);


--
-- Name: persons id; Type: DEFAULT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.persons
    ALTER COLUMN id SET DEFAULT nextval('university.persons_id_seq'::regclass);


--
-- Name: sessions id; Type: DEFAULT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.sessions
    ALTER COLUMN id SET DEFAULT nextval('university.sessions_id_seq'::regclass);


--
-- Name: students record_book_num; Type: DEFAULT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.students
    ALTER COLUMN record_book_num SET DEFAULT nextval('university.students_record_book_num_seq'::regclass);


--
-- Name: teacher_exams id; Type: DEFAULT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.teacher_exams
    ALTER COLUMN id SET DEFAULT nextval('university.teacher_exams_id_seq'::regclass);


--
-- Data for Name: classes; Type: TABLE DATA; Schema: university; Owner: -
--

INSERT INTO university.classes (id, group_id, teacher_id, disciple_id, class_type, hours)
VALUES (1, 3, 13, 1, 'lection', 32);
INSERT INTO university.classes (id, group_id, teacher_id, disciple_id, class_type, hours)
VALUES (2, 3, 19, 2, 'lection', 32);
INSERT INTO university.classes (id, group_id, teacher_id, disciple_id, class_type, hours)
VALUES (3, 3, 14, 3, 'laboratory_work', 32);
INSERT INTO university.classes (id, group_id, teacher_id, disciple_id, class_type, hours)
VALUES (4, 3, 15, 4, 'lection', 32);
INSERT INTO university.classes (id, group_id, teacher_id, disciple_id, class_type, hours)
VALUES (5, 3, 17, 5, 'lection', 32);
INSERT INTO university.classes (id, group_id, teacher_id, disciple_id, class_type, hours)
VALUES (6, 3, 18, 6, 'lection', 32);
INSERT INTO university.classes (id, group_id, teacher_id, disciple_id, class_type, hours)
VALUES (7, 3, 20, 7, 'lection', 32);
INSERT INTO university.classes (id, group_id, teacher_id, disciple_id, class_type, hours)
VALUES (8, 3, 24, 8, 'lection', 32);
INSERT INTO university.classes (id, group_id, teacher_id, disciple_id, class_type, hours)
VALUES (9, 3, 25, 9, 'lection', 32);
INSERT INTO university.classes (id, group_id, teacher_id, disciple_id, class_type, hours)
VALUES (10, 3, 21, 10, 'lection', 32);
INSERT INTO university.classes (id, group_id, teacher_id, disciple_id, class_type, hours)
VALUES (11, 3, 13, 1, 'seminar', 32);
INSERT INTO university.classes (id, group_id, teacher_id, disciple_id, class_type, hours)
VALUES (12, 3, 19, 2, 'seminar', 32);
INSERT INTO university.classes (id, group_id, teacher_id, disciple_id, class_type, hours)
VALUES (13, 3, 15, 4, 'seminar', 32);
INSERT INTO university.classes (id, group_id, teacher_id, disciple_id, class_type, hours)
VALUES (14, 3, 17, 5, 'seminar', 32);
INSERT INTO university.classes (id, group_id, teacher_id, disciple_id, class_type, hours)
VALUES (15, 3, 22, 6, 'seminar', 32);
INSERT INTO university.classes (id, group_id, teacher_id, disciple_id, class_type, hours)
VALUES (16, 3, 23, 7, 'seminar', 32);
INSERT INTO university.classes (id, group_id, teacher_id, disciple_id, class_type, hours)
VALUES (17, 3, 24, 8, 'seminar', 32);
INSERT INTO university.classes (id, group_id, teacher_id, disciple_id, class_type, hours)
VALUES (18, 3, 25, 9, 'seminar', 16);
INSERT INTO university.classes (id, group_id, teacher_id, disciple_id, class_type, hours)
VALUES (19, 3, 21, 10, 'seminar', 32);
INSERT INTO university.classes (id, group_id, teacher_id, disciple_id, class_type, hours)
VALUES (20, 10, 17, 5, 'lection', 16);
INSERT INTO university.classes (id, group_id, teacher_id, disciple_id, class_type, hours)
VALUES (21, 10, 18, 6, 'lection', 16);
INSERT INTO university.classes (id, group_id, teacher_id, disciple_id, class_type, hours)
VALUES (22, 15, 20, 7, 'lection', 32);
INSERT INTO university.classes (id, group_id, teacher_id, disciple_id, class_type, hours)
VALUES (23, 15, 24, 8, 'lection', 32);
INSERT INTO university.classes (id, group_id, teacher_id, disciple_id, class_type, hours)
VALUES (24, 20, 25, 9, 'lection', 8);
INSERT INTO university.classes (id, group_id, teacher_id, disciple_id, class_type, hours)
VALUES (25, 20, 21, 10, 'lection', 8);
INSERT INTO university.classes (id, group_id, teacher_id, disciple_id, class_type, hours)
VALUES (26, 10, 17, 5, 'seminar', 32);
INSERT INTO university.classes (id, group_id, teacher_id, disciple_id, class_type, hours)
VALUES (27, 10, 22, 6, 'seminar', 32);
INSERT INTO university.classes (id, group_id, teacher_id, disciple_id, class_type, hours)
VALUES (28, 15, 23, 7, 'seminar', 64);
INSERT INTO university.classes (id, group_id, teacher_id, disciple_id, class_type, hours)
VALUES (29, 15, 24, 8, 'seminar', 64);
INSERT INTO university.classes (id, group_id, teacher_id, disciple_id, class_type, hours)
VALUES (30, 20, 25, 9, 'seminar', 8);
INSERT INTO university.classes (id, group_id, teacher_id, disciple_id, class_type, hours)
VALUES (31, 20, 21, 10, 'seminar', 8);


--
-- Data for Name: courses; Type: TABLE DATA; Schema: university; Owner: -
--

INSERT INTO university.courses (id, course_type, course_number, faculty_id)
VALUES (13, 'undergraduate', 3, 4);
INSERT INTO university.courses (id, course_type, course_number, faculty_id)
VALUES (12, 'undergraduate', 2, 4);
INSERT INTO university.courses (id, course_type, course_number, faculty_id)
VALUES (15, 'undergraduate', 1, 5);
INSERT INTO university.courses (id, course_type, course_number, faculty_id)
VALUES (14, 'undergraduate', 4, 4);
INSERT INTO university.courses (id, course_type, course_number, faculty_id)
VALUES (9, 'undergraduate', 3, 3);
INSERT INTO university.courses (id, course_type, course_number, faculty_id)
VALUES (8, 'undergraduate', 2, 3);
INSERT INTO university.courses (id, course_type, course_number, faculty_id)
VALUES (11, 'undergraduate', 1, 4);
INSERT INTO university.courses (id, course_type, course_number, faculty_id)
VALUES (10, 'undergraduate', 4, 3);
INSERT INTO university.courses (id, course_type, course_number, faculty_id)
VALUES (5, 'undergraduate', 2, 1);
INSERT INTO university.courses (id, course_type, course_number, faculty_id)
VALUES (4, 'undergraduate', 1, 1);
INSERT INTO university.courses (id, course_type, course_number, faculty_id)
VALUES (7, 'undergraduate', 1, 3);
INSERT INTO university.courses (id, course_type, course_number, faculty_id)
VALUES (6, 'undergraduate', 4, 1);
INSERT INTO university.courses (id, course_type, course_number, faculty_id)
VALUES (1, 'undergraduate', 3, 1);
INSERT INTO university.courses (id, course_type, course_number, faculty_id)
VALUES (25, 'undergraduate', 3, 7);
INSERT INTO university.courses (id, course_type, course_number, faculty_id)
VALUES (24, 'undergraduate', 2, 7);
INSERT INTO university.courses (id, course_type, course_number, faculty_id)
VALUES (26, 'undergraduate', 4, 7);
INSERT INTO university.courses (id, course_type, course_number, faculty_id)
VALUES (21, 'undergraduate', 3, 6);
INSERT INTO university.courses (id, course_type, course_number, faculty_id)
VALUES (20, 'undergraduate', 2, 6);
INSERT INTO university.courses (id, course_type, course_number, faculty_id)
VALUES (23, 'undergraduate', 1, 7);
INSERT INTO university.courses (id, course_type, course_number, faculty_id)
VALUES (22, 'undergraduate', 4, 6);
INSERT INTO university.courses (id, course_type, course_number, faculty_id)
VALUES (17, 'undergraduate', 3, 5);
INSERT INTO university.courses (id, course_type, course_number, faculty_id)
VALUES (16, 'undergraduate', 2, 5);
INSERT INTO university.courses (id, course_type, course_number, faculty_id)
VALUES (19, 'undergraduate', 1, 6);
INSERT INTO university.courses (id, course_type, course_number, faculty_id)
VALUES (18, 'undergraduate', 4, 5);


--
-- Data for Name: curriculum; Type: TABLE DATA; Schema: university; Owner: -
--

INSERT INTO university.curriculum (id, disciple_id, hours, year, course_id, semester, class_type)
VALUES (17, 9, 16, 2022, 1, 2, 'seminar');
INSERT INTO university.curriculum (id, disciple_id, hours, year, course_id, semester, class_type)
VALUES (28, 6, 32, 2020, 10, 1, 'seminar');
INSERT INTO university.curriculum (id, disciple_id, hours, year, course_id, semester, class_type)
VALUES (31, 9, 8, 2020, 20, 1, 'seminar');
INSERT INTO university.curriculum (id, disciple_id, hours, year, course_id, semester, class_type)
VALUES (29, 7, 64, 2020, 15, 2, 'seminar');
INSERT INTO university.curriculum (id, disciple_id, hours, year, course_id, semester, class_type)
VALUES (23, 7, 32, 2020, 15, 2, 'lection');
INSERT INTO university.curriculum (id, disciple_id, hours, year, course_id, semester, class_type)
VALUES (25, 9, 8, 2020, 20, 1, 'lection');
INSERT INTO university.curriculum (id, disciple_id, hours, year, course_id, semester, class_type)
VALUES (24, 8, 32, 2020, 15, 2, 'lection');
INSERT INTO university.curriculum (id, disciple_id, hours, year, course_id, semester, class_type)
VALUES (8, 4, 32, 2022, 1, 2, 'lection');
INSERT INTO university.curriculum (id, disciple_id, hours, year, course_id, semester, class_type)
VALUES (5, 2, 8, 2022, 1, 2, 'lection');
INSERT INTO university.curriculum (id, disciple_id, hours, year, course_id, semester, class_type)
VALUES (3, 1, 32, 2022, 1, 2, 'lection');
INSERT INTO university.curriculum (id, disciple_id, hours, year, course_id, semester, class_type)
VALUES (16, 8, 32, 2022, 1, 2, 'lection');
INSERT INTO university.curriculum (id, disciple_id, hours, year, course_id, semester, class_type)
VALUES (26, 10, 8, 2020, 20, 1, 'lection');
INSERT INTO university.curriculum (id, disciple_id, hours, year, course_id, semester, class_type)
VALUES (11, 6, 32, 2022, 1, 2, 'seminar');
INSERT INTO university.curriculum (id, disciple_id, hours, year, course_id, semester, class_type)
VALUES (9, 5, 32, 2022, 1, 2, 'seminar');
INSERT INTO university.curriculum (id, disciple_id, hours, year, course_id, semester, class_type)
VALUES (22, 6, 16, 2020, 10, 1, 'lection');
INSERT INTO university.curriculum (id, disciple_id, hours, year, course_id, semester, class_type)
VALUES (21, 5, 16, 2020, 10, 1, 'lection');
INSERT INTO university.curriculum (id, disciple_id, hours, year, course_id, semester, class_type)
VALUES (20, 10, 32, 2022, 1, 2, 'lection');
INSERT INTO university.curriculum (id, disciple_id, hours, year, course_id, semester, class_type)
VALUES (18, 9, 32, 2022, 1, 2, 'lection');
INSERT INTO university.curriculum (id, disciple_id, hours, year, course_id, semester, class_type)
VALUES (14, 7, 32, 2022, 1, 2, 'lection');
INSERT INTO university.curriculum (id, disciple_id, hours, year, course_id, semester, class_type)
VALUES (12, 6, 32, 2022, 1, 2, 'lection');
INSERT INTO university.curriculum (id, disciple_id, hours, year, course_id, semester, class_type)
VALUES (10, 5, 32, 2022, 1, 2, 'lection');
INSERT INTO university.curriculum (id, disciple_id, hours, year, course_id, semester, class_type)
VALUES (6, 3, 32, 2022, 1, 2, 'laboratory_work');
INSERT INTO university.curriculum (id, disciple_id, hours, year, course_id, semester, class_type)
VALUES (15, 8, 32, 2022, 1, 2, 'seminar');
INSERT INTO university.curriculum (id, disciple_id, hours, year, course_id, semester, class_type)
VALUES (13, 7, 32, 2022, 1, 2, 'seminar');
INSERT INTO university.curriculum (id, disciple_id, hours, year, course_id, semester, class_type)
VALUES (32, 10, 8, 2020, 20, 1, 'seminar');
INSERT INTO university.curriculum (id, disciple_id, hours, year, course_id, semester, class_type)
VALUES (27, 5, 32, 2020, 10, 1, 'seminar');
INSERT INTO university.curriculum (id, disciple_id, hours, year, course_id, semester, class_type)
VALUES (4, 2, 24, 2022, 1, 2, 'seminar');
INSERT INTO university.curriculum (id, disciple_id, hours, year, course_id, semester, class_type)
VALUES (7, 4, 32, 2022, 1, 2, 'seminar');
INSERT INTO university.curriculum (id, disciple_id, hours, year, course_id, semester, class_type)
VALUES (2, 1, 32, 2022, 1, 2, 'seminar');
INSERT INTO university.curriculum (id, disciple_id, hours, year, course_id, semester, class_type)
VALUES (19, 10, 32, 2022, 1, 2, 'seminar');
INSERT INTO university.curriculum (id, disciple_id, hours, year, course_id, semester, class_type)
VALUES (30, 8, 64, 2020, 15, 2, 'seminar');


--
-- Data for Name: defended_degrees; Type: TABLE DATA; Schema: university; Owner: -
--

INSERT INTO university.defended_degrees (id, person_id, defend_date, article_type, article_title)
VALUES (1, 26, '2015-08-19', 'phd', 'Linux core');
INSERT INTO university.defended_degrees (id, person_id, defend_date, article_type, article_title)
VALUES (2, 13, '2019-11-18', 'phd', 'TensorFlow');
INSERT INTO university.defended_degrees (id, person_id, defend_date, article_type, article_title)
VALUES (3, 16, '2009-01-06', 'phd', 'Ski wax');
INSERT INTO university.defended_degrees (id, person_id, defend_date, article_type, article_title)
VALUES (4, 17, '2021-05-12', 'phd', 'MPI');
INSERT INTO university.defended_degrees (id, person_id, defend_date, article_type, article_title)
VALUES (5, 19, '2014-09-05', 'phd', 'Fuzzy logic');
INSERT INTO university.defended_degrees (id, person_id, defend_date, article_type, article_title)
VALUES (6, 20, '2018-08-18', 'phd', 'Hash codes');
INSERT INTO university.defended_degrees (id, person_id, defend_date, article_type, article_title)
VALUES (7, 23, '2020-02-29', 'phd', 'Huffman code');
INSERT INTO university.defended_degrees (id, person_id, defend_date, article_type, article_title)
VALUES (8, 15, '2015-03-21', 'phd', 'Electric signal');
INSERT INTO university.defended_degrees (id, person_id, defend_date, article_type, article_title)
VALUES (9, 14, '2019-05-06', 'diploma', 'Plutonium radiation');
INSERT INTO university.defended_degrees (id, person_id, defend_date, article_type, article_title)
VALUES (10, 18, '2018-09-18', 'diploma', 'Web server');
INSERT INTO university.defended_degrees (id, person_id, defend_date, article_type, article_title)
VALUES (11, 21, '2017-10-12', 'diploma', 'Brain computer interface');
INSERT INTO university.defended_degrees (id, person_id, defend_date, article_type, article_title)
VALUES (12, 24, '2021-04-27', 'diploma', 'SQL injections');
INSERT INTO university.defended_degrees (id, person_id, defend_date, article_type, article_title)
VALUES (13, 22, '2019-08-03', 'diploma', 'Git server');
INSERT INTO university.defended_degrees (id, person_id, defend_date, article_type, article_title)
VALUES (14, 25, '2018-02-13', 'diploma', 'Criminal law');


--
-- Data for Name: departments; Type: TABLE DATA; Schema: university; Owner: -
--

INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (7, 'Department of Geophysics', 7);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (8, 'Department of General and Regional Geology', 7);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (9, 'Department of Mineralogy and Geochemistry', 7);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (10, 'Department of Historical Geology and Paleontology', 7);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (11, 'Department of Petrography and Geology of Ore Deposits', 7);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (12, 'Department of Geology of Oil and Gas Fields', 7);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (13, 'Department of Algebra and Mathematical Logic', 6);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (14, 'Department of Higher Mathematics', 6);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (15, 'Department of Computational Mathematics', 6);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (16, 'Department of Computing Systems', 6);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (17, 'Department of Geometry and Topology', 6);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (18, 'Department of Hydrodynamics', 6);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (19, 'Department of Discrete Mathematics and Informatics', 6);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (20, 'Department of Differential Equations', 6);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (21, 'Department of Mathematical Methods of Geophysics', 6);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (22, 'Department of Mathematical Analysis', 6);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (23, 'Department of Mathematical Modeling', 6);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (24, 'Department of Mathematical Economics', 6);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (25, 'Department of Solid State Mechanics', 6);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (26, 'Department of Applied Mathematics', 6);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (27, 'Department of Programming', 6);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (28, 'Department of Theoretical Cybernetics', 6);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (29, 'Department of Theoretical Mechanics', 6);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (30, 'Department of Probability Theory and Mathematical Statistics', 6);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (31, 'Department of Function Theory', 6);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (32, 'Department of Analytical Chemistry', 4);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (33, 'Department of Catalysis and Adsorption', 4);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (34, 'Department of Molecular Biology and Biotechnology', 4);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (35, 'Department of Nanocomposite Materials', 4);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (36, 'Department of Inorganic Chemistry', 4);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (37, 'Department of Organic Chemistry', 4);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (38, 'Department of Physical Chemistry', 4);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (39, 'Department of Solid State Chemistry', 4);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (40, 'Department of Chemical Materials Science', 4);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (41, 'Department of Information Biology', 4);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (42, 'Department of Cytology and Genetics', 4);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (43, 'Department of General Biology and Ecology', 4);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (44, 'Department of Physiology', 4);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (2, 'Department of Computer Systems', 1);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (5, 'Department of Computer Technologies', 1);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (4, 'Department of Discrete Analysis and Operations Research', 1);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (6, 'Department of Parallel Computing', 1);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (1, 'Department of Informatics Systems', 1);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (3, 'Department of General Informatics', 1);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (45, 'Department of Math', 1);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (50, 'Department of Automation of Physical and Technical Research', 3);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (51, 'Department of Aerophysics and Gas Dynamics', 3);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (52, 'Department of Biomedical Physics', 3);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (53, 'Department of Higher Mathematics', 3);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (54, 'Department of Quantum Optics', 3);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (55, 'Department of Quantum Electronics', 3);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (56, 'Department of Nanocomposite Materials', 3);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (57, 'Department of General Physics', 3);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (58, 'Department of Radiophysics', 3);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (59, 'Department of Theoretical Physics', 3);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (60, 'Department of Physics of Non-Equilibrium Processes', 3);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (61, 'Department of Plasma Physics', 3);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (62, 'Department of Semiconductor Physics', 3);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (63, 'Department of Continuum Physics', 3);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (64, 'Department of Accelerator Physics', 3);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (65, 'Department of Elementary Particle Physics', 3);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (66, 'Department of Physical and Technical Informatics', 3);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (67, 'Department of Physical Methods for Solid State Research', 3);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (68, 'Department of Chemical and Biological Physics', 3);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (69, 'Department of Management', 5);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (70, 'Department of Modeling and Industrial Production Management', 5);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (71, 'Department of General Economic Education', 5);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (72, 'Department of General Sociology', 5);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (73, 'Department of Political Economy', 5);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (74, 'Department of legal support of market economy', 5);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (75, 'Department of Application of Mathematical Methods in Economics', 5);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (76, 'Department of Finance and Credit', 5);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (77, 'Department of Economic Management', 5);
INSERT INTO university.departments (id, department_name, faculty_id)
VALUES (78, 'Department of Economic Theory', 5);


--
-- Data for Name: disciples; Type: TABLE DATA; Schema: university; Owner: -
--

INSERT INTO university.disciples (id, disciple_name)
VALUES (1, 'TPNS');
INSERT INTO university.disciples (id, disciple_name)
VALUES (2, 'LMIZ');
INSERT INTO university.disciples (id, disciple_name)
VALUES (3, 'Measuring practice');
INSERT INTO university.disciples (id, disciple_name)
VALUES (4, 'Controlling theory');
INSERT INTO university.disciples (id, disciple_name)
VALUES (5, 'EPSMM');
INSERT INTO university.disciples (id, disciple_name)
VALUES (6, 'UPPRPO');
INSERT INTO university.disciples (id, disciple_name)
VALUES (7, 'Code theory');
INSERT INTO university.disciples (id, disciple_name)
VALUES (8, 'Databases');
INSERT INTO university.disciples (id, disciple_name)
VALUES (9, 'Law');
INSERT INTO university.disciples (id, disciple_name)
VALUES (10, 'Philosophy');


--
-- Data for Name: exam_assignments; Type: TABLE DATA; Schema: university; Owner: -
--

INSERT INTO university.exam_assignments (disciple_id, exam_type, id)
VALUES (8, 'exam', 8);
INSERT INTO university.exam_assignments (disciple_id, exam_type, id)
VALUES (4, 'exam', 4);
INSERT INTO university.exam_assignments (disciple_id, exam_type, id)
VALUES (10, 'exam', 10);
INSERT INTO university.exam_assignments (disciple_id, exam_type, id)
VALUES (6, 'differential_pass', 6);
INSERT INTO university.exam_assignments (disciple_id, exam_type, id)
VALUES (9, 'differential_pass', 9);
INSERT INTO university.exam_assignments (disciple_id, exam_type, id)
VALUES (7, 'exam', 7);
INSERT INTO university.exam_assignments (disciple_id, exam_type, id)
VALUES (2, 'exam', 2);
INSERT INTO university.exam_assignments (disciple_id, exam_type, id)
VALUES (1, 'pass', 1);
INSERT INTO university.exam_assignments (disciple_id, exam_type, id)
VALUES (5, 'pass', 5);
INSERT INTO university.exam_assignments (disciple_id, exam_type, id)
VALUES (3, 'differential_pass', 3);


--
-- Data for Name: exams; Type: TABLE DATA; Schema: university; Owner: -
--

INSERT INTO university.exams (id, disciple_id, date, session_id)
VALUES (5, 5, '2022-06-06', 2);
INSERT INTO university.exams (id, disciple_id, date, session_id)
VALUES (3, 3, '2022-06-20', 2);
INSERT INTO university.exams (id, disciple_id, date, session_id)
VALUES (9, 9, '2022-06-16', 2);
INSERT INTO university.exams (id, disciple_id, date, session_id)
VALUES (7, 7, '2022-06-14', 2);
INSERT INTO university.exams (id, disciple_id, date, session_id)
VALUES (8, 8, '2022-01-27', 2);
INSERT INTO university.exams (id, disciple_id, date, session_id)
VALUES (1, 1, '2022-06-12', 2);
INSERT INTO university.exams (id, disciple_id, date, session_id)
VALUES (2, 2, '2022-06-10', 2);
INSERT INTO university.exams (id, disciple_id, date, session_id)
VALUES (4, 4, '2022-06-21', 2);
INSERT INTO university.exams (id, disciple_id, date, session_id)
VALUES (10, 10, '2022-06-30', 2);
INSERT INTO university.exams (id, disciple_id, date, session_id)
VALUES (6, 6, '2022-06-28', 2);
INSERT INTO university.exams (id, disciple_id, date, session_id)
VALUES (11, 5, '2021-01-15', 3);
INSERT INTO university.exams (id, disciple_id, date, session_id)
VALUES (12, 6, '2021-01-18', 3);
INSERT INTO university.exams (id, disciple_id, date, session_id)
VALUES (13, 7, '2020-06-08', 4);
INSERT INTO university.exams (id, disciple_id, date, session_id)
VALUES (14, 8, '2020-06-11', 4);
INSERT INTO university.exams (id, disciple_id, date, session_id)
VALUES (15, 9, '2021-01-12', 3);
INSERT INTO university.exams (id, disciple_id, date, session_id)
VALUES (16, 10, '2021-01-18', 3);


--
-- Data for Name: faculties; Type: TABLE DATA; Schema: university; Owner: -
--

INSERT INTO university.faculties (id, dean_id, faculty_name)
VALUES (5, 32, 'Faculty of Economics');
INSERT INTO university.faculties (id, dean_id, faculty_name)
VALUES (4, 30, 'Faculty of Natural Science');
INSERT INTO university.faculties (id, dean_id, faculty_name)
VALUES (6, 29, 'Faculty of Mathematics and Mechanics');
INSERT INTO university.faculties (id, dean_id, faculty_name)
VALUES (1, 27, 'Faculty of Information Technologies');
INSERT INTO university.faculties (id, dean_id, faculty_name)
VALUES (3, 31, 'Faculty of Physics');
INSERT INTO university.faculties (id, dean_id, faculty_name)
VALUES (7, 28, 'Faculty of Geology and Geophysics');


--
-- Data for Name: groups; Type: TABLE DATA; Schema: university; Owner: -
--

INSERT INTO university.groups (id, group_number, monitor, course_id)
VALUES (4, 18206, NULL, 6);
INSERT INTO university.groups (id, group_number, monitor, course_id)
VALUES (5, 20203, NULL, 5);
INSERT INTO university.groups (id, group_number, monitor, course_id)
VALUES (6, 21211, NULL, 4);
INSERT INTO university.groups (id, group_number, monitor, course_id)
VALUES (7, 21303, NULL, 7);
INSERT INTO university.groups (id, group_number, monitor, course_id)
VALUES (8, 20307, NULL, 8);
INSERT INTO university.groups (id, group_number, monitor, course_id)
VALUES (9, 19310, NULL, 9);
INSERT INTO university.groups (id, group_number, monitor, course_id)
VALUES (11, 21405, NULL, 11);
INSERT INTO university.groups (id, group_number, monitor, course_id)
VALUES (12, 20406, NULL, 12);
INSERT INTO university.groups (id, group_number, monitor, course_id)
VALUES (13, 19401, NULL, 13);
INSERT INTO university.groups (id, group_number, monitor, course_id)
VALUES (14, 18408, NULL, 14);
INSERT INTO university.groups (id, group_number, monitor, course_id)
VALUES (16, 20703, NULL, 16);
INSERT INTO university.groups (id, group_number, monitor, course_id)
VALUES (17, 19708, NULL, 17);
INSERT INTO university.groups (id, group_number, monitor, course_id)
VALUES (18, 18701, NULL, 18);
INSERT INTO university.groups (id, group_number, monitor, course_id)
VALUES (19, 21111, NULL, 19);
INSERT INTO university.groups (id, group_number, monitor, course_id)
VALUES (21, 19141, NULL, 21);
INSERT INTO university.groups (id, group_number, monitor, course_id)
VALUES (22, 18122, NULL, 22);
INSERT INTO university.groups (id, group_number, monitor, course_id)
VALUES (23, 21501, NULL, 23);
INSERT INTO university.groups (id, group_number, monitor, course_id)
VALUES (24, 20503, NULL, 24);
INSERT INTO university.groups (id, group_number, monitor, course_id)
VALUES (25, 19505, NULL, 25);
INSERT INTO university.groups (id, group_number, monitor, course_id)
VALUES (26, 18502, NULL, 26);
INSERT INTO university.groups (id, group_number, monitor, course_id)
VALUES (15, 21705, 43, 15);
INSERT INTO university.groups (id, group_number, monitor, course_id)
VALUES (20, 20132, 45, 20);
INSERT INTO university.groups (id, group_number, monitor, course_id)
VALUES (10, 18301, 41, 10);
INSERT INTO university.groups (id, group_number, monitor, course_id)
VALUES (3, 19205, 9, 1);


--
-- Data for Name: passes; Type: TABLE DATA; Schema: university; Owner: -
--

INSERT INTO university.passes (id, exam_id, student_id, mark, mark_num, teacher_id)
VALUES (9, 8, 9, 'unsatisfactory', 2, 24);
INSERT INTO university.passes (id, exam_id, student_id, mark, mark_num, teacher_id)
VALUES (5, 5, 5, 'pass', NULL, 18);
INSERT INTO university.passes (id, exam_id, student_id, mark, mark_num, teacher_id)
VALUES (1, 1, 1, 'pass', NULL, 13);
INSERT INTO university.passes (id, exam_id, student_id, mark, mark_num, teacher_id)
VALUES (2, 2, 2, 'excellent', 5, 14);
INSERT INTO university.passes (id, exam_id, student_id, mark, mark_num, teacher_id)
VALUES (6, 4, 6, 'good', 4, 17);
INSERT INTO university.passes (id, exam_id, student_id, mark, mark_num, teacher_id)
VALUES (4, 3, 4, 'excellent', 5, 15);
INSERT INTO university.passes (id, exam_id, student_id, mark, mark_num, teacher_id)
VALUES (3, 1, 3, 'fail', NULL, 13);
INSERT INTO university.passes (id, exam_id, student_id, mark, mark_num, teacher_id)
VALUES (7, 7, 7, 'satisfactory', 3, 20);
INSERT INTO university.passes (id, exam_id, student_id, mark, mark_num, teacher_id)
VALUES (15, 13, 43, 'excellent', 5, 23);
INSERT INTO university.passes (id, exam_id, student_id, mark, mark_num, teacher_id)
VALUES (12, 10, 12, 'satisfactory', 3, 14);
INSERT INTO university.passes (id, exam_id, student_id, mark, mark_num, teacher_id)
VALUES (17, 15, 45, 'good', 4, 21);
INSERT INTO university.passes (id, exam_id, student_id, mark, mark_num, teacher_id)
VALUES (8, 9, 8, 'unsatisfactory', 2, 20);
INSERT INTO university.passes (id, exam_id, student_id, mark, mark_num, teacher_id)
VALUES (14, 12, 42, 'unsatisfactory', 2, 25);
INSERT INTO university.passes (id, exam_id, student_id, mark, mark_num, teacher_id)
VALUES (13, 11, 41, 'pass', NULL, 19);
INSERT INTO university.passes (id, exam_id, student_id, mark, mark_num, teacher_id)
VALUES (11, 1, 11, 'pass', NULL, 13);
INSERT INTO university.passes (id, exam_id, student_id, mark, mark_num, teacher_id)
VALUES (16, 14, 44, 'satisfactory', 3, 22);
INSERT INTO university.passes (id, exam_id, student_id, mark, mark_num, teacher_id)
VALUES (18, 16, 46, 'excellent', 5, 18);
INSERT INTO university.passes (id, exam_id, student_id, mark, mark_num, teacher_id)
VALUES (10, 6, 10, 'good', 4, 19);


--
-- Data for Name: persons; Type: TABLE DATA; Schema: university; Owner: -
--

INSERT INTO university.persons (id, first_name, second_name, last_name, gender, date_of_birth, kids)
VALUES (2, 'Vladislav', 'Vedernikov', 'Igorevich', 'male', '2001-05-01', NULL);
INSERT INTO university.persons (id, first_name, second_name, last_name, gender, date_of_birth, kids)
VALUES (9, 'Victoria', 'Taitova', 'Vladlenovna', 'female', '2001-06-17', NULL);
INSERT INTO university.persons (id, first_name, second_name, last_name, gender, date_of_birth, kids)
VALUES (4, 'Stepan', 'Loginovsky', 'Vladimirovich', 'male', '2000-11-08', NULL);
INSERT INTO university.persons (id, first_name, second_name, last_name, gender, date_of_birth, kids)
VALUES (8, 'Andrei', 'Savvateev', 'Andreevich', 'male', '2000-09-09', NULL);
INSERT INTO university.persons (id, first_name, second_name, last_name, gender, date_of_birth, kids)
VALUES (6, 'Nikita', 'Omelyanenko', 'Olegovich', 'male', '2001-11-11', NULL);
INSERT INTO university.persons (id, first_name, second_name, last_name, gender, date_of_birth, kids)
VALUES (11, 'Nikitin', 'Efim', 'Alexandrovich', 'male', '2001-08-19', NULL);
INSERT INTO university.persons (id, first_name, second_name, last_name, gender, date_of_birth, kids)
VALUES (12, 'Daniil', 'Saveliev', 'Mihaulovich', 'male', '2001-01-01', NULL);
INSERT INTO university.persons (id, first_name, second_name, last_name, gender, date_of_birth, kids)
VALUES (13, 'Alexandr', 'Kugaevskih', 'Vladimirovich', 'male', '1985-12-01', '2');
INSERT INTO university.persons (id, first_name, second_name, last_name, gender, date_of_birth, kids)
VALUES (14, 'Oleg', 'Bragin', 'Anatolievich', 'male', '1968-07-19', '1');
INSERT INTO university.persons (id, first_name, second_name, last_name, gender, date_of_birth, kids)
VALUES (15, 'Andrei', 'Lomov', 'Alexandrovich', 'male', '1976-09-01', NULL);
INSERT INTO university.persons (id, first_name, second_name, last_name, gender, date_of_birth, kids)
VALUES (16, 'Grigoriy', 'Oparin', 'Andreevich', 'male', '1988-01-19', NULL);
INSERT INTO university.persons (id, first_name, second_name, last_name, gender, date_of_birth, kids)
VALUES (17, 'Sergei', 'Kireev', 'Evgenevich', 'male', '1978-05-15', NULL);
INSERT INTO university.persons (id, first_name, second_name, last_name, gender, date_of_birth, kids)
VALUES (18, 'Denis', 'Anoikin', 'Alexandrovich', 'male', '1985-04-19', '2');
INSERT INTO university.persons (id, first_name, second_name, last_name, gender, date_of_birth, kids)
VALUES (19, 'Gulnara', 'Yahyaeva', 'Erkinovna', 'female', '1975-11-11', '3');
INSERT INTO university.persons (id, first_name, second_name, last_name, gender, date_of_birth, kids)
VALUES (20, 'Ivan', 'Mogilnih', 'Yurievich', 'male', '1988-03-15', '1');
INSERT INTO university.persons (id, first_name, second_name, last_name, gender, date_of_birth, kids)
VALUES (21, 'Alexandr', 'Savostyanov', 'Nikolaevich', 'male', '1968-08-28', '2');
INSERT INTO university.persons (id, first_name, second_name, last_name, gender, date_of_birth, kids)
VALUES (22, 'Timur', 'Ismagilov', 'Zinferovich', 'male', '1988-01-19', NULL);
INSERT INTO university.persons (id, first_name, second_name, last_name, gender, date_of_birth, kids)
VALUES (23, 'Evgeniy', 'Gorkunov', 'Vladimirovich', 'male', '1985-06-09', '1');
INSERT INTO university.persons (id, first_name, second_name, last_name, gender, date_of_birth, kids)
VALUES (24, 'Boris', 'Pishik', 'Nikolaevich', 'male', '1961-08-29', '1');
INSERT INTO university.persons (id, first_name, second_name, last_name, gender, date_of_birth, kids)
VALUES (26, 'Michail', 'Rutman', 'Valerievich', 'male', '1981-05-01', '2');
INSERT INTO university.persons (id, first_name, second_name, last_name, gender, date_of_birth, kids)
VALUES (27, 'Michail', 'Lavrentiev', 'Mihailovich', 'male', '1970-07-26', '1');
INSERT INTO university.persons (id, first_name, second_name, last_name, gender, date_of_birth, kids)
VALUES (28, 'Valeriy', 'Vernikovskiy', 'Arnoldovich', 'male', '1960-09-01', '4');
INSERT INTO university.persons (id, first_name, second_name, last_name, gender, date_of_birth, kids)
VALUES (29, 'Igor', 'Marchuk', 'Vladimirovich', 'male', '1985-11-07', '1');
INSERT INTO university.persons (id, first_name, second_name, last_name, gender, date_of_birth, kids)
VALUES (30, 'Vladimir', 'Reznikov', 'Anatolievich', 'male', '1968-09-11', NULL);
INSERT INTO university.persons (id, first_name, second_name, last_name, gender, date_of_birth, kids)
VALUES (31, 'Vladimir', 'Blinov', 'Evgenievich', 'male', '1975-08-12', '2');
INSERT INTO university.persons (id, first_name, second_name, last_name, gender, date_of_birth, kids)
VALUES (32, 'Gagik', 'Mkrtchan', 'Mkrtichevich', 'male', '1962-02-02', '3');
INSERT INTO university.persons (id, first_name, second_name, last_name, gender, date_of_birth, kids)
VALUES (10, 'Alexandr', 'Charchenko', 'Dmitrievich', 'male', '2001-10-24', NULL);
INSERT INTO university.persons (id, first_name, second_name, last_name, gender, date_of_birth, kids)
VALUES (7, 'Valeria', 'Pronina', 'Aleksandrovna', 'female', '2001-07-27', NULL);
INSERT INTO university.persons (id, first_name, second_name, last_name, gender, date_of_birth, kids)
VALUES (5, 'Erdem', 'Mitupov', 'Bairovich', 'male', '2001-12-26', NULL);
INSERT INTO university.persons (id, first_name, second_name, last_name, gender, date_of_birth, kids)
VALUES (1, 'Artem', 'Borodin', 'Maximovich', 'male', '2001-03-27', NULL);
INSERT INTO university.persons (id, first_name, second_name, last_name, gender, date_of_birth, kids)
VALUES (3, 'Natalya', 'Kokunina', 'Viktorovna', 'female', '2001-08-24', NULL);
INSERT INTO university.persons (id, first_name, second_name, last_name, gender, date_of_birth, kids)
VALUES (25, 'Vladimir', 'Dmitrievskiy', 'Sergeevich', 'male', '1983-03-03', NULL);
INSERT INTO university.persons (id, first_name, second_name, last_name, gender, date_of_birth, kids)
VALUES (41, 'Anastasia', 'Beznosoba', 'Alekseevna', 'female', '2003-08-11', NULL);
INSERT INTO university.persons (id, first_name, second_name, last_name, gender, date_of_birth, kids)
VALUES (42, 'Vladislav', 'Vasilevskiy', 'Maximovich', 'male', '2003-09-01', NULL);
INSERT INTO university.persons (id, first_name, second_name, last_name, gender, date_of_birth, kids)
VALUES (43, 'Victoria', 'Vahnova', 'Antonovna', 'female', '2003-03-28', NULL);
INSERT INTO university.persons (id, first_name, second_name, last_name, gender, date_of_birth, kids)
VALUES (44, 'Margarita', 'Kurkina', 'Yakovleva', 'female', '2003-08-18', NULL);
INSERT INTO university.persons (id, first_name, second_name, last_name, gender, date_of_birth, kids)
VALUES (45, 'Aleksei', 'Rassolov', 'Olegovich', 'male', '2003-01-01', NULL);
INSERT INTO university.persons (id, first_name, second_name, last_name, gender, date_of_birth, kids)
VALUES (46, 'Maria', 'Tregub', 'Sergeevna', 'female', '2003-05-13', NULL);


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: university; Owner: -
--

INSERT INTO university.sessions (id, session_date, name)
VALUES (2, '2022-06-05', '2022-06-05');
INSERT INTO university.sessions (id, session_date, name)
VALUES (3, '2021-01-07', '2021-01-07');
INSERT INTO university.sessions (id, session_date, name)
VALUES (4, '2020-06-06', '2020-06-06');


--
-- Data for Name: students; Type: TABLE DATA; Schema: university; Owner: -
--

INSERT INTO university.students (id, record_book_num, group_id, scholarship, diploma_title, scientific_director)
VALUES (1, 192089, 3, 10000, 'K8s optimization', 26);
INSERT INTO university.students (id, record_book_num, group_id, scholarship, diploma_title, scientific_director)
VALUES (3, 196435, 3, 10000, 'Container security', 26);
INSERT INTO university.students (id, record_book_num, group_id, scholarship, diploma_title, scientific_director)
VALUES (4, 182359, 3, NULL, NULL, NULL);
INSERT INTO university.students (id, record_book_num, group_id, scholarship, diploma_title, scientific_director)
VALUES (6, 193256, 3, 10000, 'Java optimization', 26);
INSERT INTO university.students (id, record_book_num, group_id, scholarship, diploma_title, scientific_director)
VALUES (7, 196235, 3, NULL, 'Neural networks', 13);
INSERT INTO university.students (id, record_book_num, group_id, scholarship, diploma_title, scientific_director)
VALUES (8, 189235, 3, NULL, NULL, NULL);
INSERT INTO university.students (id, record_book_num, group_id, scholarship, diploma_title, scientific_director)
VALUES (9, 192354, 3, NULL, NULL, NULL);
INSERT INTO university.students (id, record_book_num, group_id, scholarship, diploma_title, scientific_director)
VALUES (10, 190235, 3, 3000, NULL, NULL);
INSERT INTO university.students (id, record_book_num, group_id, scholarship, diploma_title, scientific_director)
VALUES (12, 191919, 3, 1000, NULL, NULL);
INSERT INTO university.students (id, record_book_num, group_id, scholarship, diploma_title, scientific_director)
VALUES (43, 218452, 15, NULL, NULL, NULL);
INSERT INTO university.students (id, record_book_num, group_id, scholarship, diploma_title, scientific_director)
VALUES (44, 214776, 15, 15000, NULL, NULL);
INSERT INTO university.students (id, record_book_num, group_id, scholarship, diploma_title, scientific_director)
VALUES (45, 219845, 20, NULL, NULL, NULL);
INSERT INTO university.students (id, record_book_num, group_id, scholarship, diploma_title, scientific_director)
VALUES (46, 214358, 20, NULL, NULL, NULL);
INSERT INTO university.students (id, record_book_num, group_id, scholarship, diploma_title, scientific_director)
VALUES (42, 213456, 10, NULL, 'Overclocking printer', 21);
INSERT INTO university.students (id, record_book_num, group_id, scholarship, diploma_title, scientific_director)
VALUES (5, 192356, 3, 5000, 'Random numbers', 23);
INSERT INTO university.students (id, record_book_num, group_id, scholarship, diploma_title, scientific_director)
VALUES (2, 198753, 3, NULL, 'Pet shop', 15);
INSERT INTO university.students (id, record_book_num, group_id, scholarship, diploma_title, scientific_director)
VALUES (41, 212890, 10, 3000, 'Light interference in glass', 14);
INSERT INTO university.students (id, record_book_num, group_id, scholarship, diploma_title, scientific_director)
VALUES (11, 192002, 3, NULL, 'Frontend ', 22);


--
-- Data for Name: study_assignments; Type: TABLE DATA; Schema: university; Owner: -
--

INSERT INTO university.study_assignments (department_id, disciple_id)
VALUES (5, 1);
INSERT INTO university.study_assignments (department_id, disciple_id)
VALUES (3, 2);
INSERT INTO university.study_assignments (department_id, disciple_id)
VALUES (57, 3);
INSERT INTO university.study_assignments (department_id, disciple_id)
VALUES (4, 4);
INSERT INTO university.study_assignments (department_id, disciple_id)
VALUES (6, 5);
INSERT INTO university.study_assignments (department_id, disciple_id)
VALUES (5, 6);
INSERT INTO university.study_assignments (department_id, disciple_id)
VALUES (45, 7);
INSERT INTO university.study_assignments (department_id, disciple_id)
VALUES (5, 8);
INSERT INTO university.study_assignments (department_id, disciple_id)
VALUES (58, 9);
INSERT INTO university.study_assignments (department_id, disciple_id)
VALUES (3, 10);


--
-- Data for Name: teacher_exams; Type: TABLE DATA; Schema: university; Owner: -
--

INSERT INTO university.teacher_exams (id, teacher_id, exam_id)
VALUES (1, 13, 1);
INSERT INTO university.teacher_exams (id, teacher_id, exam_id)
VALUES (2, 14, 2);
INSERT INTO university.teacher_exams (id, teacher_id, exam_id)
VALUES (3, 15, 3);
INSERT INTO university.teacher_exams (id, teacher_id, exam_id)
VALUES (4, 17, 4);
INSERT INTO university.teacher_exams (id, teacher_id, exam_id)
VALUES (5, 18, 5);
INSERT INTO university.teacher_exams (id, teacher_id, exam_id)
VALUES (6, 19, 6);
INSERT INTO university.teacher_exams (id, teacher_id, exam_id)
VALUES (7, 20, 7);
INSERT INTO university.teacher_exams (id, teacher_id, exam_id)
VALUES (8, 21, 8);
INSERT INTO university.teacher_exams (id, teacher_id, exam_id)
VALUES (9, 22, 9);
INSERT INTO university.teacher_exams (id, teacher_id, exam_id)
VALUES (10, 23, 10);
INSERT INTO university.teacher_exams (id, teacher_id, exam_id)
VALUES (11, 24, 8);
INSERT INTO university.teacher_exams (id, teacher_id, exam_id)
VALUES (12, 25, 3);


--
-- Data for Name: teachers; Type: TABLE DATA; Schema: university; Owner: -
--

INSERT INTO university.teachers (id, department_id, salary, degree, position_type, scientific_theme,
                                 scientific_direction)
VALUES (26, 1, 1000, 'candidate', 'professor', 'K8s, security', 'System programming');
INSERT INTO university.teachers (id, department_id, salary, degree, position_type, scientific_theme,
                                 scientific_direction)
VALUES (13, 5, 2000, 'candidate', 'teacher', 'Machine Learning', NULL);
INSERT INTO university.teachers (id, department_id, salary, degree, position_type, scientific_theme,
                                 scientific_direction)
VALUES (14, 57, 4000, 'master', 'assistant', NULL, NULL);
INSERT INTO university.teachers (id, department_id, salary, degree, position_type, scientific_theme,
                                 scientific_direction)
VALUES (16, 44, 4000, 'candidate', 'senior_teacher', 'Skiing', NULL);
INSERT INTO university.teachers (id, department_id, salary, degree, position_type, scientific_theme,
                                 scientific_direction)
VALUES (17, 6, 6000, 'candidate', 'professor', 'OpenMP, compiler optimizations', 'Parallel programming');
INSERT INTO university.teachers (id, department_id, salary, degree, position_type, scientific_theme,
                                 scientific_direction)
VALUES (18, 5, 3000, 'master', 'senior_teacher', 'Agile programming', NULL);
INSERT INTO university.teachers (id, department_id, salary, degree, position_type, scientific_theme,
                                 scientific_direction)
VALUES (19, 3, 4000, 'candidate', 'associate_professor', 'Logics', NULL);
INSERT INTO university.teachers (id, department_id, salary, degree, position_type, scientific_theme,
                                 scientific_direction)
VALUES (20, 45, 2000, 'candidate', 'associate_professor', 'Decoding optimization', NULL);
INSERT INTO university.teachers (id, department_id, salary, degree, position_type, scientific_theme,
                                 scientific_direction)
VALUES (21, 3, 4000, 'master', 'teacher', NULL, NULL);
INSERT INTO university.teachers (id, department_id, salary, degree, position_type, scientific_theme,
                                 scientific_direction)
VALUES (22, 5, 6000, 'bachelor', 'assistant', NULL, NULL);
INSERT INTO university.teachers (id, department_id, salary, degree, position_type, scientific_theme,
                                 scientific_direction)
VALUES (23, 45, 2000, 'candidate', 'professor', 'Encryption', 'Coding');
INSERT INTO university.teachers (id, department_id, salary, degree, position_type, scientific_theme,
                                 scientific_direction)
VALUES (24, 5, 7000, 'master', 'senior_teacher', 'RAID configuration', NULL);
INSERT INTO university.teachers (id, department_id, salary, degree, position_type, scientific_theme,
                                 scientific_direction)
VALUES (25, 58, 1000, 'bachelor', 'teacher', NULL, NULL);
INSERT INTO university.teachers (id, department_id, salary, degree, position_type, scientific_theme,
                                 scientific_direction)
VALUES (15, 4, 2000, 'candidate', 'professor', 'PI, PID', 'Regulators');


--
-- Name: classes_id_seq; Type: SEQUENCE SET; Schema: university; Owner: -
--

SELECT pg_catalog.setval('university.classes_id_seq', 31, true);


--
-- Name: courses_id_seq; Type: SEQUENCE SET; Schema: university; Owner: -
--

SELECT pg_catalog.setval('university.courses_id_seq', 26, true);


--
-- Name: curriculum_id_seq; Type: SEQUENCE SET; Schema: university; Owner: -
--

SELECT pg_catalog.setval('university.curriculum_id_seq', 32, true);


--
-- Name: defended_degrees_id_seq; Type: SEQUENCE SET; Schema: university; Owner: -
--

SELECT pg_catalog.setval('university.defended_degrees_id_seq', 14, true);


--
-- Name: departments_id_seq; Type: SEQUENCE SET; Schema: university; Owner: -
--

SELECT pg_catalog.setval('university.departments_id_seq', 78, true);


--
-- Name: disciples_id_seq; Type: SEQUENCE SET; Schema: university; Owner: -
--

SELECT pg_catalog.setval('university.disciples_id_seq', 10, true);


--
-- Name: exam_assignments_id_seq; Type: SEQUENCE SET; Schema: university; Owner: -
--

SELECT pg_catalog.setval('university.exam_assignments_id_seq', 1, false);


--
-- Name: exams_id_seq; Type: SEQUENCE SET; Schema: university; Owner: -
--

SELECT pg_catalog.setval('university.exams_id_seq', 16, true);


--
-- Name: faculties_id_seq; Type: SEQUENCE SET; Schema: university; Owner: -
--

SELECT pg_catalog.setval('university.faculties_id_seq', 7, true);


--
-- Name: groups_id_seq; Type: SEQUENCE SET; Schema: university; Owner: -
--

SELECT pg_catalog.setval('university.groups_id_seq', 26, true);


--
-- Name: passes_id_seq; Type: SEQUENCE SET; Schema: university; Owner: -
--

SELECT pg_catalog.setval('university.passes_id_seq', 18, true);


--
-- Name: persons_id_seq; Type: SEQUENCE SET; Schema: university; Owner: -
--

SELECT pg_catalog.setval('university.persons_id_seq', 46, true);


--
-- Name: sessions_id_seq; Type: SEQUENCE SET; Schema: university; Owner: -
--

SELECT pg_catalog.setval('university.sessions_id_seq', 4, true);


--
-- Name: students_record_book_num_seq; Type: SEQUENCE SET; Schema: university; Owner: -
--

SELECT pg_catalog.setval('university.students_record_book_num_seq', 6, true);


--
-- Name: teacher_exams_id_seq; Type: SEQUENCE SET; Schema: university; Owner: -
--

SELECT pg_catalog.setval('university.teacher_exams_id_seq', 12, true);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (id);


--
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (id);


--
-- Name: curriculum curriculum_pkey; Type: CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.curriculum
    ADD CONSTRAINT curriculum_pkey PRIMARY KEY (id);


--
-- Name: defended_degrees defended_degrees_article_title_key; Type: CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.defended_degrees
    ADD CONSTRAINT defended_degrees_article_title_key UNIQUE (article_title);


--
-- Name: defended_degrees defended_degrees_pkey; Type: CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.defended_degrees
    ADD CONSTRAINT defended_degrees_pkey PRIMARY KEY (id);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);


--
-- Name: disciples disciples_pkey; Type: CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.disciples
    ADD CONSTRAINT disciples_pkey PRIMARY KEY (id);


--
-- Name: exam_assignments exam_assignments_pk; Type: CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.exam_assignments
    ADD CONSTRAINT exam_assignments_pk PRIMARY KEY (id);


--
-- Name: exams exams_pkey; Type: CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.exams
    ADD CONSTRAINT exams_pkey PRIMARY KEY (id);


--
-- Name: faculties faculties_faculty_name_key; Type: CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.faculties
    ADD CONSTRAINT faculties_faculty_name_key UNIQUE (faculty_name);


--
-- Name: faculties faculties_pkey; Type: CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.faculties
    ADD CONSTRAINT faculties_pkey PRIMARY KEY (id);


--
-- Name: groups groups_group_number_key; Type: CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.groups
    ADD CONSTRAINT groups_group_number_key UNIQUE (group_number);


--
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: passes passes_pkey; Type: CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.passes
    ADD CONSTRAINT passes_pkey PRIMARY KEY (id);


--
-- Name: persons persons_pkey; Type: CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.persons
    ADD CONSTRAINT persons_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: students students_pkey; Type: CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (id);


--
-- Name: study_assignments study_assignments_pk; Type: CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.study_assignments
    ADD CONSTRAINT study_assignments_pk PRIMARY KEY (disciple_id);


--
-- Name: teacher_exams teacher_exams_pk; Type: CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.teacher_exams
    ADD CONSTRAINT teacher_exams_pk PRIMARY KEY (id);


--
-- Name: teachers teachers_pkey; Type: CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.teachers
    ADD CONSTRAINT teachers_pkey PRIMARY KEY (id);


--
-- Name: classes classes_disciple_id_fkey; Type: FK CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.classes
    ADD CONSTRAINT classes_disciple_id_fkey FOREIGN KEY (disciple_id) REFERENCES university.disciples (id);


--
-- Name: classes classes_teacher_id_fkey; Type: FK CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.classes
    ADD CONSTRAINT classes_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES university.teachers (id);


--
-- Name: courses courses_faculty_id_fkey; Type: FK CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.courses
    ADD CONSTRAINT courses_faculty_id_fkey FOREIGN KEY (faculty_id) REFERENCES university.faculties (id);


--
-- Name: curriculum curriculum_course_id_fkey; Type: FK CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.curriculum
    ADD CONSTRAINT curriculum_course_id_fkey FOREIGN KEY (course_id) REFERENCES university.courses (id);


--
-- Name: curriculum curriculum_disciple_id_fkey; Type: FK CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.curriculum
    ADD CONSTRAINT curriculum_disciple_id_fkey FOREIGN KEY (disciple_id) REFERENCES university.disciples (id);


--
-- Name: defended_degrees defended_degrees_person_id_fkey; Type: FK CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.defended_degrees
    ADD CONSTRAINT defended_degrees_person_id_fkey FOREIGN KEY (person_id) REFERENCES university.persons (id);


--
-- Name: departments departments_faculty_id_fkey; Type: FK CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.departments
    ADD CONSTRAINT departments_faculty_id_fkey FOREIGN KEY (faculty_id) REFERENCES university.faculties (id);


--
-- Name: exam_assignments exam_assignments_disciple_id_fkey; Type: FK CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.exam_assignments
    ADD CONSTRAINT exam_assignments_disciple_id_fkey FOREIGN KEY (disciple_id) REFERENCES university.disciples (id);


--
-- Name: exams exams_disciple_id_fkey; Type: FK CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.exams
    ADD CONSTRAINT exams_disciple_id_fkey FOREIGN KEY (disciple_id) REFERENCES university.disciples (id);


--
-- Name: exams exams_session_id_fkey; Type: FK CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.exams
    ADD CONSTRAINT exams_session_id_fkey FOREIGN KEY (session_id) REFERENCES university.sessions (id);


--
-- Name: faculties faculties_dean_id_fkey; Type: FK CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.faculties
    ADD CONSTRAINT faculties_dean_id_fkey FOREIGN KEY (dean_id) REFERENCES university.persons (id);


--
-- Name: groups groups_course_id_fkey; Type: FK CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.groups
    ADD CONSTRAINT groups_course_id_fkey FOREIGN KEY (course_id) REFERENCES university.courses (id);


--
-- Name: passes passes_exam_id_fkey; Type: FK CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.passes
    ADD CONSTRAINT passes_exam_id_fkey FOREIGN KEY (exam_id) REFERENCES university.exams (id);


--
-- Name: passes passes_teacher_id_fkey; Type: FK CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.passes
    ADD CONSTRAINT passes_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES university.teachers (id);


--
-- Name: students students_group_id_fkey; Type: FK CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.students
    ADD CONSTRAINT students_group_id_fkey FOREIGN KEY (group_id) REFERENCES university.groups (id);


--
-- Name: students students_id_fkey; Type: FK CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.students
    ADD CONSTRAINT students_id_fkey FOREIGN KEY (id) REFERENCES university.persons (id);


--
-- Name: students students_scientific_director_fkey; Type: FK CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.students
    ADD CONSTRAINT students_scientific_director_fkey FOREIGN KEY (scientific_director) REFERENCES university.teachers (id);


--
-- Name: study_assignments study_assignments_department_id_fkey; Type: FK CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.study_assignments
    ADD CONSTRAINT study_assignments_department_id_fkey FOREIGN KEY (department_id) REFERENCES university.departments (id);


--
-- Name: study_assignments study_assignments_disciple_id_fkey; Type: FK CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.study_assignments
    ADD CONSTRAINT study_assignments_disciple_id_fkey FOREIGN KEY (disciple_id) REFERENCES university.disciples (id);


--
-- Name: teacher_exams teacher_exams_exam_id_fkey; Type: FK CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.teacher_exams
    ADD CONSTRAINT teacher_exams_exam_id_fkey FOREIGN KEY (exam_id) REFERENCES university.exams (id);


--
-- Name: teacher_exams teacher_exams_teacher_id_fkey; Type: FK CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.teacher_exams
    ADD CONSTRAINT teacher_exams_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES university.teachers (id);


--
-- Name: teachers teachers_department_id_fkey; Type: FK CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.teachers
    ADD CONSTRAINT teachers_department_id_fkey FOREIGN KEY (department_id) REFERENCES university.departments (id);


--
-- Name: teachers teachers_id_fkey; Type: FK CONSTRAINT; Schema: university; Owner: -
--

ALTER TABLE ONLY university.teachers
    ADD CONSTRAINT teachers_id_fkey FOREIGN KEY (id) REFERENCES university.persons (id);


--
-- Name: DATABASE university; Type: ACL; Schema: -; Owner: -
--

REVOKE CONNECT, TEMPORARY ON DATABASE university FROM PUBLIC;
GRANT TEMPORARY ON DATABASE university TO PUBLIC;
GRANT ALL ON DATABASE university TO university;


--
-- Name: SCHEMA university; Type: ACL; Schema: -; Owner: -
--

GRANT ALL ON SCHEMA university TO university;


--
-- Name: TABLE classes; Type: ACL; Schema: university; Owner: -
--

GRANT ALL ON TABLE university.classes TO university;


--
-- Name: SEQUENCE classes_id_seq; Type: ACL; Schema: university; Owner: -
--

GRANT ALL ON SEQUENCE university.classes_id_seq TO university;


--
-- Name: TABLE courses; Type: ACL; Schema: university; Owner: -
--

GRANT ALL ON TABLE university.courses TO university;


--
-- Name: SEQUENCE courses_id_seq; Type: ACL; Schema: university; Owner: -
--

GRANT ALL ON SEQUENCE university.courses_id_seq TO university;


--
-- Name: TABLE curriculum; Type: ACL; Schema: university; Owner: -
--

GRANT ALL ON TABLE university.curriculum TO university;


--
-- Name: SEQUENCE curriculum_id_seq; Type: ACL; Schema: university; Owner: -
--

GRANT ALL ON SEQUENCE university.curriculum_id_seq TO university;


--
-- Name: TABLE defended_degrees; Type: ACL; Schema: university; Owner: -
--

GRANT ALL ON TABLE university.defended_degrees TO university;


--
-- Name: SEQUENCE defended_degrees_id_seq; Type: ACL; Schema: university; Owner: -
--

GRANT ALL ON SEQUENCE university.defended_degrees_id_seq TO university;


--
-- Name: TABLE departments; Type: ACL; Schema: university; Owner: -
--

GRANT ALL ON TABLE university.departments TO university;


--
-- Name: SEQUENCE departments_id_seq; Type: ACL; Schema: university; Owner: -
--

GRANT ALL ON SEQUENCE university.departments_id_seq TO university;


--
-- Name: TABLE disciples; Type: ACL; Schema: university; Owner: -
--

GRANT ALL ON TABLE university.disciples TO university;


--
-- Name: SEQUENCE disciples_id_seq; Type: ACL; Schema: university; Owner: -
--

GRANT ALL ON SEQUENCE university.disciples_id_seq TO university;


--
-- Name: TABLE exam_assignments; Type: ACL; Schema: university; Owner: -
--

GRANT ALL ON TABLE university.exam_assignments TO university;


--
-- Name: TABLE exams; Type: ACL; Schema: university; Owner: -
--

GRANT ALL ON TABLE university.exams TO university;


--
-- Name: SEQUENCE exams_id_seq; Type: ACL; Schema: university; Owner: -
--

GRANT ALL ON SEQUENCE university.exams_id_seq TO university;


--
-- Name: TABLE faculties; Type: ACL; Schema: university; Owner: -
--

GRANT ALL ON TABLE university.faculties TO university;


--
-- Name: SEQUENCE faculties_id_seq; Type: ACL; Schema: university; Owner: -
--

GRANT ALL ON SEQUENCE university.faculties_id_seq TO university;


--
-- Name: TABLE groups; Type: ACL; Schema: university; Owner: -
--

GRANT ALL ON TABLE university.groups TO university;


--
-- Name: SEQUENCE groups_id_seq; Type: ACL; Schema: university; Owner: -
--

GRANT ALL ON SEQUENCE university.groups_id_seq TO university;


--
-- Name: TABLE passes; Type: ACL; Schema: university; Owner: -
--

GRANT ALL ON TABLE university.passes TO university;


--
-- Name: SEQUENCE passes_id_seq; Type: ACL; Schema: university; Owner: -
--

GRANT ALL ON SEQUENCE university.passes_id_seq TO university;


--
-- Name: TABLE persons; Type: ACL; Schema: university; Owner: -
--

GRANT ALL ON TABLE university.persons TO university;


--
-- Name: SEQUENCE persons_id_seq; Type: ACL; Schema: university; Owner: -
--

GRANT ALL ON SEQUENCE university.persons_id_seq TO university;


--
-- Name: TABLE sessions; Type: ACL; Schema: university; Owner: -
--

GRANT ALL ON TABLE university.sessions TO university;


--
-- Name: SEQUENCE sessions_id_seq; Type: ACL; Schema: university; Owner: -
--

GRANT ALL ON SEQUENCE university.sessions_id_seq TO university;


--
-- Name: TABLE students; Type: ACL; Schema: university; Owner: -
--

GRANT ALL ON TABLE university.students TO university;


--
-- Name: SEQUENCE students_record_book_num_seq; Type: ACL; Schema: university; Owner: -
--

GRANT ALL ON SEQUENCE university.students_record_book_num_seq TO university;


--
-- Name: TABLE study_assignments; Type: ACL; Schema: university; Owner: -
--

GRANT ALL ON TABLE university.study_assignments TO university;


--
-- Name: TABLE teacher_exams; Type: ACL; Schema: university; Owner: -
--

GRANT ALL ON TABLE university.teacher_exams TO university;


--
-- Name: SEQUENCE teacher_exams_id_seq; Type: ACL; Schema: university; Owner: -
--

GRANT ALL ON SEQUENCE university.teacher_exams_id_seq TO university;


--
-- Name: TABLE teachers; Type: ACL; Schema: university; Owner: -
--

GRANT ALL ON TABLE university.teachers TO university;


--
-- PostgreSQL database dump complete
--

