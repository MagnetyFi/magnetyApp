import React from 'react'
import { FaUnlink, FaLinkedinIn } from 'react-icons/fa'
import NoPhoto from '../../images/no_photo.png'

import { CardDiv,
         CardImgWrap,
         CardImage,
         Name,
         School,
         Job,
         SocialIconLink
} 
from './AlumniCardElement'

const Alumnicard = ({
  prenom,
  nom,
  promo,
  ecole,
  job,
  photo,
  country,
  lkurl,
  cname
}) => {
  return (
    <CardDiv>
      <CardImgWrap>
        <CardImage
            src={photo[0] === 'h' ? photo : NoPhoto}
            onError={({ currentTarget }) => {
              currentTarget.onerror = null; // prevents looping
              currentTarget.src=NoPhoto;
            }}
        />
      </CardImgWrap>
      <Name>{prenom.toUpperCase()} {nom}</Name>
      <School>🧑‍🎓 {promo} : {ecole}</School>
      <School>💼 {cname}</School>
      <School>🌎 {country.split(',')[0]}</School>
      <Job>{job.slice(0, 30)}{job[31] === null ? "" : ".."}</Job>
      <br />
      {lkurl !== "" &&
        <SocialIconLink href={lkurl} target="_blank">
          <FaLinkedinIn/>
        </SocialIconLink>
      }
      {lkurl === "" &&
        <SocialIconLink >
          <FaUnlink/>
        </SocialIconLink>
      }
    </CardDiv>
  )
}

export default Alumnicard