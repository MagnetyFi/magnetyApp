import React, { useState } from 'react'

import Sidebar from '../components/Sidebar'
import Navbar from '../components/Navbar'
import Footer from '../components/Footer'
import HeroSection from '../components/HeroSection'
import Starknet from '../components/Starknet'
import WhatSection from '../components/WhatSection'
import Articles from '../components/Articles'
import Team from '../components/Team'

const Home = () => {
    const [isOpen, setIsOpen] = useState(false)

    const toggle = () => {
        setIsOpen(!isOpen)
    }

    return (
        <>
            <Sidebar isOpen={isOpen} toggle={toggle} />
            <Navbar toggle={toggle} />
            <HeroSection />
            <Starknet />
            <WhatSection />
            <Articles />
            <Team />
            <Footer />
        </>
    )
}

export default Home
