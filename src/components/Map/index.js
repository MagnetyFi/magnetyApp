import React from 'react'
import 'leaflet/dist/leaflet.css'
import 'leaflet-defaulticon-compatibility';
import {
  Container,
} from './MapElement.js'

import { MapContainer, TileLayer, Marker, Popup } from 'react-leaflet'
import { icon } from "leaflet"

import LogoImg from '../../images/no_photo.png'
import MarkerImg from '../../images/marker.png'

import Coord from "./coords.json";

const LOGO = icon({
  iconUrl: LogoImg,
  iconSize: [35, 35],
})

const ICON = icon({
  iconUrl: MarkerImg,
  iconSize: [40, 40],
})

const Map = () => {
  return (
    <Container>
      <MapContainer center={[45.786346, 4.763844]} zoom={3} scrollWheelZoom={true} style={{ height:"inherit"}}>
        <TileLayer
          attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
          url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
        />
        <Marker icon={LOGO} position={[45.786346, 4.763844]}>
          <Popup>
            <center>
            emlyon bs <br /> early makers
            </center>
          </Popup>
        </Marker>
        {[...Array(Object.keys(Coord).length)].map((e, i) => {
          return (
            <Marker icon={ICON} position={[Coord[i].lat, Coord[i].lon]} >
              <Popup>
                <center>
                  <b>{Coord[i].country[0].split(',')[0]}</b>
                  <br />
                </center>
              {[...Array(Object.keys(Coord[i].names).length)].map((e, j) => {
                return (
                  <center>
                    {j < 5 &&
                    <>
                      <a href={Coord[i].url[j]} target="_blank">{Coord[i].names[j]}</a>
                      <br />
                    </>
                    }
                    {j === 5 &&
                    <>
                      <span>et {Coord[i].names.length - 5} autres</span>
                      <br />
                    </>
                    }
                  </center>
                )
              })}
              </Popup>
            </Marker>
          );
        })}
      </MapContainer>
    </Container>
  )
}

export default Map;