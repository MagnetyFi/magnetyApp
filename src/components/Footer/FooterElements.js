import styled from "styled-components";
import {Link as LinkR} from 'react-router-dom';
import {Link as LinkS} from 'react-scroll'
import LogoW from '../../images/logo.svg'
import LogoO from '../../images/logo_orange.svg'

export const FooterContainer = styled.footer`
    background-color: #29296E;
`

export const FooterWrap = styled.div`
    padding: 48px 24px;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    max-width: 1300px;
    margin: 0 auto;
`

export const NavLogo = styled(LinkR)`
    height: inherit;
`

export const NavLogoImg = styled.img`
    cursor: pointer;
    content:url(${LogoW});
    padding: 10px;

    justify-self: flex-start;
    display: flex;
    align-items: center;
    height: inherit;

    &:hover {
        content:url(${LogoO});
    }
`

export const FooterLinksContainer = styled.div`
    display: flex;
    justify-content: center;
`

export const FooterLinksWrapper = styled.div`
    display: flex;

    @media screen and (max-width: 820px) {
        flex-direction: column;
    }
`

export const FooterLinkItems = styled.div`
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    margin: 16px;
    text-align: left;
    width: 260px;
    box-sizing: border-box;
    color: #fff;

    @media screen and (max-width: 420px) {
        margin: 0;
        width: 100%;
    }
`

export const FooterLinkTitle = styled.h1`
    font-weight: 700;
    font-size: 32px;
    line-height: 39px;
    color: #FFFFFF;

    @media screen and (max-width: 768px){
        font-size: 20px;
        line-height: 25px;
        margin-top: 10px;
    }
`

export const FooterLink = styled(LinkS)`
    color: #fff;
    text-decoration: none;
    margin-bottom: 0.5rem;
    font-size: 14px;
    cursor: pointer;

    &:hover {
        color: #000;
        transition: 0.3s ease-out;
    }
`

export const FooterLinkDOM = styled(LinkR)`
    color: #fff;
    text-decoration: none;
    margin-bottom: 0.5rem;
    font-size: 14px;
    cursor: pointer;

    &:hover {
        color: #000;
        transition: 0.3s ease-out;
    }
`

export const FooterLinkExt = styled.a`
    text-decoration: none;
    margin-bottom: 0.5rem;
    cursor: pointer;
    font-weight: 400;
    font-size: 28px;
    line-height: 34px;
    display: flex;
    align-items: center;

    color: #FFFFFF;

    @media screen and (max-width: 768px){
        font-size: 18px;
        line-height: 23px;
    }

    &:hover {
        color: #F6643C;
        transition: 0.3s ease-out;
    }
`

export const SocialMedia = styled.section`
    max-width: 1000px;
    width: 100%;
`

export const SocialMediaWrap = styled.div`
    display: flex;
    justify-content: space-between;
    align-items: center;
    max-width: 1100px;
    margin: 40px auto 0 auto;

    @media screen and (max-width: 820px) {
        flex-direction: column;
    }
`

export const SocialLogo = styled(LinkR)`
    color: #fff;
    justify-self: start;
    cursor: pointer;
    text-decoration: none;
    font-size: 1.5rem;
    display: flex;
    align-items: center;
    margin-bottom: 16px;
    font-weight: bold;
    font-style: italic;
    text-shadow: 2px 0 0 #000, -2px 0 0 #000, 0 2px 0 #000, 0 -2px 0 #000, 1px 1px #000, -1px -1px 0 #000, 1px -1px 0 #000, -1px 1px 0 #000;
`

export const WebsiteRights = styled.small`
    font-weight: 400;
    font-size: 24px;
    line-height: 29px;

    color: #FFFFFF;

    @media screen and (max-width: 768px){
        font-size: 13px;
        line-height: 20px;
        margin: 10px 0;
    }
`

export const SocialIcons = styled.div`
    display: flex;
    justify-content: space-between;
    align-items: center;
/*     width: 240px;  uncomment for more icons*/
`

export const SocialIconLink = styled.a`
    color: #fff;
    font-size: 48px;
    margin-left: 8px;
    margin-right: 8px;

    @media screen and (max-width: 768px){
        font-size: 24px;
    }

    &:hover {
        color: #F6643C;
        transition: 0.3s ease-out;
    }
`