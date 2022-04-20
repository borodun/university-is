import React from 'react';
import ReactDOM from 'react-dom';
import "./axios";
import TopMenu from "./components/TopMenu";
import {StyledEngineProvider} from "@mui/material/styles";

ReactDOM.render(
    <StyledEngineProvider>
        <TopMenu/>
    </StyledEngineProvider>,
    document.getElementById('root')
);

