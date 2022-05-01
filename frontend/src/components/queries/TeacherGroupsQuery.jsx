import React, {useEffect} from "react";
import AntGrid from "../AntGrid";
import Typography from "@mui/material/Typography";
import Box from "@mui/material/Box";
import {Button, Stack} from "@mui/material";
import ChipSelect from "./ChipSelect";
import {getTable} from "../utils/GetTable";

export default function TeacherGroupsQuery() {
    const [data, setData] = React.useState({
        rows: [{id: 1}],
        columns: [{field: "id", headerName: "id", hide: true}]
    });

    const [discipleList, setDiscipleList] = React.useState([])
    const [groupList, setGroupList] = React.useState([])
    const [courseList, setCourseList] = React.useState([])
    const [departmentList, setDepartmentList] = React.useState([])
    const [facultyList, setFacultyList] = React.useState([])

    const getData = (urlParams) => {
        getTable(`/teachers/find-groups`, urlParams, data, setData)
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
            discipleList: addBraces(discipleList),
            groupList: addBraces(groupList),
            courseList: addBraces(courseList),
            departmentList: addBraces(departmentList),
            facultyList: addBraces(facultyList),
        }

        console.log(urlParams)
        getData(urlParams)
    }

    const disciples = [
        "TPNS",
        "LMIZ",
        "Measuring practice",
        "Controlling theory",
        "EPSMM",
        "UPPRPO",
        "Code theory",
        "Databases",
        "Law",
        "Philosophy"
    ]
    const groups = [19205, 18301, 21705, 20132];
    const courses = [1, 2, 3, 4];
    const departments = [
        "Department of Computer Technologies",
        "Department of Discrete Analysis and Operations Research",
        "Department of Informatics Systems",
        "Department of General Informatics",
        "Department of Math",
        "Department of General Physics"
    ]
    const faculties = [
        "Faculty of Information Technologies",
        "Faculty of Physics",
        "Faculty of Economics",
        "Faculty of Mathematics and Mechanics"
    ]

    return (
        <Box>
            <Typography variant="h4" noWrap component="div" style={{fontWeight: 300}}>
                Teacher Groups
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
                                        label="Disciples"
                                        list={discipleList}
                                        setList={setDiscipleList}
                                        array={disciples}
                                    />

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
                                        label="Departments"
                                        list={departmentList}
                                        setList={setDepartmentList}
                                        array={departments}
                                    />

                                    <ChipSelect
                                        label="Faculties"
                                        list={facultyList}
                                        setList={setFacultyList}
                                        array={faculties}
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