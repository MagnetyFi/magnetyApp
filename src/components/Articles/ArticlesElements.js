import styled from "styled-components";

export const HeroContainer = styled.div`
    width: 100%;
    padding: 0 5%;
    overflow: hidden;
    align-items: center;
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

export const T2 = styled.div`
    font-weight: 600;
    font-size: 32px;
    line-height: 39px;
    text-align: center;

    color: #FFFFFF;

    @media screen and (max-width: 768px){
        font-size: 26px;
        line-height: 30px;
    }
`
export const T3 = styled.div`
    font-weight: 600;
    font-size: 20px;
    line-height: 24px;
    text-align: justify;

    color: #FFFFFF;

    @media screen and (max-width: 768px){
        font-size: 15px;
        line-height: 20px;
    }

`
export const HeroContent = styled.div`
    display: grid;
    margin-top: 10px;
    margin-bottom: 40px;
    padding: 0 5%;
    grid-auto-columns: 33% 33% 33%;
    align-items: center;
    grid-template-areas: 'col1 col2 col3';

    @media screen and (max-width: 768px) {
        grid-template-areas: 'col1 col1 col1' 'col2 col2 col2' 'col3 col3 col3';
    }
`

export const Column1 = styled.a`
    height: 450px;
    margin: 20px;
    padding: 15px;
    grid-area: col1;
    cursor: pointer;
    text-decoration: none;

    background: #29296E;
    /* (first radius values) / top-left | top-right | bottom-right | bottom-left */
    border-radius: 30px;

    @media screen and (max-width: 768px){
        height: 350px;
    }

    &:hover{
        background: #F6643C;
        transition: ease-in-out 0.3s;
    }
`

export const Column2 = styled.div`
    height: 450px;
    margin: 20px;
    padding: 5px;
    grid-area: col2;
    cursor: pointer;

    background: #29296E;
    border-radius: 30px;

    @media screen and (max-width: 768px){
        display: none;
    }
`

export const Column3 = styled.div`
    height: 450px;
    margin: 20px;
    padding: 5px;
    grid-area: col3;
    cursor: pointer;

    background: #29296E;
    border-radius: 30px;

    @media screen and (max-width: 768px){
        display: none;
    }
`

export const LittleImage = styled.img`
    border-radius: 30px;
    margin-bottom: 10px;
    width: 100%;
`