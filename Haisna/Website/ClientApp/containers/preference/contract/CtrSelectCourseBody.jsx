import React from 'react';
import PropTypes from 'prop-types';
import { Field } from 'redux-form';
import styled from 'styled-components';
import { FieldGroup, FieldSet, FieldItem, FieldValueList, FieldValue } from '../../../components/Field';
import DropDownCourse from '../../../components/control/dropdown/DropDownCourse';
import LabelOrgName from '../../../components/control/label/LabelOrgName';
import * as contants from '../../../constants/common';
import Radio from '../../../components/control/Radio';
import BulletedLabel from '../../../components/control/BulletedLabel';

const WrapperBullet = styled.div`
  .bullet { color: #cc9999 };
`;

const CtrSelectCourseBasic = ({ actmode, params }) => (
  <div>
    <FieldGroup itemWidth={90}>
      <FieldSet>
        <FieldItem>契約団体</FieldItem>
        <LabelOrgName orgcd1={params.orgcd1} orgcd2={params.orgcd2} />
      </FieldSet>
    </FieldGroup>
    {(actmode === contants.OPMODE_BROWSE) ?
      <WrapperBullet>
        <BulletedLabel>参照、またはコピーのいずれかの処理方法を選択して下さい。</BulletedLabel>
      </WrapperBullet>
      : ''}
    {(actmode === contants.OPMODE_BROWSE) ?
      <FieldGroup itemWidth={100}>
        <FieldSet>
          <Field component={Radio} name="opmode" label="契約情報を参照する" checkedValue={contants.OPMODE_BROWSE} />
          ・・・・・
          <FieldValueList>
            <FieldValue>
              <span style={{ color: '#666666' }}>参照する契約情報を所有する契約団体と、契約期間・受診項目・負担情報の全ての契約内容を共有します。</span>
            </FieldValue>
            <FieldValue>
              <span style={{ color: '#666666' }}>参照先の契約内容が修正されると、その内容が自契約情報に反映されます。</span>
            </FieldValue>
          </FieldValueList>
        </FieldSet>
        <FieldSet>
          <Field component={Radio} name="opmode" label="契約情報をコピーする" checkedValue={contants.OPMODE_COPY} />・・・・・
          <FieldValueList>
            <FieldValue>
              <span style={{ color: '#666666' }}>コピー対象となる契約情報から受診項目・負担情報の内容をコピーし、そのまま自団体の新しい契約情報として保存します。</span>
            </FieldValue>
            <FieldValue>
              <span style={{ color: '#666666' }}>コピーした契約内容を適用する契約期間についてはここで指定します。</span>
            </FieldValue>
          </FieldValueList>
        </FieldSet>
      </FieldGroup> : ''}
    <WrapperBullet>
      {(actmode === contants.OPMODE_BROWSE) ?
        <BulletedLabel>契約情報の参照、またはコピーを行うコースを選択して下さい。</BulletedLabel>
        :
        <BulletedLabel>新しい契約情報を作成するコースを選択して下さい。</BulletedLabel>}
    </WrapperBullet>
    <FieldGroup itemWidth={90}>
      <FieldSet>
        <FieldItem>対象コース</FieldItem>
        <Field name="cscd" component={DropDownCourse} mode={1} addblank />
      </FieldSet>
    </FieldGroup>
  </div>
);
// propTypesの定義
CtrSelectCourseBasic.propTypes = {
  actmode: PropTypes.string.isRequired,
  params: PropTypes.shape().isRequired,

};

export default CtrSelectCourseBasic;
