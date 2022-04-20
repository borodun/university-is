import {Chip, FormControl, InputLabel, MenuItem, OutlinedInput, Select, useTheme} from "@mui/material";
import Box from "@mui/material/Box";
import React from "react";

const ITEM_HEIGHT = 48;
const ITEM_PADDING_TOP = 8;
const MenuProps = {
    PaperProps: {
        style: {
            maxHeight: ITEM_HEIGHT * 4.5 + ITEM_PADDING_TOP,
            width: 250,
        },
    },
};

function getStyles(el, array, theme) {
    return {
        fontWeight:
            array.indexOf(el) === -1
                ? theme.typography.fontWeightRegular
                : theme.typography.fontWeightMedium,
    };
}

export default function ChipSelect(props) {
    const {id, label, list, setList, array, ...other} = props;

    const theme = useTheme();

    return (
        <FormControl>
            <InputLabel id={label}>{label}</InputLabel>
            <Select
                {...other}
                labelId={label}
                id={label}
                multiple
                value={list}
                onChange={(e) => {
                    setList(e.target.value)
                }}
                input={<OutlinedInput id={label} label={label}/>}
                renderValue={(selected) => (
                    <Box sx={{display: 'flex', flexWrap: 'wrap', gap: 0.5}}>
                        {selected.map((value) => (
                            <Chip key={value} label={value}/>
                        ))}
                    </Box>
                )}
                MenuProps={MenuProps}
            >
                {array.map((group) => (
                    <MenuItem
                        key={group}
                        value={group}
                        style={getStyles(group, list, theme)}
                    >
                        {group}
                    </MenuItem>
                ))}
            </Select>
        </FormControl>
    )
}