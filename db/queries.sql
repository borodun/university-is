-- Utility functions

CREATE OR REPLACE FUNCTION array_max(arr INTEGER[])
    RETURNS INTEGER
    LANGUAGE SQL
AS
$$
SELECT max(elements)
FROM unnest(arr) elements;
$$;

CREATE OR REPLACE FUNCTION array_min(arr INTEGER[])
    RETURNS INTEGER
    LANGUAGE SQL
AS
$$
SELECT min(elements)
FROM unnest(arr) elements;
$$;

--
-- QUERY 1
-- Find particular students
--

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
        SELECT s.id,
               s.record_book_num,
               p.second_name,
               p.first_name,
               p.last_name,
               p.date_of_birth,
               extract(year from age(p.date_of_birth))::INTEGER as age,
               g.group_number,
               c.course_number,
               f.faculty_name,
               p.kids,
               s.scholarship
        FROM students s
                 INNER JOIN groups g on s.group_id = g.id
                 INNER JOIN courses c on c.id = g.course_id
                 INNER JOIN faculties f on f.id = c.faculty_id
                 INNER JOIN persons p on p.id = s.id
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
          AND ((cardinality(scholarshipInterval) != 0 AND
                s.scholarship BETWEEN array_min(scholarshipInterval) AND array_max(scholarshipInterval)) OR
               cardinality(scholarshipInterval) = 0)
        ORDER BY s.id;
END;
$$ LANGUAGE plpgsql;

--
-- TEST
--

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



