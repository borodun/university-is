import React, {useEffect} from "react";
import AntGrid from "../AntGrid";
import Typography from "@mui/material/Typography";
import Box from "@mui/material/Box";
import {Button, Stack, TextField} from "@mui/material";
import ChipSelect from "./ChipSelect";
import RadioButtonSelect from "./RadioButtonSelect";
import ChipSelectWithID from "./ChipSelectWithID";
import {AdapterDateFns} from '@mui/x-date-pickers/AdapterDateFns';
import {LocalizationProvider} from '@mui/x-date-pickers/LocalizationProvider';
import {DatePicker} from "@mui/x-date-pickers";
import {getTable} from "../utils/GetTable";

export default function StudentMarksQuery() {
    const [data, setData] = React.useState({
        rows: [{id: 1}],
        columns: [{field: "id", headerName: "id", hide: true}]
    });

    const [groupList, setGroupList] = React.useState([])
    const [courseList, setCourseList] = React.useState([])
    const [facultyList, setFacultyList] = React.useState([])
    const [teacherList, setTeacherList] = React.useState([])
    const [markList, setMarkList] = React.useState([])
    const [semesterList, setSemesterList] = React.useState('')
    const [startDate, setStartDate] = React.useState(null)
    const [endDate, setEndDate] = React.useState(null)

    const getData = (urlParams) => {
        getTable(`/students/find-marks`, urlParams, data, setData)
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
            teacherList: addBraces(teacherList),
            markList: addBraces(markList),
            semesterList: addBraces(semesterList),
            dateInterval: addBraces(checkDateArray([startDate, endDate]))
        }

        console.log(urlParams)
        getData(urlParams)
    }

    function checkDateArray(arr) {
        let ret = []
        if (arr[0] !== null) {
            ret.push(arr[0])
        }
        if (arr[1] !== null) {
            ret.push(arr[1])
        }
        return ret
    }

    const groups = [19205, 18301, 21705, 20132];
    const courses = [1, 2, 3, 4];
    const faculties = [
        "Faculty of Information Technologies",
        "Faculty of Physics",
        "Faculty of Economics",
        "Faculty of Mathematics and Mechanics"
    ]
    const teachers = [
        {
            "id": 13,
            "value": "Kugaevskih Alexandr Vladimirovich"
        },
        {
            "id": 14,
            "value": "Bragin Oleg Anatolievich"
        },
        {
            "id": 15,
            "value": "Lomov Andrei Alexandrovich"
        },
        {
            "id": 16,
            "value": "Oparin Grigoriy Andreevich"
        },
        {
            "id": 17,
            "value": "Kireev Sergei Evgenevich"
        },
        {
            "id": 18,
            "value": "Anoikin Denis Alexandrovich"
        },
        {
            "id": 19,
            "value": "Yahyaeva Gulnara Erkinovna"
        },
        {
            "id": 20,
            "value": "Mogilnih Ivan Yurievich"
        },
        {
            "id": 21,
            "value": "Savostyanov Alexandr Nikolaevich"
        },
        {
            "id": 22,
            "value": "Ismagilov Timur Zinferovich"
        },
        {
            "id": 23,
            "value": "Gorkunov Evgeniy Vladimirovich"
        },
        {
            "id": 24,
            "value": "Pishik Boris Nikolaevich"
        },
        {
            "id": 26,
            "value": "Rutman Michail Valerievich"
        },
        {
            "id": 25,
            "value": "Dmitrievskiy Vladimir Sergeevich"
        }
    ]
    const marks = [
        "unsatisfactory",
        "satisfactory",
        "good",
        "excellent",
        "pass",
        "fail"]

    const values = ['', '1', '2'];
    const labels = ["Irrelevant", "Autumn", "Spring"];

    return (
        <Box>
            <Typography variant="h4" noWrap component="div" style={{fontWeight: 300}}>
                Student Marks
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

                                    <ChipSelectWithID
                                        label="Teachers"
                                        list={teacherList}
                                        setList={setTeacherList}
                                        array={teachers}
                                    />

                                    <ChipSelect
                                        label="Marks"
                                        list={markList}
                                        setList={setMarkList}
                                        array={marks}
                                    />

                                    <RadioButtonSelect
                                        id="semester"
                                        label="Semester"
                                        value={semesterList}
                                        setValue={setSemesterList}
                                        values={values}
                                        labels={labels}
                                    />

                                    <LocalizationProvider dateAdapter={AdapterDateFns}>
                                        <DatePicker
                                            label="Start date"
                                            value={startDate}
                                            inputFormat="yyyy-mm-dd"
                                            mask="____-__-__"
                                            onChange={(value) => {
                                                if (value !== null) {
                                                    setStartDate(new Date(value).toISOString())
                                                } else {
                                                    setStartDate(null)
                                                }
                                            }}
                                            renderInput={(params) => <TextField {...params} />}
                                            clearable={true}
                                        />

                                        <DatePicker
                                            label="End date"
                                            value={endDate}
                                            inputFormat="yyyy-mm-dd"
                                            mask="____-__-__"
                                            onChange={(value) => {
                                                if (value !== null) {
                                                    setEndDate(new Date(value).toISOString())
                                                } else {
                                                    setEndDate(null)
                                                }
                                            }}
                                            renderInput={(params) => <TextField {...params} />}
                                            clearable={true}
                                            showcl
                                        />
                                    </LocalizationProvider>

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