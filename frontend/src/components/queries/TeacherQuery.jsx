import React, {useEffect} from "react";
import AntGrid from "../AntGrid";
import Typography from "@mui/material/Typography";
import Box from "@mui/material/Box";
import {Button, FormLabel, Slider, Stack, TextField} from "@mui/material";
import ChipSelect from "./ChipSelect";
import RadioButtonSelect from "./RadioButtonSelect";
import {AdapterDateFns} from "@mui/x-date-pickers/AdapterDateFns";
import {DatePicker} from "@mui/x-date-pickers";
import {LocalizationProvider} from "@mui/x-date-pickers/LocalizationProvider";
import {getTable} from "../utils/GetTable";

function valuetext(value) {
    return `${value}°C`;
}

export default function TeacherQuery() {
    const [data, setData] = React.useState({
        rows: [{id: 1}],
        columns: [{field: "id", headerName: "id", hide: true}]
    });

    const [departmentList, setDepartmentList] = React.useState([])
    const [facultyList, setFacultyList] = React.useState([])
    const [positionList, setPositionList] = React.useState([])
    const [genderList, setGenderList] = React.useState('')
    const [yearList, setYearList] = React.useState([1970, 1990])
    const [ageList, setAgeList] = React.useState([30, 60])
    const [kidsCheck, setKidsCheck] = React.useState(-1)
    const [kidsCount, setKidsCount] = React.useState(1)
    const [salaryInterval, setSalaryInterval] = React.useState([1000, 20000])
    const [degreeList, setDegreeList] = React.useState([])
    const [articleList, setArticleList] = React.useState([])
    const [articleStartDate, setArticleStartDate] = React.useState(null)
    const [articleEndDate, setArticleEndDate] = React.useState(null)

    const getData = (urlParams) => {
        getTable(`/teachers/find`, urlParams, data, setData)
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
            genderList: addBraces(genderList),
            yearList: addBraces(yearList),
            ageList: addBraces(ageList),
            kidsCount: getKidsCount(),
            salaryInterval: addBraces(salaryInterval),
            degreeList: addBraces(degreeList),
            articleList: addBraces(articleList),
            articleDateInterval: addBraces(checkDateArray([articleStartDate, articleEndDate]))
        }

        console.log(urlParams)
        getData(urlParams)
    }

    function getKidsCount() {
        if (kidsCheck <= 0) {
            return -1;
        } else {
            return kidsCount
        }
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
    const positions = [
        'assistant',
        'teacher',
        'senior_teacher',
        'associate_professor',
        'professor'
    ]
    const degrees = [
        'bachelor',
        'master',
        'candidate',
        'doctorate'
    ]
    const articles = [
        'diploma',
        'phd',
        'doctoral'
    ]

    const genderValues = ['', 'male', 'female'];
    const genderLabels = ['Irrelevant', 'Male', 'Female'];

    const values = [-1, 0, 1];
    const labels = ["Irrelevant", "No", "Yes"];

    return (
        <Box>
            <Typography variant="h4" noWrap component="div" style={{fontWeight: 300}}>
                Teachers
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
                                        min={1950}
                                        max={2000}
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
                                        min={20}
                                        max={80}
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

                                    <TextField
                                        id="kidsCount"
                                        label="Kids count"
                                        type="number"
                                        InputLabelProps={{
                                            shrink: true,
                                        }}
                                        value={kidsCount}
                                        onChange={(e) => {
                                            setKidsCount(e.target.value)
                                        }}
                                        disabled={kidsCheck <= 0}
                                    />

                                    <FormLabel id="salaryInterval">Salary range</FormLabel>
                                    <Slider
                                        min={0}
                                        max={100000}
                                        getAriaLabel={() => 'Salary range'}
                                        value={salaryInterval}
                                        onChange={(e) => {
                                            setSalaryInterval(e.target.value)
                                        }}
                                        valueLabelDisplay="auto"
                                        getAriaValueText={valuetext}
                                    />

                                    <ChipSelect
                                        label="Degrees"
                                        list={degreeList}
                                        setList={setDegreeList}
                                        array={degrees}
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