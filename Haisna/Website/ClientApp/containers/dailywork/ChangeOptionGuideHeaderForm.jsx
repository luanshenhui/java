import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import moment from 'moment';
import Label from '../../components/control/Label';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';

const WrapperSpace = styled.span`
  padding: 0 15px;
`;

const ChangeOptionGuideHeader = ({ data, realage }) => (
  <div>
    <FieldGroup itemWidth={75}>
      <FieldSet>
        <FieldItem>受診日</FieldItem>
        <Label><span style={{ color: '#ff6600' }}><strong>{(data.csldate) ? (moment(data.csldate).format('YYYY/MM/DD')) : ''}</strong></span></Label>
        <WrapperSpace />
        <FieldItem>コース</FieldItem>
        <Label><span style={{ color: '#ff6600' }}><strong>{data.csname}</strong></span></Label>
        <WrapperSpace />
        <FieldItem>当日ＩＤ</FieldItem>
        <Label><span style={{ color: '#ff6600' }}><strong>{(data.dayid) ? ((data.dayid).toString().padStart(4, '0')) : ''}</strong></span></Label>
        <WrapperSpace />
        <FieldItem>団体</FieldItem>
        <Label><strong>{data.orgname}</strong></Label>
        <WrapperSpace />
      </FieldSet>
      <FieldSet>
        <Label>{data.perid}</Label>
        <Label><b>{data.lastname}　{data.firstname}</b></Label>
        <Label>（{data.lastkname}　{data.firstkname}）</Label>
        <Label>{(data.csldate) ? (moment(data.birth).format('YYYY年MM日DD')) : ''}生</Label>
        <Label>
          {(data.birth && data.birth != null) ? (Number.parseInt(realage, 10)) : ''}歳({Number.parseInt(data.age, 10)}歳)
        </Label>
        <Label>
          {(data.gender && data.gender === '1') ? '男性' : '女性'}
        </Label>
        <WrapperSpace />
        <FieldItem>受診回数</FieldItem>
        <Label><span style={{ color: '#ff6600' }}><strong>{data.cslcount}</strong></span></Label>
        <WrapperSpace />
      </FieldSet>
    </FieldGroup>
  </div>
);

// propTypesの定義
ChangeOptionGuideHeader.propTypes = {
  data: PropTypes.shape().isRequired,
  realage: PropTypes.number,
};

// defaultPropsの定義
ChangeOptionGuideHeader.defaultProps = {
  realage: null,
};

export default ChangeOptionGuideHeader;
