import * as React from 'react';
import {styled} from '@mui/material/styles';
import Box from '@mui/material/Box';
import MuiDrawer from '@mui/material/Drawer';
import List from '@mui/material/List';
import CssBaseline from '@mui/material/CssBaseline';
import Divider from '@mui/material/Divider';
import IconButton from '@mui/material/IconButton';
import ChevronLeftIcon from '@mui/icons-material/ChevronLeft';
import ChevronRightIcon from '@mui/icons-material/ChevronRight';
import ListItemButton from '@mui/material/ListItemButton';
import ListItemIcon from '@mui/material/ListItemIcon';
import ListItemText from '@mui/material/ListItemText';

import PersonIcon from '@mui/icons-material/Person';
import MeetingRoomIcon from '@mui/icons-material/MeetingRoom';
import SelfImprovementIcon from '@mui/icons-material/SelfImprovement';

import StudentQuery from "./queries/StudentQuery";
import StudentSessionsQuery from "./queries/StudentSessionsQuery";
import StudentMarksQuery from "./queries/StudentMarksQuery";
import StudentExamsQuery from "./queries/StudentExamsQuery";
import StudentDiplomasQuery from "./queries/StudentDiplomasQuery";
import DepartmentQuery from "./queries/DepartmentQuery";
import TeacherQuery from "./queries/TeacherQuery";
import TeacherWorkloadsQuery from "./queries/TeacherWorkloadsQuery";
import TeacherGroupsQuery from "./queries/TeacherGroupsQuery";
import TeacherExamsQuery from "./queries/TeacherExamsQuery";
import TeacherDiplomasQuery from "./queries/TeacherDiplomasQuery";
import TeacherClassesQuery from "./queries/TeacherClassesQuery";
import TeacherArticlesQuery from "./queries/TeacherArticlesQuery";

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

export default function QueryDrawer() {
    const [open, setOpen] = React.useState(false);
    const [queryName, setQueryName] = React.useState('Students');

    const elements = {
        Students: {icon: <PersonIcon/>, query: <StudentQuery/>},
        "Student Sessions": {icon: <PersonIcon/>, query: <StudentSessionsQuery/>},
        "Student Marks": {icon: <PersonIcon/>, query: <StudentMarksQuery/>},
        "Student Exams": {icon: <PersonIcon/>, query: <StudentExamsQuery/>},
        "Student Diplomas": {icon: <PersonIcon/>, query: <StudentDiplomasQuery/>},
        Departments: {icon: <MeetingRoomIcon/>, query: <DepartmentQuery/>},
        Teachers: {icon: <SelfImprovementIcon/>, query: <TeacherQuery/>},
        "Teachers Workloads": {icon: <SelfImprovementIcon/>, query: <TeacherWorkloadsQuery/>},
        "Teachers Groups": {icon: <SelfImprovementIcon/>, query: <TeacherGroupsQuery/>},
        "Teachers Exams": {icon: <SelfImprovementIcon/>, query: <TeacherExamsQuery/>},
        "Teachers Diplomas": {icon: <SelfImprovementIcon/>, query: <TeacherDiplomasQuery/>},
        "Teachers Classes": {icon: <SelfImprovementIcon/>, query: <TeacherClassesQuery/>},
        "Teachers Articels": {icon: <SelfImprovementIcon/>, query: <TeacherArticlesQuery/>},
    }

    const getQueryNames = () => {
        let fields = []
        for (const key in elements) {
            fields.push(key);
        }
        return fields
    }

    const handleTableChange = (name) => {
        setQueryName(name);
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
                    {getQueryNames().map((text, index) => (
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
                                {elements[text].icon}
                            </ListItemIcon>
                            <ListItemText primary={text} sx={{opacity: open ? 1 : 0}}/>
                        </ListItemButton>
                    ))}
                </List>
                <Divider/>
            </Drawer>
            <Box component="main" sx={{flexGrow: 1, p: 0}}>
                {elements[queryName].query}
            </Box>
        </Box>
    );
}