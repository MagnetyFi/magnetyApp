import React, { useState } from "react";
import { FaSearch } from "react-icons/fa";

import {
    CardsContainer,
    FilterBtn,
    CardsDiv,
    CardsWrap,
    CustomCol,
    CustomRow,
} from "./CardsElements";
import Select from 'react-select'
import Alumnicard from "../Alumnicard";
import {
    Row,
    Col
} from 'reactstrap';

import Alumni from "./alumni.json";

function Cards() {
    function GetUnique(dict, label){
        let list = [];
        for(let i in dict){
            list.push(dict[i][label]);
        }
        list = [...new Set(list)];
        list = list.sort();

        let list_values = []
        for(let i in list){
            list_values.push({ value: list[i], label: list[i] })
        }
        
        return list_values;
    }

    // Promo
    const promos = GetUnique(Alumni, "promo");
    const [selectedPromos, setSelectedPromos] = useState([]);
    const handleChangePromos = e => {
        let results = [];
        for(let i in e){
            results.push(e[i].value);
        }
        setSelectedPromos(results);
    }

    // Ecoles
    const ecoles = GetUnique(Alumni, "ecole")
    const [selectedEcoles, setSelectedEcoles] = useState([]);
    const handleChangeEcoles = e => {
        let results = [];
        for(let i in e){
            results.push(e[i].value);
        }
        setSelectedEcoles(results);
    }

    // secteur activité
    const act = GetUnique(Alumni, "sector")
    const [selectedActs, setSelectedActs] = useState([]);
    const handleChangeActs = e => {
        let results = [];
        for(let i in e){
            results.push(e[i].value);
        }
        setSelectedActs(results);
    }

    const [SelectAlumni, setSelectAlumni] = useState(Alumni);
    const Filter = () => {
        //promo
        let promo_r = []
        for(let i in Alumni){
            let thisone = Alumni[i]
            if(selectedPromos.length !== 0){
                if(selectedPromos.includes(thisone.promo) ){
                    promo_r.push(thisone);
                }
            }
            else{
                promo_r = Alumni;
            }
        }

        //ecole
        let ecole_r = []
        for(let i in promo_r){
            let thisone = promo_r[i]
            if(selectedEcoles.length !== 0){
                if(selectedEcoles.includes(thisone.ecole) ){
                    ecole_r.push(thisone);
                }
            }
            else{
                ecole_r = promo_r;
            }
        }

        //secteur activité
        let act_r = []
        for(let i in ecole_r){
            let thisone = ecole_r[i]
            if(selectedActs.length !== 0){
                if(selectedActs.includes(thisone.sector) ){
                    act_r.push(thisone);
                }
            }
            else{
                act_r = ecole_r;
            }
        }

        setSelectAlumni(act_r);
    }

    return (
        <>
            <CardsContainer>
                <CardsWrap>
                    <CardsDiv>
                        <br></br>
                        <br></br>
                        <Row xs={1} xl={4} sm={2}>
                            <Col style={{ padding : 12 }}>
                                <Select
                                    options={promos}
                                    placeholder={'Promo'}
                                    isMulti
                                    onChange={handleChangePromos}
                                />
                            </Col >
                            <Col style={{ padding : 12 }}>
                                <Select
                                    options={ecoles}
                                    placeholder={'Ecole'}
                                    isMulti
                                    onChange={handleChangeEcoles}
                                />
                            </Col>
                            <Col style={{ padding : 12 }}>
                                <Select
                                    options={act}
                                    placeholder={'Secteur'}
                                    isMulti
                                    onChange={handleChangeActs}
                                />
                            </Col >
                            <Col style={{ padding : 12, justifyContent : "center" }}>
                                <FilterBtn onClick={Filter} >
                                    <FaSearch style={{color: "inherit"}}/>
                                </FilterBtn>
                            </Col>
                        </Row>
                        <br></br>
                        <span>{SelectAlumni.length === 0 ? "Aucun résultat" : ""}</span>
                        <CustomRow xs={1} xl={4} sm={2} md={2} lg={2}>
                            {[...Array(Object.keys(SelectAlumni).length)].map((e, i) => {
                                return (
                                    <CustomCol>
                                        <Alumnicard {...SelectAlumni[i]} />
                                    </CustomCol>
                                );
                            })}
                        </CustomRow>
                    </CardsDiv>
                </CardsWrap>
            </CardsContainer>
        </>
    );
}

export default Cards;
