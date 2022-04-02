import React from 'react'
import {ProgContainer,
} from './ProgElement.js'

const About = () => {
  return (
    <ProgContainer>
      <br />
      <h1>This Page Is Under Construction</h1>
      <br />
      <span>About is coming, stay tuned</span>
      <br />
      <br />
      <iframe style={{height: "50vh", width: "90vw", maxWidth: "800px"}} src="https://www.youtube.com/embed/izGwDsrQ1eQ" title="YouTube video player" allowautoplay allowfullscreen></iframe>
    </ProgContainer>
  )
}

export default About;