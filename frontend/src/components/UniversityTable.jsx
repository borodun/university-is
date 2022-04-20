import * as React from 'react';
import {useEffect} from 'react';
import axios from "axios";
import AntGrid from './AntGrid';
import Box from "@mui/material/Box";
import Typography from "@mui/material/Typography";

function toCapitalizedWords(name) {
    const words = name.match(/[A-Za-z][a-z]*/g) || [];

    return words.map(capitalize).join(" ");
}

function capitalize(word) {
    return word.charAt(0).toUpperCase() + word.substring(1);
}

export default function UniversityTable(props) {

    const [data, setData] = React.useState({
        rows: [{id: 1}],
        columns: [{field: "id", headerName: "id", hide: true}]
    })

    const getTable = (table) => {
        console.log(table)
        axios.get(`/` + table)
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
        getTable(props.table.toLowerCase().replace(" ", "-"))
    }, [props.table])

    return (
        <Box>
            <Typography variant="h4" noWrap component="div"  style={{fontWeight: 300}}>
                {props.table}
            </Typography>
            <AntGrid
                data={data}
            />
        </Box>
    );
}
