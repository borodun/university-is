import React, {useEffect} from "react";
import axios from "axios";
import AntGrid from "../AntGrid";
import Typography from "@mui/material/Typography";
import Box from "@mui/material/Box";
import {Button, FormLabel, Slider, Stack} from "@mui/material";
import ChipSelect from "./ChipSelect";
import RadioButtonSelect from "./RadioButtonSelect";

function toCapitalizedWords(name) {
    const words = name.match(/[A-Za-z][a-z]*/g) || [];

    return words.map(capitalize).join(" ");
}

function capitalize(word) {
    return word.charAt(0).toUpperCase() + word.substring(1);
}

function valuetext(value) {
    return `${value}°C`;
}

export default function StudentQuery(props) {
    const [data, setData] = React.useState({
        rows: [{id: 1}],
        columns: [{field: "id", headerName: "id"}]
    });

    const [groupList, setGroupList] = React.useState([])
    const [courseList, setCourseList] = React.useState([])
    const [facultyList, setFacultyList] = React.useState([])
    const [genderList, setGenderList] = React.useState([])
    const [yearList, setYearList] = React.useState([1990, 2010])
    const [ageList, setAgeList] = React.useState([18, 30])
    const [kidsCheck, setKidsCheck] = React.useState(-1)
    const [scholarshipCheck, setScholarshipCheck] = React.useState(-1)
    const [scholarshipInterval, setScholarshipInterval] = React.useState([1000, 20000])

    const getData = (urlParams) => {
        axios.get(`/students/find`, {
            params: {
                ...urlParams
            }
        })
            .then(res => {
                let rows = res.data
                let columns = []
                let rawColumns = []
                for (const key in rows[0]) {
                    let obj = {field: key, headerName: toCapitalizedWords(key)}
                    columns.push(obj);
                    rawColumns.push(key);
                }
                if (!rawColumns.includes("id")) {
                    for (const key in rows) {
                        rows[key].id = key
                    }
                }
                setData({columns, rows})
            }).catch((e) => {
            console.log(e)
        })
    }

    useEffect(() => {
        getData()
    }, [props.query])

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
    const genders = [
        'male',
        'female'
    ]
    const values = [-1, 0, 1];
    const labels = ["doesn't matter", "no", "yes"];

    return (
        <Box>
            <Typography variant="h4" noWrap component="div" style={{fontWeight: 300}}>
                {props.query}
            </Typography>
            <Box sx={{display: 'flex'}}>
                <AntGrid
                    data={data}
                />

                <Box sx={{paddingLeft: '10px', paddingRight: '10px'}}>
                    <div style={{m: 1, width: 300}}>
                        <Box sx={{textAlign: 'center'}}>
                            <Typography variant="h4" sx={{display: 'inline'}}>FILTERS</Typography>
                        </Box>

                        <Box sx={{textAlign: 'center', pt: 2}}>
                            <Box sx={{display: 'flex', alignItems: 'center', justifyContent: 'center'}}>
                                <Stack spacing={1}>

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

                                    <ChipSelect
                                        label="Genders"
                                        list={genderList}
                                        setList={setGenderList}
                                        array={genders}
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