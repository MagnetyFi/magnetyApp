import styled from "styled-components";

export const HeroContainer = styled.div`
    width: 100%;
    padding: 0 5%;
    overflow: hidden;
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
    font-size: 40px;
    line-height: 48px;
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
    text-align: center;
    color: #FFFFFF;

    @media screen and (max-width: 768px){
        font-size: 20px;
        line-height: 25px;
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

export const Column1 = styled.div`
    height: 430px;
    margin: 20px;
    padding: 15px;
    grid-area: col1;

    @media screen and (max-width: 768px){
        height: 300px;
    }
`

export const Column2 = styled.div`
    height: 430px;
    margin: 20px;
    padding: 5px;
    grid-area: col2;

    @media screen and (max-width: 768px){
        height: 300px;
    }
`

export const Column3 = styled.div`
    height: 430px;
    margin: 20px;
    padding: 5px;
    grid-area: col3;

    @media screen and (max-width: 768px){
        height: 300px;
    }
`

export const LittleImage = styled.div`
    border-radius: 100%;
    background: #F6643C;
    margin: auto;
    margin-bottom: 20px;
    width: 250px;
    height: 250px;

    @media screen and (max-width: 768px){
        width: 200px;
        height: 200px;
    }
`