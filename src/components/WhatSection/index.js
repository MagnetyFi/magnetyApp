import React, { useState } from 'react'
import {
    HeroContainer,
    HeroContent,
    Column1,
    Column2,
    Column3,
    T1,
    T2,
    T3,
    DecoDiv,
    DlBtn,
} from './WhatElements';
import { Button } from '../ButtonElements';

const WhatSection = () => {
    const [hover, setHover] = useState(false)

    const onHover = () => {
        setHover(!hover)
    }
    return (
        <HeroContainer>
            <T1>What is Magnety?</T1>
            <br />
            <T2>Magnety is an asset management system allowing anyone, such as investment groups, DAOs, or individuals to get the most out of DeFi on Starknet through an easy-to-use platform.</T2>
            <HeroContent>
                <Column1>
                    <T3>Non</T3>
                    <br />
                    <T3><b>Clustial</b></T3>
                </Column1>
                <Column2>
                    <T3>Permission</T3>
                    <br />
                    <T3><b>Less</b></T3>
                </Column2>
                <Column3>
                    <T3>Fully</T3>
                    <br />
                    <T3><b>Transparent</b></T3>
                </Column3>
            </HeroContent>
            <T2>You’re curious about DeFi, you want to learn more about Magnety, you want to discover our protocols and features. All of these contents are available on our WhitePaper:</T2>
            <DecoDiv>
                <DlBtn>Download</DlBtn>
            </DecoDiv>
        </HeroContainer>
    )
}

export default WhatSection