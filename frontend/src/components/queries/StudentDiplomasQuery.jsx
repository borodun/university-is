import React, {useEffect} from "react";
import AntGrid from "../AntGrid";
import Typography from "@mui/material/Typography";
import Box from "@mui/material/Box";
import {Button, Stack} from "@mui/material";
import ChipSelect from "./ChipSelect";
import ChipSelectWithID from "./ChipSelectWithID";
import {getTable} from "../utils/GetTable";

export default function StudentDiplomasQuery() {
    const [data, setData] = React.useState({
        rows: [{id: 1}],
        columns: [{field: "id", headerName: "id", hide: true}]
    });

    const [departmentList, setDepartmentList] = React.useState([])
    const [teacherList, setTeacherList] = React.useState([])

    const getData = (urlParams) => {
        getTable(`/students/find-diplomas`, urlParams, data, setData)
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
            teacherList: addBraces(teacherList)
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

    return (
        <Box>
            <Typography variant="h4" noWrap component="div" style={{fontWeight: 300}}>
                Student Diplomas
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

                                    <ChipSelectWithID
                                        label="Teachers"
                                        list={teacherList}
                                        setList={setTeacherList}
                                        array={teachers}
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