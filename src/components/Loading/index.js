import React from 'react'
import test from '../../videos/logoanimation.mp4'
import {LoadingContainer,
        CVideo,
} from './LoadingElement.js'

const Loading = () => {
  return (
    <LoadingContainer>
        <CVideo autoPlay muted src={test} type='video/mp4' playbackRate = {25} />
    </LoadingContainer>
  )
}

export default Loading;