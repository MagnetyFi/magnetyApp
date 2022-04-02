import styled from "styled-components";

export const CardDiv = styled.div`
    min-height: 300px;
    padding: 5px;

    transition: all 0.2s ease-in-out;

    &:hover {
        transform: scale(1.02);
        transition: all 0.2s ease-in-out;
        background: rgba(0, 0, 0, 0.02);
    }

    @media screen and (max-width: 768px) {
        margin-bottom: 30px;
        padding: 30px;
    }
`
export const CardImgWrap = styled.div`
    margin-top: 50px;
    position: relative;
    display: flex;
    flex-direction: column;
    justify-content: flex-start;
    align-items: center;
`

export const CardImage = styled.img`
    width: 60%;
    border-radius: 1000px;
    pointer-events: none;
    border: 4px solid #010101;

    &:hover {
        border: 4px solid red;
    }
`

export const CardImageOverlay = styled.div`
    z-index: 1;
    position: absolute;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    border-radius: 25px;
    padding: 45px 45px 45px 45px;

    background: rgba(0, 0, 0, 0.6);
    
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    opacity: 0;


    &:hover {
        opacity: 1;
        transform: scale(1.02);
        transition: all 0.2s ease-in-out;
    };

    @media screen and (max-width: 768px) {
        padding: 10px 75px 10px 75px;
    }
`

export const Name = styled.div`
    height: 60px;   
    text-align: center;
    vertical-align: middle;
    margin-top: 24px;
    color: #010101;
    font-size: 27px;
`

export const School = styled.div`
    text-align: center;
    margin-top: 24px;
    color: #010101;
    font-size: 16px;
`

export const Job = styled.div`
    text-align: center;
    margin-top: 24px;
    color: #010101;
    font-size: 16px;
    height: 25px; 
`

export const SocialIconLink = styled.a`
    color: #010101;
    font-size: 24px;
    margin-left: 8px;
    margin-right: 8px;
    height: 32px;

    &:hover {
        color: #e2001a;
        transition: 0.3s ease-out;
    }
`