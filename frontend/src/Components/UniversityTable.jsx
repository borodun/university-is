import * as React from 'react';
import PropTypes from 'prop-types';
import Box from '@mui/material/Box';
import {DataGrid, GridToolbar} from '@mui/x-data-grid';
import {useDemoData} from '@mui/x-data-grid-generator';
import KeyboardArrowRightIcon from '@mui/icons-material/KeyboardArrowRight';
import {styled} from '@mui/material/styles';
import FormControl from '@mui/material/FormControl';
import FormGroup from '@mui/material/FormGroup';
import Button from '@mui/material/Button';
import InputLabel from '@mui/material/InputLabel';
import MenuItem from '@mui/material/MenuItem';
import Select from '@mui/material/Select';
import axios from "axios";

const AntDesignStyledDataGrid = styled(DataGrid)(({theme}) => ({
    border: `1px solid ${theme.palette.mode === 'light' ? '#f0f0f0' : '#303030'}`,
    color:
        theme.palette.mode === 'light' ? 'rgba(0,0,0,.85)' : 'rgba(255,255,255,0.85)',
    fontFamily: [
        '-apple-system',
        'BlinkMacSystemFont',
        '"Segoe UI"',
        'Roboto',
        '"Helvetica Neue"',
        'Arial',
        'sans-serif',
        '"Apple Color Emoji"',
        '"Segoe UI Emoji"',
        '"Segoe UI Symbol"',
    ].join(','),
    WebkitFontSmoothing: 'auto',
    letterSpacing: 'normal',
    '& .MuiDataGrid-columnsContainer': {
        backgroundColor: theme.palette.mode === 'light' ? '#fafafa' : '#1d1d1d',
    },
    '& .MuiDataGrid-iconSeparator': {
        display: 'none',
    },
    '& .MuiDataGrid-columnHeader, .MuiDataGrid-cell': {
        borderRight: `1px solid ${
            theme.palette.mode === 'light' ? '#f0f0f0' : '#303030'
        }`,
    },
    '& .MuiDataGrid-columnsContainer, .MuiDataGrid-cell': {
        borderBottom: `1px solid ${
            theme.palette.mode === 'light' ? '#f0f0f0' : '#303030'
        }`,
    },
    '& .MuiDataGrid-cell': {
        color:
            theme.palette.mode === 'light' ? 'rgba(0,0,0,.85)' : 'rgba(255,255,255,0.85)',
        fontFamily: [
            '-apple-system',
            'BlinkMacSystemFont',
            '"Segoe UI"',
            'Roboto',
            '"Helvetica Neue"',
            'Arial',
            'sans-serif',
            '"Apple Color Emoji"',
            '"Segoe UI Emoji"',
            '"Segoe UI Symbol"',
        ].join(','),
        WebkitFontSmoothing: 'auto',
        letterSpacing: 'normal',
        '& .MuiDataGrid-columnsContainer': {
            backgroundColor: theme.palette.mode === 'light' ? '#fafafa' : '#1d1d1d',
        },
        '& .MuiDataGrid-iconSeparator': {
            display: 'none',
        },
        '& .MuiDataGrid-colCell, .MuiDataGrid-cell': {
            borderRight: `1px solid ${
                theme.palette.mode === 'light' ? '#f0f0f0' : '#303030'
            }`,
        },
        '& .MuiDataGrid-columnsContainer, .MuiDataGrid-cell': {
            borderBottom: `1px solid ${
                theme.palette.mode === 'light' ? '#f0f0f0' : '#303030'
            }`,
        },
        '& .MuiDataGrid-cell': {
            color:
                theme.palette.mode === 'light'
                    ? 'rgba(0,0,0,.85)'
                    : 'rgba(255,255,255,0.65)',
        },
        '& .MuiPaginationItem-root': {
            borderRadius: 0,
        },
        '& .MuiCheckbox-root svg': {
            width: 16,
            height: 16,
            backgroundColor: 'transparent',
            border: `1px solid ${
                theme.palette.mode === 'light' ? '#d9d9d9' : 'rgb(67, 67, 67)'
            }`,
            borderRadius: 2,
        },
        '& .MuiCheckbox-root svg path': {
            display: 'none',
        },
        '& .MuiCheckbox-root.Mui-checked:not(.MuiCheckbox-indeterminate) svg': {
            backgroundColor: '#1890ff',
            borderColor: '#1890ff',
        },
        '& .MuiCheckbox-root.Mui-checked .MuiIconButton-label:after': {
            position: 'absolute',
            display: 'table',
            border: '2px solid #fff',
            borderTop: 0,
            borderLeft: 0,
            transform: 'rotate(45deg) translate(-50%,-50%)',
            opacity: 1,
            transition: 'all .2s cubic-bezier(.12,.4,.29,1.46) .1s',
            content: '""',
            top: '50%',
            left: '39%',
            width: 5.71428571,
            height: 9.14285714,
        },
        '& .MuiCheckbox-root.MuiCheckbox-indeterminate .MuiIconButton-label:after': {
            width: 8,
            height: 8,
            backgroundColor: '#1890ff',
            transform: 'none',
            top: '39%',
            border: 0,
        },
    },
}));

