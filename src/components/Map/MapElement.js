import styled from 'styled-components'

export const Container = styled.div `
    justify-content: center;
    items-align: center;
    text-align: center;
    height: 80vh;
    z-index: 1;
    width: 100%;
    background: #F6F7F8;
    margin-top: 90px;

    @media screen and (max-width: 480px) {
        height: 75vh;
    }
`