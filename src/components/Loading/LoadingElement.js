import styled from 'styled-components'

export const LoadingContainer = styled.div `
    display: flex;
    justify-content: center;
    items-align: center;
    height: 80vh;
    z-index: 1;
    width: 100%;
    margin-top : 90px;

    @media screen and (max-width: 480px) {
        height: 75vh;
    }
`

export const CVideo = styled.video `
    margin-top: auto;
    margin-bottom: auto;
    height : 250px;
`