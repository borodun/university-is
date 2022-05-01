import React, {useEffect} from "react";
import AntGrid from "../AntGrid";
import Typography from "@mui/material/Typography";
import Box from "@mui/material/Box";
import {Button, Stack} from "@mui/material";
import ChipSelect from "./ChipSelect";
import {getTable} from "../utils/GetTable";

export default function StudentSessionsQuery() {
    const [data, setData] = React.useState({
        rows: [{id: 1}],
        columns: [{field: "id", headerName: "id", hide: true}]
    });

    const [groupList, setGroupList] = React.useState([])
    const [courseList, setCourseList] = React.useState([])
    const [facultyList, setFacultyList] = React.useState([])
    const [sessionList, setSessionList] = React.useState([])
    const [markList, setMarkList] = React.useState([])

    const getData = (urlParams) => {
        getTable(`/students/find-sessions`, urlParams, data, setData)
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
            sessionList: addBraces(sessionList),
            markList: addBraces(markList),
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
        "Faculty of Mathematics and Mechanics"]
    const sessions = [
        "2022-06-05",
        "2021-01-07",
        "2020-06-06",]
    const marks = [
        "unsatisfactory",
        "satisfactory",
        "good",
        "excellent",
        "pass",
        "fail"]

    return (
        <Box>
            <Typography variant="h4" noWrap component="div" style={{fontWeight: 300}}>
                Student Sessions
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

                                    <ChipSelect
                                        label="Sessions"
                                        list={sessionList}
                                        setList={setSessionList}
                                        array={sessions}
                                    />

                                    <ChipSelect
                                        label="Marks"
                                        list={markList}
                                        setList={setMarkList}
                                        array={marks}
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