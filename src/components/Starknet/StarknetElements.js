import styled from "styled-components";
import {MdKeyboardArrowRight, MdArrowForward} from 'react-icons/md'
import Rocket from '../../images/starknetrocket.png'

export const HeroContainer = styled.div`
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 60px;
    height: 60vh;
    position: relative;
    z-index: 1;
    margin-top: -100px;
    margin-bottom: 40px;

    @media screen and (max-width: 768px){
        height: 20vh;
        padding: 15px;
    }
}
`

export const HeroContent = styled.div`
    background-image: url(${Rocket});
    background-size: cover;
    border-radius: 60px;
    width: 100%;
    display: flex;
    flex-direction: column;
    padding: 10% 2%;

    @media screen and (max-width: 768px){
        border-radius: 20px;
        background-size: 200%;
        background-repeat: no-repeat;
    }
`

export const T1 = styled.span`
    font-weight: 700;
    font-size: 40px;
    line-height: 48px;

    color: #FFFFFF;

    @media screen and (max-width: 768px){
        font-size: 20px;
        line-height: 25px;
    }
`

export const T2 = styled.span`
    font-weight: 700;
    font-size: 64px;
    line-height: 77px;

    color: #FFFFFF;

    @media screen and (max-width: 768px){
        font-size: 30px;
        line-height: 35px;
    }
`

export const T3 = styled.span`
    font-weight: 700;
    font-size: 32px;
    line-height: 39px;

    color: #FFFFFF;

    @media screen and (max-width: 768px){
        font-size: 17px;
        line-height: 23px;
    }
`
