import React from 'react';
import PropTypes from 'prop-types';
import moment from 'moment';
import LabelOrgName from '../../../components/control/label/LabelOrgName';
import LabelCourse from '../../../components/control/label/LabelCourse';
import { FieldGroup, FieldSet, FieldItem } from '../../../components/Field';
import Label from '../../../components/control/Label';


const CtrDemandBody = ({ params,
}) => (
  <div>
    <FieldGroup itemWidth={100}>
      <FieldSet>
        <FieldItem>契約団体</FieldItem>
        <LabelOrgName orgcd1={params.orgcd1} orgcd2={params.orgcd2} />
      </FieldSet>
      <FieldSet>
        <FieldItem>対象コース</FieldItem>
        <LabelCourse cscd={params.cscd} />
      </FieldSet>
      <FieldSet>
        <Label>契約期間:{moment(params.strdate).format('YYYY年MM月DD日')}
            ～{moment(params.enddate).format('YYYY年MM月DD日')}
        </Label>
      </FieldSet>
    </FieldGroup>
  </div>
);

// propTypesの定義
CtrDemandBody.propTypes = {
  params: PropTypes.shape(),
};

CtrDemandBody.defaultProps = {
  params: {},
};
export default CtrDemandBody;
