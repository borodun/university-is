import React, {useEffect} from "react";
import AntGrid from "../AntGrid";
import Typography from "@mui/material/Typography";
import Box from "@mui/material/Box";
import {Button, FormLabel, Stack, TextField} from "@mui/material";
import ChipSelect from "./ChipSelect";
import {LocalizationProvider} from "@mui/x-date-pickers/LocalizationProvider";
import {AdapterDateFns} from "@mui/x-date-pickers/AdapterDateFns";
import {DatePicker} from "@mui/x-date-pickers";
import {getTable} from "../utils/GetTable";

export default function TeacherArticlesQuery() {
    const [data, setData] = React.useState({
        rows: [{id: 1}],
        columns: [{field: "id", headerName: "id", hide: true}]
    });

    const [departmentList, setDepartmentList] = React.useState([])
    const [facultyList, setFacultyList] = React.useState([])
    const [articleList, setArticleList] = React.useState([])
    const [articleStartDate, setArticleStartDate] = React.useState(null)
    const [articleEndDate, setArticleEndDate] = React.useState(null)

    const getData = (urlParams) => {
        getTable(`/teachers/find-articles`, urlParams, data, setData)
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
            articleList: addBraces(articleList),
            articleDateInterval: addBraces(checkDateArray([articleStartDate, articleEndDate]))
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
    const articles = [
        'diploma',
        'phd',
        'doctoral'
    ]

    return (
        <Box>
            <Typography variant="h4" noWrap component="div" style={{fontWeight: 300}}>
                Teacher Articles
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
                                        label="Articles"
                                        list={articleList}
                                        setList={setArticleList}
                                        array={articles}
                                    />

                                    <FormLabel id="articleInterval">Article publication date range</FormLabel>
                                    <LocalizationProvider dateAdapter={AdapterDateFns}>
                                        <DatePicker
                                            label="Start date"
                                            value={articleStartDate}
                                            inputFormat="yyyy-mm-dd"
                                            mask="____-__-__"
                                            onChange={(value) => {
                                                if (value !== null) {
                                                    setArticleStartDate(new Date(value).toISOString())
                                                } else {
                                                    setArticleStartDate(null)
                                                }
                                            }}
                                            renderInput={(params) => <TextField {...params} />}
                                            clearable={true}
                                        />

                                        <DatePicker
                                            label="End date"
                                            value={articleEndDate}
                                            inputFormat="yyyy-mm-dd"
                                            mask="____-__-__"
                                            onChange={(value) => {
                                                if (value !== null) {
                                                    setArticleEndDate(new Date(value).toISOString())
                                                } else {
                                                    setArticleEndDate(null)
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