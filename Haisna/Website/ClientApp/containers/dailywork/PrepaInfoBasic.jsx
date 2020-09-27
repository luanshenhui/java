import React from 'react';
import { Field } from 'redux-form';
import moment from 'moment';
import Label from '../../components/control/Label';
import Button from '../../components/control/Button';
import { FieldGroup, FieldSet, FieldItem, FieldValueList, FieldValue } from '../../components/Field';
import DropDown from '../../components/control/dropdown/DropDown';
import SectionBar from '../../components/SectionBar';

const PrepaInfoBasic = (consult) => (
  <div>
    <FieldGroup itemWidth={80} >
      <SectionBar title="基本情報" />
      <FieldSet>
        <FieldItem>個人名　</FieldItem>
        <FieldValueList>
          {consult.consult && (
            <div>
              <FieldValue>
                <Label>{consult.consult.perid}</Label>
              </FieldValue>
              <FieldValue>
                <Label>{consult.consult.lastname} {consult.consult.firstname}</Label>
                <span style={{ color: '#999999' }}>{consult.consult.lastkname}{consult.consult.firstkname}</span>
              </FieldValue>
              <FieldValue>
                <Label>{consult.consult.birthyearshorteraname}{consult.consult.birtherayear} {moment(consult.consult.birth).format('MM.DD')}生 </Label>
                <Label>{Math.floor(Number(consult.consult.age))}歳 </Label>
                <Label>{(consult.consult.gender === 1) ? '男性' : '女性'}</Label>
              </FieldValue>
            </div>
            )}
        </FieldValueList>
      </FieldSet>
      <FieldSet>
        <FieldItem>団体名　</FieldItem>
        <FieldValueList>
          {consult.org && (
            <div>
              <FieldValue>
                <Label>{consult.org.orgcd1}-{consult.org.orgcd2}</Label>
              </FieldValue>
              <FieldValue>
                <Label>{consult.org.orgname} </Label>
                <span style={{ color: '#999999' }}>{consult.consult.orgkname}</span>
              </FieldValue>
            </div>
          )}
        </FieldValueList>
      </FieldSet>
      <FieldSet>
        <FieldItem>受診回数</FieldItem>
        {consult.consult && (
          <div>
            <FieldValue>
              <Label>{consult.consult.cslcount}</Label>
            </FieldValue>
          </div>
        )}
      </FieldSet>
      <div>
        <Button type="submit" value="保　存" />
      </div>
    </FieldGroup>
    <FieldGroup itemWidth={200}>
      {consult.allInfo && consult.allInfo.map((rec) => (
        <div key={rec.itemname}>
          <FieldSet>
            <FieldItem>{rec.itemname}</FieldItem>
            <Field name={rec.names} component={DropDown} id="stcCd" items={rec.item} addblank blankname="" selectedValue="1" />
          </FieldSet>
        </div>
      ))}
    </FieldGroup>
  </div>
);


export default PrepaInfoBasic;
