import styled from "styled-components";
import Reflexion from '../../images/reflexion.png'

export const HeroContainer = styled.div`
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 0 30px;
    margin-top: 90px;
    height: 80vh;
    position: relative;
    z-index: 1;

    @media screen and (max-width: 768px){
        background-image: url(${Reflexion});
        background-size: 100px;
        background-repeat: no-repeat;
        height: 45vh;
        background-position: 10% 25%;
        padding: 0;
    }
}
`

export const HeroContent = styled.div`
    display: grid;
    grid-auto-columns: 30% 70%;
    align-items: center;
    grid-template-areas: 'col1 col2';

    @media screen and (max-width: 768px) {
        grid-template-areas: 'col1 col1' 'col2 col2';
        grid-auto-columns: 0% 100%;
    }
`

export const Column1 = styled.div`
    margin-bottom: 15px;
    padding: 0 15px;
    grid-area: col1;
    text-align: right;

    @media screen and (max-width: 768px){
        display: none;
    }
`

export const Column2 = styled.div`
    text-align: end;
    margin-bottom: 15px;
    padding: 0 15px;
    grid-area: col2;
`

export const HeroH1 = styled.h1`
    font-weight: 700;
    font-size: 96px;
    line-height: 116px;
    text-align: right;

    background: linear-gradient(89.87deg, #F6643C 14.79%, #E1B85E 55.04%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    text-fill-color: transparent;

    @media screen and (max-width: 768px){
        font-size: 46px;
        line-height: 56px;
    }
`

export const HeroP = styled.p`
    font-weight: 700;
    font-size: 64px;
    line-height: 60px;
    text-align: end;

    color: #FFFFFF;
    
    @media screen and (max-width: 768px) {
        font-size: 24px;
        line-height: 33px;
    }

    @media screen and (max-width: 480px) {
        font-size: 18px;
    }
`