import React from 'react';
import PropTypes from 'prop-types';
import moment from 'moment';

import { FieldGroup, FieldSet, FieldItem } from '../../../components/Field';
import Label from '../../../components/control/Label';

const ContractGuideHeader = ({ data, strong }) => (
  <FieldGroup itemWidth={90}>
    <FieldSet>
      <FieldItem>契約団体</FieldItem>
      <Label>{strong ? <strong>{data && data.orgname}</strong> : <span>{data && data.orgname}</span>}</Label>
    </FieldSet>
    <FieldSet>
      <FieldItem>対象コース</FieldItem>
      <Label>{strong ? <strong>{data && data.csname}</strong> : <span>{data && data.csname}</span>}</Label>
    </FieldSet>
    <FieldSet>
      <FieldItem>契約期間</FieldItem>
      <Label>{strong ? <strong>{moment(data && data.strdate).format('YYYY年MM月DD日')}</strong> : <span>{moment(data && data.strdate).format('YYYY年MM月DD日')}</span>}</Label>
      <Label>～</Label>
      <Label>{strong ? <strong>{moment(data && data.enddate).format('YYYY年MM月DD日')}</strong> : <span>{moment(data && data.enddate).format('YYYY年MM月DD日')}</span>}</Label>
    </FieldSet>
  </FieldGroup>
);

// propTypesの定義
ContractGuideHeader.propTypes = {
  data: PropTypes.shape().isRequired,
  strong: PropTypes.bool,
};

ContractGuideHeader.defaultProps = {
  strong: undefined,
};

export default ContractGuideHeader;
