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

export default function DepartmentQuery() {
    const [data, setData] = React.useState({
        rows: [{id: 1}],
        columns: [{field: "id", headerName: "id", hide: true}]
    });

    const [groupList, setGroupList] = React.useState([])
    const [courseList, setCourseList] = React.useState([])
    const [facultyList, setFacultyList] = React.useState([])
    const [yearList, setYearList] = React.useState([2019, 2021])
    const [semesterList, setSemesterList] = React.useState('')

    const getData = (urlParams) => {
        getTable(`/departments/find`, urlParams, data, setData)
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
            yearList: addBraces(yearList),
            semesterList: addBraces(semesterList)
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

    const values = [1, 2];
    const labels = ["Autumn", "Spring"];

    return (
        <Box>
            <Typography variant="h4" noWrap component="div" style={{fontWeight: 300}}>
                Departments
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

                                    <FormLabel id="yearInterval">Year of study</FormLabel>
                                    <Slider
                                        min={2018}
                                        max={2022}
                                        getAriaLabel={() => 'Year of study'}
                                        value={yearList}
                                        onChange={(e) => {
                                            setYearList(e.target.value)
                                        }}
                                        valueLabelDisplay="auto"
                                        getAriaValueText={valuetext}
                                    />

                                    <RadioButtonSelect
                                        id="semester"
                                        label="Semester"
                                        value={semesterList}
                                        setValue={setSemesterList}
                                        values={values}
                                        labels={labels}
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