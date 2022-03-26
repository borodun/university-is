import React from 'react';
import ReactDOM from 'react-dom';
import "./axios";
import MiniDrawer from "./Components/MiniDrawer";
import {StyledEngineProvider} from "@mui/material/styles";

ReactDOM.render(
    <StyledEngineProvider>
        <MiniDrawer/>
    </StyledEngineProvider>,
    document.getElementById('root')
);

