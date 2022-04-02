import React, {useState} from 'react'
import {
    HeroContainer,
    HeroContent,
    T1,
    T2,
    T3,
} from './StarknetElements';

const Starknet = () => {
    const [hover, setHover] = useState(false)

    const onHover= () => {
        setHover(!hover)
    }
    return (
        <HeroContainer>
            <HeroContent>
                <T1>The best chain</T1>
                <T2>Starknet</T2> 
                <T3>Learn more here</T3> 
            </HeroContent>
        </HeroContainer>
    )
}

export default Starknet