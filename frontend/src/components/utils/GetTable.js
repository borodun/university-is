import axios from "axios";

function toCapitalizedWords(name) {
    const words = name.match(/[A-Za-z][a-z]*/g) || [];

    return words.map(capitalize).join(" ");
}

function capitalize(word) {
    return word.charAt(0).toUpperCase() + word.substring(1);
}

export function getTable(url, urlParams, data, setData) {
    axios.get(url, {
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