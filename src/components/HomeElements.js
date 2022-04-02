import styled from 'styled-components'

export const HomeDivBG = styled.div`
    background: #010101;
    padding: 10px 10px 10px 10px;
`

export const HomeTitleContainer = styled.div`
    height: 220px;
    margin: 20px 100px 20px 100px;
    padding: 24px 24px 24px 24px;

    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    text-align: center;

    background: rgba(99, 154, 61, 0.9);
    background-size: 25px 25px;
/*     background: linear-gradient(
        180deg,
        rgba(63, 64, 63, 1) 0%,
        rgba(162, 165, 164, 1) 100%
    ); */

    border-radius: 15px;
    border: solid;
    border-width: 5px;
    border-color: #fff;

    @media screen and (max-width: 768px) {
        height: 230px;
        margin: 20px 50px 20px 50px;
        padding: 24px 10px 24px 10px;
    }

    @media screen and (max-width: 480px) {
        height: 150px;
        margin: 10px 20px 10px 20px;
        padding: 24px 10px 24px 10px;
    }
`

export const PContainer = styled.div`
    margin: 20px 100px 20px 100px;
    padding: 24px 20px 24px 20px;

    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;

    background: rgba(99, 154, 61, 0.9);
    background-size: 25px 25px;

    border-radius: 15px;
    border: solid;
    border-width: 5px;
    border-color: #fff;
    
    @media screen and (max-width: 768px) {
        margin: 20px 50px 20px 50px;
    }

    @media screen and (max-width: 480px) {
        margin: 10px 20px 10px 20px;
    }
`

export const HomeH3 = styled.h3`
    font-family: 'Press Start 2P';
    font-size: 3rem;
    color: #fff;
    text-align: center;
    margin-bottom: 10px;

    @media screen and (max-width: 768px) {
        font-size: 2rem;
    }

    @media screen and (max-width: 480px) {
        font-size: 1.5rem;
        line-height: 1.7rem;
    }
`

export const HomeH4 = styled.h4`
    font-family: 'Press Start 2P';
    font-size: 2rem;
    color: #fff;
    margin-bottom: 10px;
    text-align: center;

    @media screen and (max-width: 768px) {
        font-size: 1.6rem;
    }

    @media screen and (max-width: 480px) {
        font-size: 1rem;
        line-height: 1.2rem;
    }
`

export const HomeP = styled.p`
    font-size: 1.5rem;
    line-height: 1.8rem;
    text-align: center;
    color: #fff;
    user-select: none;

    @media screen and (max-width: 768px) {
        font-size: 1.3rem;
        line-height: 1.5rem;
    }

    @media screen and (max-width: 480px) {
        font-size: 1rem;
        line-height: 1.2rem;
    }
`

export const Img = styled.img`
    text-align: center;
    margin: auto;
    display: flex;
    width: 80%;
`