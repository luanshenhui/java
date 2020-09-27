import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import { Link } from 'react-router-dom';
import moment from 'moment';

import { FieldGroup, FieldSet, FieldItem, FieldValueList, FieldValue } from '../../components/Field';
import Label from '../../components/control/Label';

const Color = styled('span')`.
  font-weight: bold;
  color: #FF8C00;
`;

const PerPaymentListHeader = ({ data }) => (
  <FieldGroup itemWidth={200}>
    <FieldSet>
      <FieldItem>受診日</FieldItem>
      <Label><Color>{moment(data && data.csldate).format('YYYY/MM/DD')}</Color></Label>
    </FieldSet>
    <FieldSet>
      <FieldItem>予約番号</FieldItem>
      <Label><Color>{data && data.rsvno}</Color></Label>
    </FieldSet>
    <FieldSet>
      <FieldItem>受診コース</FieldItem>
      <Label><Color>{data && data.csname}</Color></Label>
    </FieldSet>
    <FieldSet>
      <FieldItem>{data && data.perid}</FieldItem>
      <FieldValueList>
        <FieldValue>
          <Label><Link to={`/contents/bill/user/${data.lastname}/${data.firstname}/`}>{data && data.lastname} {data && data.firstname}</Link>
            ({data && data.lastkname} {data && data.firstkname})
          </Label>
        </FieldValue>
        <FieldValue>
          <Label>
            {data && moment(data.birth).format('YYYY年M月DD日生')} {Math.round(`${data && data.age}`)}歳 {(data && data.gender === 1) ? ' 男性' : ' 女性'}
          </Label>
        </FieldValue>
      </FieldValueList>
    </FieldSet>
  </FieldGroup>
);

PerPaymentListHeader.propTypes = {
  data: PropTypes.shape().isRequired,
};

export default PerPaymentListHeader;
