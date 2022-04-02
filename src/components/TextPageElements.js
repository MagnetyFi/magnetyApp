import styled from "styled-components";
import { Link } from "react-router-dom";

export const Container = styled.div`
    position: relative;
    bottom: 0;
    left: 0;
    right: 0;
    overflow: hidden;
    min-height: 100vh;
    
    background: linear-gradient(
        108deg,
        rgba(90, 94, 92, 1) 0%,
        rgba(162, 165, 164, 1) 100%
    );
    padding-top: 32px;

    @media screen and (max-width: 768px) {
        position: relative;
        min-height: 100vh;
        width: 100%;
        padding-top: 22px;
    }
`

export const Icon = styled(Link)`
    margin-left: 64px;
    text-decoration: none;
    color: #fff;
    font-weight: 700;
    font-size: 32px;
    cursor: pointer;
    font-weight: bold;
    font-style: italic;
    text-transform: uppercase;
    text-shadow: 2px 0 0 #000, -2px 0 0 #000, 0 2px 0 #000, 0 -2px 0 #000, 1px 1px #000, -1px -1px 0 #000, 1px -1px 0 #000, -1px 1px 0 #000;

    @media screen and (max-width: 768px) {
        margin-left: 33px;
    }
`

export const TextPageWrap = styled.div`
    
    display: flex;
    flex-direction: column;
    align-items: center;

    @media screen and (max-width: 768px) {
        height: 100%;
    }
`

export const TextPageDiv = styled.div`
    background: #010101;
    width: 1100px;

    display: grid;
    margin: 30px;
    padding: 32px 32px 32px 32px;
    border-radius: 4px;
    box-shadow: 0 1px 3px rgba(0,0,0,0.9);

    @media screen and (max-width: 768px) {
        width: 90%;
        margin: 30px 0px 10px 0px;
        height: 100%;
        display: relative;
        text-align: center;
        border-radius: 6px;
    }
`

export const TextPageTitle = styled.h3`
    color: #000;
    font-size: 1.8rem;
    font-weight: bold;
    font-style: italic;
    text-decoration: none;
    text-shadow: 2px 0 0 #fff, -2px 0 0 #fff, 0 2px 0 #fff, 0 -2px 0 #fff, 1px 1px #fff, -1px -1px 0 #fff, 1px -1px 0 #fff, -1px 1px 0 #fff;

    margin-bottom: 20px;
`

export const TextPageSpan = styled.p`
    font-size: 1rem;
    line-height: 1.2rem;
    text-align: justify;
    color: #fff;

    margin-bottom: 10px;
`