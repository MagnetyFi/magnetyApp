import React from 'react'
import { FaTwitter, FaDiscord } from 'react-icons/fa'
import { animateScroll as scroll } from 'react-scroll';
import { 
    FooterContainer, 
    FooterLinkItems, 
    FooterLinksContainer, 
    FooterLinksWrapper, 
    FooterWrap,
    FooterLink,
    FooterLinkDOM,
    FooterLinkTitle,
    SocialMedia,
    NavLogo, 
    NavLogoImg,
    SocialMediaWrap,
    SocialLogo,
    WebsiteRights,
    SocialIcons,
    SocialIconLink,
    FooterLinkExt
} from './FooterElements'

const Footer = () => {

    const toggleHome = () => {
        scroll.scrollToTop();
    }

    return (
        <FooterContainer>
            <FooterWrap>
                <FooterLinksContainer>
                    <FooterLinksWrapper>
                        <FooterLinkItems>
                            <FooterLinkTitle>About</FooterLinkTitle>
                            <FooterLinkExt href="https://magnety.notion.site/magnety/Magnety-538f55a2ee1d4a39b8ed2141beb5e383" target="_blank">Documentation</FooterLinkExt>
                            <FooterLinkExt href="https://medium.com/@magnety.finance/" target="_blank">Medium</FooterLinkExt>
                            <FooterLinkExt href="/">WhitePaper</FooterLinkExt>
                        </FooterLinkItems>
                        <FooterLinkItems>
                            <FooterLinkTitle>Stay In Touch</FooterLinkTitle>
                            <FooterLinkExt href="https://twitter.com/magnetyfi" target="_blank">Twitter</FooterLinkExt>
                            <FooterLinkExt href="https://discord.com/invite/9ZKvRjKBCX" target="_blank">Discord</FooterLinkExt>
                        </FooterLinkItems>
                        <FooterLinkItems></FooterLinkItems>
                        <FooterLinkItems></FooterLinkItems>
                    </FooterLinksWrapper>
                    <FooterLinksWrapper>
                        
                    </FooterLinksWrapper>
                </FooterLinksContainer>
                <SocialMedia>
                    <SocialMediaWrap>
                        <NavLogo to="/">
                            <NavLogoImg onClick={toggleHome} />
                        </NavLogo>
                        <WebsiteRights>© {new Date().getFullYear()} All rights reserved.</WebsiteRights>
                        <SocialIcons>
                            <SocialIconLink href="https://twitter.com/magnetyfi" target="_blank" aria-label="Twitter">
                                <FaTwitter/>
                            </SocialIconLink>
                            <SocialIconLink href="https://discord.com/invite/9ZKvRjKBCX" target="_blank" aria-label="Discord">
                                <FaDiscord/>
                            </SocialIconLink>
                        </SocialIcons>
                    </SocialMediaWrap>
                </SocialMedia>
            </FooterWrap>
        </FooterContainer>
    )
}

export default Footer