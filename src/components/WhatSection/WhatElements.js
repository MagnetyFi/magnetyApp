import styled from "styled-components";
import deco from '../../images/deco.png'

export const HeroContainer = styled.div`
    width: 100%;
    padding: 0 5%;
    overflow: hidden;
    margin-bottom: 40px;
}
`

export const T1 = styled.span`
    font-weight: 700;
    font-size: 64px;
    line-height: 77px;

    color: #FFFFFF;

    @media screen and (max-width: 768px){
        font-size: 32px;
        line-height: 40px;
    }

`

export const T2 = styled.span`
    font-weight: 400;
    font-size: 32px;
    line-height: 39px;
    text-align: justify;

    color: #FFFFFF;

    @media screen and (max-width: 768px){
        font-size: 15px;
        line-height: 7px;
    }

`
export const T3 = styled.span`
    font-weight: 500;
    font-size: 32px;
    line-height: 39px;

    color: #FFFFFF;

    @media screen and (max-width: 768px){
        font-size: 15px;
        line-height: 7px;
    }
`
export const HeroContent = styled.div`
    display: grid;
    margin-top: 40px;
    margin-bottom: 40px;
    padding: 0 10%;
    grid-auto-columns: 33% 33% 33%;
    align-items: center;
    grid-template-areas: 'col1 col2 col3';

    @media screen and (max-width: 768px){
        padding: 0 2%;
    }
`

export const Column1 = styled.div`
    height: 160px;
    padding: 45px;
    grid-area: col1;
    text-align: left;

    background: #090651;
    /* (first radius values) / top-left | top-right | bottom-right | bottom-left */
    border-radius: 15px 0 0 15px;

    @media screen and (max-width: 768px){
        height: 65px;
        padding: 15px;
    }
`

export const Column2 = styled.div`
    height: 160px;
    padding: 45px;
    grid-area: col2;
    background: #090651;
    text-align: left;

    border-left: solid 1px #F6643C;
    border-right: solid 1px #F6643C;

    @media screen and (max-width: 768px){
        height: 65px;
        padding: 15px;
    }
`

export const Column3 = styled.div`
    height: 160px;
    padding: 45px;
    grid-area: col3;
    text-align: left;
    background: #090651;
    border-radius: 0 15px 15px 0;

    @media screen and (max-width: 768px){
        height: 65px;
        padding: 15px;
    }
`

export const DecoDiv = styled.div`
    height: 500px;
    background-image: url(${deco});
    background-size: contain;
    background-repeat: no-repeat;
    background-position: bottom left;
    margin: 10px -10%;
    padding: 10px 80px;

    @media screen and (max-width: 768px){
        text-align: center;
        height: 170px;
    }
`

export const DlBtn = styled.button`
    margin-left: 60%;
    width: 300px;
    height: 100px;
    background: #F6643C;
    border-radius: 10px;
    font-weight: 400;
    font-size: 32px;
    line-height: 39px;
    text-align: center;
    outline: none;
    border: none;
    cursor: pointer;
    color: #FFFFFF;

    @media screen and (max-width: 768px){
        font-size: 15px;
        line-height: 20px;
        width: 130px;
        height: 55px;
        margin: auto;
    }

    &:hover{
        color: #FFFFFF;
        background: #2A296E;
        transition: ease-in-out 0.3s;
    }
`