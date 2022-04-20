import {FormControl, FormControlLabel, FormLabel, Radio, RadioGroup} from "@mui/material";
import React from "react";


export default function RadioButtonSelect(props) {
    const {id, label, value, setValue, values, labels, ...other} = props;

    return (
        <FormControl>
            <FormLabel id={id}>{label}</FormLabel>
            <RadioGroup
                {...other}
                row
                aria-labelledby={id}
                name={label}
                value={value}
                onChange={(e) => {
                    setValue(e.target.value)
                }}
            >
                {values.map((el, idx) =>
                    <FormControlLabel value={el} control={<Radio/>} label={labels[idx]}/>
                )}
            </RadioGroup>
        </FormControl>
    )
}