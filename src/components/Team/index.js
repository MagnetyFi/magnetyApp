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
} from './TeamElements';
import art1 from '../../images/art1.png'

const Team = () => {
    const [hover, setHover] = useState(false)

    const onHover = () => {
        setHover(!hover)
    }
    return (
        <HeroContainer>
            <T1>Our Team</T1>
            <br />
            <HeroContent>
                <Column1>
                    <LittleImage></LittleImage>
                    <T2>Sacha G.</T2>
                    <br />
                    <T3>...</T3>
                </Column1>
                <Column2>
                    <LittleImage></LittleImage>
                    <T2>Mathieu M.</T2>
                    <br />
                    <T3>...</T3>
                </Column2>
                <Column3>
                    <LittleImage></LittleImage>
                    <T2>Tech G.</T2>
                    <br />
                    <T3>...</T3>
                </Column3>
            </HeroContent>
        </HeroContainer>
    )
}

export default Team