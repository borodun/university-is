import React, {useEffect} from "react";
import AntGrid from "../AntGrid";
import Typography from "@mui/material/Typography";
import Box from "@mui/material/Box";
import {Button, Stack} from "@mui/material";
import ChipSelect from "./ChipSelect";
import {getTable} from "../utils/GetTable";

export default function TeacherDiplomasQuery() {
    const [data, setData] = React.useState({
        rows: [{id: 1}],
        columns: [{field: "id", headerName: "id", hide: true}]
    });

    const [departmentList, setDepartmentList] = React.useState([])
    const [facultyList, setFacultyList] = React.useState([])
    const [positionList, setPositionList] = React.useState([])

    const getData = (urlParams) => {
        getTable(`/teachers/find-diplomas`, urlParams, data, setData)
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
            departmentList: addBraces(departmentList),
            facultyList: addBraces(facultyList),
            positionList: addBraces(positionList),
        }

        console.log(urlParams)
        getData(urlParams)
    }

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
    const positions = [
        'assistant',
        'teacher',
        'senior_teacher',
        'associate_professor',
        'professor'
    ]

    return (
        <Box>
            <Typography variant="h4" noWrap component="div" style={{fontWeight: 300}}>
                Teacher Diplomas
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

                                    <ChipSelect
                                        label="Positions"
                                        list={positionList}
                                        setList={setPositionList}
                                        array={positions}
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