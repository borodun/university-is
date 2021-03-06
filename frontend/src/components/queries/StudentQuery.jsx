import React, {useEffect} from "react";
import AntGrid from "../AntGrid";
import Typography from "@mui/material/Typography";
import Box from "@mui/material/Box";
import {Button, FormLabel, Slider, Stack} from "@mui/material";
import ChipSelect from "./ChipSelect";
import RadioButtonSelect from "./RadioButtonSelect";
import {getTable} from "../utils/GetTable";

function valuetext(value) {
    return `${value}°C`;
}

export default function StudentQuery() {
    const [data, setData] = React.useState({
        rows: [{id: 1}],
        columns: [{field: "id", headerName: "Id", hide: true}]
    });

    const [groupList, setGroupList] = React.useState([])
    const [courseList, setCourseList] = React.useState([])
    const [facultyList, setFacultyList] = React.useState([])
    const [genderList, setGenderList] = React.useState('')
    const [yearList, setYearList] = React.useState([1990, 2010])
    const [ageList, setAgeList] = React.useState([18, 30])
    const [kidsCheck, setKidsCheck] = React.useState(-1)
    const [scholarshipCheck, setScholarshipCheck] = React.useState(-1)
    const [scholarshipInterval, setScholarshipInterval] = React.useState([1000, 20000])

    const getData = (urlParams) => {
        getTable(`/students/find`, urlParams, data, setData)
    }

    /* eslint-disable react-hooks/exhaustive-deps */
    useEffect(() => {
        getData()
    }, [])

    function addBraces(str) {
        return '{' + str + '}';
    }

    function handleSubmit(e) {
        e.preventDefault();

        let urlParams = {
            groupList: addBraces(groupList),
            courseList: addBraces(courseList),
            facultyList: addBraces(facultyList),
            genderList: addBraces(genderList),
            yearList: addBraces(yearList),
            ageList: addBraces(ageList),
            kidsCheck: kidsCheck,
            scholarshipCheck: scholarshipCheck,
            scholarshipInterval: addBraces(scholarshipInterval)
        }

        console.log(urlParams)
        getData(urlParams)
    }

    const groups = [19205, 18301, 21705, 20132];
    const courses = [1, 2, 3, 4];
    const faculties = [
        "Faculty of Information Technologies",
        "Faculty of Physics",
        "Faculty of Economics",
        "Faculty of Mathematics and Mechanics"
    ]

    const values = [-1, 0, 1];
    const labels = ["Irrelevant", "No", "Yes"];

    const genderValues = ['', 'male', 'female'];
    const genderLabels = ['Irrelevant', 'Male', 'Female'];

    return (
        <Box>
            <Typography variant="h4" noWrap component="div" style={{fontWeight: 300}}>
                Students
            </Typography>
            <Box sx={{display: 'flex'}}>
                <AntGrid data={data}/>

                <Box sx={{paddingLeft: '10px', paddingRight: '10px'}}>
                    <div style={{margin: 1, width: 300}}>
                        <Box sx={{textAlign: 'center'}}>
                            <Typography variant="h4" sx={{display: 'inline'}}>FILTERS</Typography>
                        </Box>

                        <Box sx={{textAlign: 'center'}}>
                            <Box sx={{display: 'flex', alignItems: 'center', justifyContent: 'center'}}>
                                <Stack spacing={1} sx={{width: 300}}>

                                    <ChipSelect
                                        label="Groups"
                                        list={groupList}
                                        setList={setGroupList}
                                        array={groups}
                                    />

                                    <ChipSelect
                                        label="Courses"
                                        list={courseList}
                                        setList={setCourseList}
                                        array={courses}
                                    />

                                    <ChipSelect
                                        label="Faculties"
                                        list={facultyList}
                                        setList={setFacultyList}
                                        array={faculties}
                                    />

                                    <RadioButtonSelect
                                        id="genders"
                                        label="Genders"
                                        value={genderList}
                                        setValue={setGenderList}
                                        values={genderValues}
                                        labels={genderLabels}
                                    />

                                    <FormLabel id="yearInterval">Year of birth range</FormLabel>
                                    <Slider
                                        min={1980}
                                        max={2010}
                                        getAriaLabel={() => 'Year of birth range'}
                                        value={yearList}
                                        onChange={(e) => {
                                            setYearList(e.target.value)
                                        }}
                                        valueLabelDisplay="auto"
                                        getAriaValueText={valuetext}
                                    />

                                    <FormLabel id="ageInterval">Age range</FormLabel>
                                    <Slider
                                        min={10}
                                        max={40}
                                        getAriaLabel={() => 'Age range'}
                                        value={ageList}
                                        onChange={(e) => {
                                            setAgeList(e.target.value)
                                        }}
                                        valueLabelDisplay="auto"
                                        getAriaValueText={valuetext}
                                    />

                                    <RadioButtonSelect
                                        id="kidsCheck"
                                        label="Kids"
                                        value={kidsCheck}
                                        setValue={setKidsCheck}
                                        values={values}
                                        labels={labels}
                                    />

                                    <RadioButtonSelect
                                        id="scholarshipCheck"
                                        label="Scholarship"
                                        value={scholarshipCheck}
                                        setValue={setScholarshipCheck}
                                        values={values}
                                        labels={labels}
                                    />

                                    <FormLabel id="scholarshipInterval">Scholarship range</FormLabel>
                                    <Slider
                                        min={0}
                                        max={50000}
                                        getAriaLabel={() => 'Scholarship range'}
                                        value={scholarshipInterval}
                                        onChange={(e) => {
                                            setScholarshipInterval(e.target.value)
                                        }}
                                        valueLabelDisplay="auto"
                                        getAriaValueText={valuetext}
                                        disabled={scholarshipCheck <= 0}
                                    />

                                    <Button variant="contained" onClick={handleSubmit}>Apply</Button>

                                </Stack>
                            </Box>
                        </Box>
                    </div>
                </Box>
            </Box>
        </Box>
    )
}