import React from 'react';
import {FaBars} from 'react-icons/fa'
import { IconContext } from 'react-icons/lib';
import { animateScroll as scroll } from 'react-scroll';
import{
    Nav, 
    NavBarContainer, 
    NavLogo, 
    NavLogoImg,
    MobileIcon, 
    NavMenu, 
    NavItem,
    NavLinks,
} from './NavbarElements';

const Navbar = ({ toggle }) => {

    const toggleHome = () => {
        scroll.scrollToTop();
    }

    return (
        <>
        <IconContext.Provider value={{color : '#bbb'}}>
            <Nav scrollNav={true}>
                <NavBarContainer>
                    <NavLogo to="/">
                        <NavLogoImg onClick={toggleHome} />
                    </NavLogo>
                    
                    <MobileIcon onClick={toggle}>
                        <FaBars style={{color: "#fff"}}/>
                    </MobileIcon>
                    <NavMenu>
                        <NavItem>
                            <NavLinks to="/">
                                App Soon
                            </NavLinks>
                        </NavItem>
                    </NavMenu> 
                </NavBarContainer>
            </Nav>
        </IconContext.Provider>
        </>
    )
}
 
export default Navbar
