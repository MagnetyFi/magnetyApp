import styled from "styled-components";
// import { Link } from "react-router-dom";
import 'bootstrap/dist/css/bootstrap-grid.min.css'; //create display errors
import {
    Row,
    Col
} from 'reactstrap';

export const CardsContainer = styled.div`
    position: relative;
    bottom: 0;
    left: 0;
    right: 0;
    overflow: hidden;
    min-height: 80vh;
    
    background: #F6F7F8;
    padding-top: 32px;

    @media screen and (max-width: 1000px) {
        position: relative;
        min-height: 75vh;
        width: 100%;
        padding-top: 22px;
    }
`

export const FilterBtn = styled.button`
    color: #010101;
    font-size: 32px;
    display: flex;
    align-items: center;
    text-decoration: none;
    padding: 0 1rem;
    height: 100%;
    cursor: pointer;

    &.active {
        border-bottom: 3px solid #e2001a;
    }

    &:hover {
        transition: all 0.2s ease-in-out;
        color: #e2001a;
    }

    background: transparent;
    border: none;
`


export const CardsWrap = styled.div`
    display: flex;
    flex-direction: column;
    align-items: center;

    @media screen and (max-width: 1000px) {
        height: 100%;
    }
`

export const CardsDiv = styled.div`
    width: 1100px;
    text-align: center;
    align-items: center;
    display: grid;
    margin: 30px;
    padding: 32px;

    @media screen and (max-width: 1000px) {
        width: 90%;
        margin: 30px 0px 10px 0px;
        padding: 12px;
        height: 100%;
        display: relative;
    }
`

export const CardsRow = styled.div`
    display: grid;
    grid-auto-columns: minmax(auto, 1fr);
    align-items: center;
    grid-template-areas: 'col1 col2';

    @media screen and (max-width: 1000px) {
        grid-template-areas: 'col1 col1' 'col2 col2';
    }
`

export const CustomRow = styled(Row)`
    text-align: center;
    align-items: center;
    min-width:100%;
`

export const CustomCol = styled(Col)`
    padding: 15px 15px 15px 15px;
    margin-bottom: 0px;
`