import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import { Link } from 'react-router-dom';
import Label from '../../components/control/Label';
import { FieldGroup, FieldSet, FieldValueList, FieldValue } from '../../components/Field';

const Wrapper = styled.div`
  font-size: 1.6em;
  color: #0066cc;
  margin-right:10px;
`;

const OrgHeader = ({ data, match }) => (
  <div >
    <FieldGroup>
      <FieldSet>
        {match.params.orgcd1}-{match.params.orgcd2}
        <FieldValueList>
          <FieldValue><Label>{data.orgkname}</Label></FieldValue>
          <FieldValue><Wrapper><Link to={`/contents/preference/organization/edit/${match.params.orgcd1}/${match.params.orgcd2}/`}>{data.orgname}</Link></Wrapper></FieldValue>
          <FieldValue>
            {data.zipcd !== null ? <Label> {`${data.zipcd}`.substr(0, 3)} -{`${data.zipcd}`.substr(3, 4)}</Label> : ''}
            {data.zipcd === null ? '' : ' '} {data.prefname} {data.cityname} {data.address1}
            {(data.address2 === null) ? '' : `${data.address2}`}
            {(data.tel) ? `TEL：${data.tel}` : ''}
            {(data.chargepost === null) && (data.chargename === null) ? '' : '担当：'}{(data.chargepost === null) ? '' : `${data.chargepost}`}
            {(data.chargepost === null) && (data.chargename === null) ? '' : ' '}
            {(data.chargename === null) ? '' : `${data.chargename}`}
          </FieldValue>
        </FieldValueList>
      </FieldSet>
    </FieldGroup>
  </div>
);
// propTypesの定義
OrgHeader.propTypes = {
  data: PropTypes.shape().isRequired,
  match: PropTypes.shape().isRequired,

};
export default OrgHeader;