const StyledBox = styled(Box)(({theme}) => ({
    display: 'flex',
    flexDirection: 'column',
    height: 800,
    width: '100%',
    '& .MuiFormGroup-options': {
        alignItems: 'center',
        paddingBottom: theme.spacing(1),
        '& > div': {
            minWidth: 100,
            margin: theme.spacing(2),
            marginLeft: 0,
        },
    },
}));

function SettingsPanel(props) {
    const {onApply, onLoad, size} = props;
    const [sizeState, setSize] = React.useState(size);
    const [selectedPaginationValue, setSelectedPaginationValue] = React.useState(-1);

    const handleSizeChange = React.useCallback((event) => {
        setSize(Number(event.target.value));
    }, []);

    const handlePaginationChange = React.useCallback((event) => {
        setSelectedPaginationValue(event.target.value);
    }, []);

    const handleApplyChanges = React.useCallback(() => {
        onApply({
            size: sizeState,
            pagesize: selectedPaginationValue,
        });
    }, [sizeState, selectedPaginationValue, onApply]);

    const handleLoadData = React.useCallback(() => {
        onLoad();
    }, [onLoad]);

    return (
        <FormGroup className="MuiFormGroup-options" row>
            <FormControl variant="standard">
                <InputLabel>Rows</InputLabel>
                <Select value={sizeState} onChange={handleSizeChange}>
                    <MenuItem value={100}>100</MenuItem>
                    <MenuItem value={1000}>{Number(1000).toLocaleString()}</MenuItem>
                    <MenuItem value={10000}>{Number(10000).toLocaleString()}</MenuItem>
                    <MenuItem value={100000}>{Number(100000).toLocaleString()}</MenuItem>
                </Select>
            </FormControl>
            <FormControl variant="standard">
                <InputLabel>Page Size</InputLabel>
                <Select value={selectedPaginationValue} onChange={handlePaginationChange}>
                    <MenuItem value={-1}>off</MenuItem>
                    <MenuItem value={0}>auto</MenuItem>
                    <MenuItem value={25}>25</MenuItem>
                    <MenuItem value={100}>100</MenuItem>
                    <MenuItem value={1000}>{Number(1000).toLocaleString()}</MenuItem>
                </Select>
            </FormControl>
            <Button
                size="small"
                variant="outlined"
                color="primary"
                onClick={handleApplyChanges}
            >
                <KeyboardArrowRightIcon fontSize="small"/> Apply
            </Button>
            <Button
                size="small"
                variant="outlined"
                color="primary"
                onClick={handleLoadData}
            >
                <KeyboardArrowRightIcon fontSize="small"/> Load data
            </Button>
        </FormGroup>
    );
}

SettingsPanel.propTypes = {
    onApply: PropTypes.func.isRequired,
    size: PropTypes.number.isRequired,
};

export default function UniversityTable() {
    const [size, setSize] = React.useState(100);
    let {loading, data, setRowLength, loadNewData} = useDemoData({
        dataSet: 'Commodity',
        rowLength: size,
        maxColumns: 40,
        editable: true,
    });

    const getPersons = () => {
        console.log(process.env.REACT_APP_API_URL)
        console.log(data)
        axios.get(`/persons`)
            .then(res => {
                let rows = res.data
                let columns = []
                for(const key in rows[0]){
                    let obj = {"field": key, "headerName": key}
                    if (key === "id") {
                        obj.hide = true
                    }
                    columns.push(obj);
                }
                console.log(columns)
                data = {columns, rows}
            })
    }

    const [pagination, setPagination] = React.useState({
        pagination: false,
        autoPageSize: false,
        pageSize: undefined,
    });

    const handleApplyClick = (settings) => {
        if (size !== settings.size) {
            setSize(settings.size);
        }

        if (size !== settings.size) {
            setRowLength(settings.size);
            loadNewData();
        }

        const newPaginationSettings = {
            pagination: settings.pagesize !== -1,
            autoPageSize: settings.pagesize === 0,
            pageSize: settings.pagesize > 0 ? settings.pagesize : undefined,
        };

        setPagination((currentPaginationSettings) => {
            if (
                currentPaginationSettings.pagination === newPaginationSettings.pagination &&
                currentPaginationSettings.autoPageSize ===
                newPaginationSettings.autoPageSize &&
                currentPaginationSettings.pageSize === newPaginationSettings.pageSize
            ) {
                return currentPaginationSettings;
            }
            return newPaginationSettings;
        });
    };

    const DataGridComponent = AntDesignStyledDataGrid;

    return (
        <StyledBox>
            <SettingsPanel
                onApply={handleApplyClick}
                onLoad={getPersons}
                size={size}
            />
            <DataGridComponent
                {...data}
                components={{
                    Toolbar: GridToolbar,
                }}
                loading={loading}
                checkboxSelection
                disableSelectionOnClick
                rowThreshold={0}
                initialState={{
                    ...data.initialState,
                    pinnedColumns: {left: ['__check__', 'desk']},
                }}
                {...pagination}
            />
        </StyledBox>
    );
}
