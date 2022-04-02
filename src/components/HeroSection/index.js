import React, {useState} from 'react'
import Reflexion from '../../images/reflexion.png'
import {
    HeroContainer,
    HeroContent,
    HeroH1,
    HeroP,
    Column1,
    Column2,
} from './HeroElements';

const HeroSection = () => {
    const [hover, setHover] = useState(false)

    const onHover= () => {
        setHover(!hover)
    }
    return (
        <HeroContainer>
            <HeroContent>
                <Column1>
                    <img src={Reflexion} style={{width: "75%"}}></img>
                </Column1>
                <Column2>
                    <HeroH1>Magnety Finance</HeroH1>
                    <HeroP>Your asset management</HeroP>
                    <HeroP>system</HeroP>
                </Column2>
            </HeroContent>
        </HeroContainer>
    )
}

export default HeroSection