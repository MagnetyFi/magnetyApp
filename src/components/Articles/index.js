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
    LittleImage,
} from './ArticlesElements';
import art1 from '../../images/art1.png'

const Articles = () => {
    const [hover, setHover] = useState(false)

    const onHover = () => {
        setHover(!hover)
    }
    return (
        <HeroContainer>
            <T1>Readmore</T1>
            <br />
            <HeroContent>
                <Column1 href="https://medium.com/@magnety.finance/magnety-defi-4-all-6414990639e8" target="_blank">
                    <LittleImage src={art1}></LittleImage>
                    <T2>Magnety | Defi 4 All</T2>
                    <br />
                    <T3>We are delighted to announce you the launch of Magnety on Starknet. Magnety is an on-chain asset management protocol that allows anyone, such as investment groups...</T3>
                </Column1>
                <Column2>
                    
                </Column2>
                <Column3>
                    
                </Column3>
            </HeroContent>
        </HeroContainer>
    )
}

export default Articles