import * as React from 'react';
import PropTypes from 'prop-types';
import AppBar from '@mui/material/AppBar';
import Tabs from '@mui/material/Tabs';
import Tab from '@mui/material/Tab';
import Typography from '@mui/material/Typography';
import Box from '@mui/material/Box';
import TableDrawer from "./TableDrawer";
import Toolbar from "@mui/material/Toolbar";
import QueryDrawer from "./QueryDrawer";

function TabPanel(props) {
    const {children, value, index, ...other} = props;

    return (
        <div
            role="tabpanel"
            hidden={value !== index}
            id={`full-width-tabpanel-${index}`}
            aria-labelledby={`full-width-tab-${index}`}
            {...other}
        >
            {value === index && (
                <Box sx={{p: 3}}>
                    <Typography>{children}</Typography>
                </Box>
            )}
        </div>
    );
}

TabPanel.propTypes = {
    children: PropTypes.node,
    index: PropTypes.number.isRequired,
    value: PropTypes.number.isRequired,
};

function a11yProps(index) {
    return {
        id: `full-width-tab-${index}`,
        'aria-controls': `full-width-tabpanel-${index}`,
    };
}

export default function TopMenu() {
    const [value, setValue] = React.useState(0);

    const handleChange = (event, newValue) => {
        setValue(newValue);
    };

    return (
        <Box sx={{bgcolor: 'background.paper', width: '100%'}}>
            <AppBar position="static">
                <Toolbar style={{justifyContent: "center", minHeight: 32}}>
                    <Typography variant="h6" noWrap component="div" align="center" style={{fontWeight: 600}}>
                        UNIVERSITY INFORMATION SYSTEM
                    </Typography>
                </Toolbar>
                <Tabs
                    value={value}
                    onChange={handleChange}
                    indicatorColor="secondary"
                    textColor="inherit"
                    variant="fullWidth"
                    aria-label="full width tabs example"
                    style={{minHeight: 32}}
                >
                    <Tab label="Tables" {...a11yProps(0)} />
                    <Tab label="Queries" {...a11yProps(1)} />
                </Tabs>
            </AppBar>


            <TabPanel value={value} index={0}>
                <TableDrawer/>
            </TabPanel>
            <TabPanel value={value} index={1}>
                <QueryDrawer/>
            </TabPanel>

        </Box>
    );
}