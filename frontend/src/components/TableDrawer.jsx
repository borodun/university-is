import * as React from 'react';
import {styled} from '@mui/material/styles';
import Box from '@mui/material/Box';
import MuiDrawer from '@mui/material/Drawer';
import List from '@mui/material/List';
import CssBaseline from '@mui/material/CssBaseline';
import Divider from '@mui/material/Divider';
import IconButton from '@mui/material/IconButton';
import UniversityTable from "./UniversityTable";
import ChevronLeftIcon from '@mui/icons-material/ChevronLeft';
import ChevronRightIcon from '@mui/icons-material/ChevronRight';
import ListItemButton from '@mui/material/ListItemButton';
import ListItemIcon from '@mui/material/ListItemIcon';
import ListItemText from '@mui/material/ListItemText';

import PersonIcon from '@mui/icons-material/Person';
import SchoolIcon from '@mui/icons-material/School';
import SelfImprovementIcon from '@mui/icons-material/SelfImprovement';
import AssignmentIcon from '@mui/icons-material/Assignment';
import DateRangeIcon from '@mui/icons-material/DateRange';
import AssignmentTurnedInIcon from '@mui/icons-material/AssignmentTurnedIn';
import GroupsIcon from '@mui/icons-material/Groups';
import CameraIndoorIcon from '@mui/icons-material/CameraIndoor';
import NoteAltIcon from '@mui/icons-material/NoteAlt';
import AssignmentLateIcon from '@mui/icons-material/AssignmentLate';
import SubjectIcon from '@mui/icons-material/Subject';
import MeetingRoomIcon from '@mui/icons-material/MeetingRoom';
import GppGoodIcon from '@mui/icons-material/GppGood';
import EventNoteIcon from '@mui/icons-material/EventNote';
import NumbersIcon from '@mui/icons-material/Numbers';
import ClassIcon from '@mui/icons-material/Class';
import CoPresentIcon from '@mui/icons-material/CoPresent';

const drawerWidth = 250;

const openedMixin = (theme) => ({
    width: drawerWidth,
    transition: theme.transitions.create('width', {
        easing: theme.transitions.easing.sharp,
        duration: theme.transitions.duration.enteringScreen,
    }),
    overflowX: 'hidden',
});

const closedMixin = (theme) => ({
    transition: theme.transitions.create('width', {
        easing: theme.transitions.easing.sharp,
        duration: theme.transitions.duration.leavingScreen,
    }),
    overflowX: 'hidden',
    width: `calc(${theme.spacing(7)} + 1px)`,
    [theme.breakpoints.up('sm')]: {
        width: `calc(${theme.spacing(8)} + 1px)`,
    },
});

const DrawerHeader = styled('div')(({theme}) => ({
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'flex-end',
    padding: theme.spacing(0, 1),
    // necessary for content to be below app bar
    ...theme.mixins.toolbar,
}));

const Drawer = styled(MuiDrawer, {shouldForwardProp: (prop) => prop !== 'open'})(
    ({theme, open}) => ({
        width: drawerWidth,
        flexShrink: 0,
        whiteSpace: 'nowrap',
        boxSizing: 'border-box',
        ...(open && {
            ...openedMixin(theme),
            '& .MuiDrawer-paper': openedMixin(theme),
        }),
        ...(!open && {
            ...closedMixin(theme),
            '& .MuiDrawer-paper': closedMixin(theme),
        }),
    }),
);

export default function TableDrawer() {
    const [open, setOpen] = React.useState(false);
    const [tableName, setTableName] = React.useState('Persons');

    const iconDict = {
        Persons: <PersonIcon/>,
        Students: <SchoolIcon/>,
        Teachers: <SelfImprovementIcon/>,
        "Study Assignments": <AssignmentIcon/>,
        Sessions: <DateRangeIcon/>,
        Passes: <AssignmentTurnedInIcon/>,
        Groups: <GroupsIcon/>,
        Faculties: <CameraIndoorIcon/>,
        Exams: <NoteAltIcon/>,
        "Exam Assignments": <AssignmentLateIcon/>,
        Disciple: <SubjectIcon/>,
        Departments: <MeetingRoomIcon/>,
        "Defended Degrees": <GppGoodIcon/>,
        Curriculum: <EventNoteIcon/>,
        Courses: <NumbersIcon/>,
        Classes: <ClassIcon/>,
        "Teacher Exams": <CoPresentIcon/>
    }

    const getTableNames = () => {
        let fields = []
        for (const key in iconDict) {
            fields.push(key);
        }
        return fields
    }

    const handleTableChange = (name) => {
        setTableName(name);
    };

    const handleDrawerToggle = () => {
        setOpen(!open);
    };

    return (
        <Box sx={{display: 'flex'}}>
            <CssBaseline/>
            <Drawer variant="permanent" open={open}>
                <DrawerHeader>
                    <IconButton onClick={handleDrawerToggle}>
                        {open ? "Close" : ""}
                        {open ? <ChevronLeftIcon/> : <ChevronRightIcon/>}
                    </IconButton>
                </DrawerHeader>
                <Divider/>
                <List>
                    {getTableNames().map((text, index) => (
                        <ListItemButton
                            key={text}
                            sx={{
                                minHeight: 0,
                                justifyContent: open ? 'initial' : 'center',
                                px: 2.5,
                                height: 38
                            }}
                            onClick={() => handleTableChange(text)}
                        >
                            <ListItemIcon
                                sx={{
                                    minWidth: 0,
                                    minHeight: 0,
                                    mr: open ? 3 : 'auto',
                                    justifyContent: 'center',
                                }}
                            >
                                {iconDict[text]}
                            </ListItemIcon>
                            <ListItemText primary={text} sx={{opacity: open ? 1 : 0}}/>
                        </ListItemButton>
                    ))}
                </List>
                <Divider/>
            </Drawer>
            <Box component="main" sx={{flexGrow: 1, p: 0}}>
                <UniversityTable table={tableName}/>
            </Box>
        </Box>
    );
}